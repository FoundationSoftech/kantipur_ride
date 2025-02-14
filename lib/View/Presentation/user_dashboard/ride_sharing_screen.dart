import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/controller/ride_sharing_controller.dart';
import 'package:kantipur_ride/services/web_socket_services.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/shared_preferences.dart';

class RideSharingScreen extends StatefulWidget {
  @override
  _RideSharingScreenState createState() => _RideSharingScreenState();
}

class _RideSharingScreenState extends State<RideSharingScreen> {


  final UserWebSocketService webSocketService = UserWebSocketService(); // Singleton instance
  GoogleMapController? mapController;
  Set<Polyline> _polylines = {};
  LatLng? sourceLocation;
  LatLng? destinationLocation;
  Marker? sourceMarker;
  Marker? destinationMarker;
  String? sourceAddress;
  String? destinationAddress;
  String currentAddress = "Fetching current location...";
  String? distance;
  String? duration;
  String? price;
  final String apiKey = 'AIzaSyBw9VKmwCrmGzw9GXTm2QwJIOl40ag_Ick'; // Ensure to store this securely in production
  final TextEditingController destinationTextController = TextEditingController();

  String rideType = "bike"; // Set a default value or update it as needed

  bool rideAccepted = false;  // Track if the ride is accepted
  Map<String, dynamic> driverDetails = {};  // Store driver details

  Function(Map<String, dynamic>)? onRideStatusUpdate;
  final userWebSocket = UserWebSocketService();

  final RideSharingController rideSharingController = Get.put(RideSharingController());
  final PrefrencesManager prefrencesManager = PrefrencesManager();

  @override
  void initState() {
    super.initState();
    _initialize();  // Initial setup like location fetching
    setupRideAcceptanceListener();
    setupRideCancelListener();
    webSocketService.socket?.on('ride-accept', (data) {
      print("Ride accepted event received: $data");
    });

    webSocketService.socket?.on('ride-cancel', (data) {
      print("Ride cancel event received: $data");
    });


    UserWebSocketService().reconnect(); // Reconnect WebSocket on app refresh
  }

  @override
  void dispose() {
    destinationTextController.dispose();
    webSocketService.socket?.clearListeners();  // Remove WebSocket listeners
    webSocketService.disconnect();  // Disconnect WebSocket
    Get.delete<RideSharingController>();
    super.dispose();
  }


  void _initialize() async {
    await _getCurrentLocation();
    // _setupWebSocketListeners();
  }

  void _callDriver(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print("Could not launch phone dialer");
    }
  }

  bool isLoading = false;

  void _searchRide() async {
    // Validate all required fields
    if (sourceLocation == null ||
        destinationLocation == null ||
        distance!.isEmpty ||
        price!.isEmpty ||
        destinationTextController.text.isEmpty) {
      if (Get.isDialogOpen!) {
        Get.back(); // Close the loading dialog safely
      }

      setState(() {
        isLoading = false;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        Get.snackbar("Error", "Please fill in all ride details.",
            snackPosition: SnackPosition.BOTTOM);
      });
      return;
    }

    try {
      await rideSharingController.createRide(); // Proceed with creating the ride

      if (Get.isDialogOpen == true) {
        Get.back(); // Close the loading dialog safely
      }


      setState(() {
        isLoading = false;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        Get.snackbar("Success", "Ride created successfully.",
            snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back(); // Close the loading dialog safely
      }

      setState(() {
        isLoading = false;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        Get.snackbar("Error", "Failed to create ride: ${e.toString()}",
            snackPosition: SnackPosition.BOTTOM);
      });
    }
  }


  Widget _buildSearchRideButton() {
    return CustomButton(
      onPressed: _searchRide,
      text: "Search Ride",
      textColor: Colors.white,
      width: double.infinity,
      bottonColor: AppColors.greenColor,
    );
  }




  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        sourceLocation = currentLatLng;
        sourceMarker = _createMarker(currentLatLng, "source", BitmapDescriptor.hueGreen);
      });

      await _getAddressFromLatLng(currentLatLng);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(sourceLocation!, 14));

      // Update sourceLocation in the controller
      rideSharingController.sourceLocation.value = currentLatLng;
    } catch (e) {
      print("Error fetching current location: $e");
    }
  }

  Future<void> _drawRoute(LatLng origin, LatLng destination) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (destination == null) {
          print("Error: Destination location is not set.");
          Get.snackbar("Error", "Please select a valid destination.",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'].first;
          final polylinePoints = PolylinePoints().decodePolyline(route['overview_polyline']['points']);
          final routePoints = polylinePoints.map((point) => LatLng(point.latitude, point.longitude)).toList();

          setState(() {
            _polylines.add(Polyline(
              polylineId: PolylineId("route"),
              points: routePoints,
              color: Colors.greenAccent,
              width: 5,
            ));
            distance = route['legs'][0]['distance']['text'];
            duration = route['legs'][0]['duration']['text'];
            // price = (route['legs'][0]['distance']['value'] / 1000 * 20).toStringAsFixed(2);
            price = (route['legs'][0]['distance']['value'] / 1000 * (rideType == "bike" ? 10 : 20)).toStringAsFixed(2);

          });

          // Update controller fields
          rideSharingController.distance.value = distance!;
          rideSharingController.price.value = price!;
        } else {
          print("No routes found in the API response");
          Get.snackbar("Error", "No routes found. Please select valid locations.",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        print("Error fetching directions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error drawing route: $e");
    }
  }

  Marker _createMarker(LatLng position, String id, double hue) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey'));
      final data = jsonDecode(response.body);

      if (data['results'].isNotEmpty) {
        String? sublocality;
        for (var component in data['results'][0]['address_components']) {
          if (component['types'].contains('sublocality')) {
            sublocality = component['long_name'];
            break;
          }
        }

        if (sublocality != null) {
          setState(() {
            currentAddress = sublocality! + ', ' + data['results'][0]['formatted_address'].split(', ').skip(1).join(', ');
          });
        } else {
          setState(() {
            currentAddress = data['results'][0]['formatted_address'];
          });
        }
      }
    }

    catch (e) {
      print("Error fetching address: $e");
    }
  }

  Future<void> _onPlaceSelected(String description) async {
    print("Place selected: $description");
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$description&inputtype=textquery&fields=geometry&key=$apiKey'));

      final data = jsonDecode(response.body);

      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final location = data['candidates'][0]['geometry']['location'];
        LatLng destinationLatLng = LatLng(location['lat'], location['lng']);

        // Update destination location and address in controller
        rideSharingController.destinationLocation.value = destinationLatLng;
        rideSharingController.destinationAddress.value = description.trim();

        // Set destination text and marker
        setState(() {
          destinationLocation = destinationLatLng;
          destinationTextController.text = description.trim(); // Update text controller
          destinationMarker = _createMarker(destinationLatLng, "destination", BitmapDescriptor.hueBlue);
        });

        // Log the updated destination text
        print("Updated Destination Text: ${destinationTextController.text}");

        // Log the value stored in the controller as well
        print("Controller Destination Text: ${rideSharingController.destinationAddress.value}");

        // Draw the route if both source and destination are set
        if (rideSharingController.sourceLocation.value != null && destinationLocation != null) {
          await _drawRoute(rideSharingController.sourceLocation.value!, destinationLatLng);

          // Calculate distance and price
          double calculatedDistance = _calculateDistance(
              rideSharingController.sourceLocation.value!.latitude,
              rideSharingController.sourceLocation.value!.longitude,
              destinationLatLng.latitude,
              destinationLatLng.longitude);
          rideSharingController.distance.value = "$calculatedDistance km";

          double calculatedPrice = calculatedDistance * 20; // Assume fare rate per km
          rideSharingController.price.value = calculatedPrice.toStringAsFixed(2);

          // Log the calculated values
          print("Distance: ${rideSharingController.distance.value}");
          print("Price: ${rideSharingController.price.value}");
        }
      } else {
        print("No location data found for the selected place.");
        Get.snackbar("Error", "Please select a valid destination.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error selecting place: $e");
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in km
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a =
        sin(dLat/2) * sin(dLat/2) +
            cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
                sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double distance = R * c; // Distance in km
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (pi / 180);
  }

  void setupRideAcceptanceListener() {
    UserWebSocketService().socket?.on('accept-ride', (data) {
      print("Ride accepted event received: $data");

      // Update the rideSharingController with the accepted ride data
      rideSharingController.acceptRide.value = data;
    });
  }

  void setupRideCancelListener() {
    UserWebSocketService().socket?.on('ride-cancel', (data) {
      print("Ride cancel event received: $data");

      // Update the rideSharingController with the accepted ride data
      rideSharingController.cancelRide.value = data;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGoogleMap(),

          Obx(() {
            final request = rideSharingController.acceptRide.value;

            if (request != null) {
              print("Updating UI with accepted ride: $request"); // Debugging print

              return DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.2,
                maxChildSize: 0.6,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ),
                        Text(
                          'Ride Accepted',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Indicate success
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildInfoRow(Icons.location_on, 'Pickup', request['pickupPlaceName']),
                        SizedBox(height: 8.h),
                        _buildInfoRow(Icons.flag, 'Destination', request['destinationPlaceName']),
                        SizedBox(height: 8.h),
                        _buildInfoRow(Icons.attach_money, 'Fare', 'Rs. ${request['fare']}'),
                        SizedBox(height: 8.h),
                        _buildInfoRow(Icons.straighten, 'Distance', '${request['distance']} km'),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  );
                },
              );
            }
            return _buildBottomRideInfoContainer();
          }),
        ],
      ),
    );
  }


  // Helper method to build info row
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: sourceLocation ?? LatLng(27.7172, 85.3240),
        zoom: 14,
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      markers: _createMarkers(),
      polylines: _polylines,
    );
  }

  // Widget _buildTopSearchContainer() {
  //   return Positioned(
  //     top: 20,
  //     left: 16,
  //     right: 16,
  //     child: _buildSearchField(),
  //   );
  // }

  Widget _buildSearchField() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
    decoration: BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
    ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: rideSharingController.destinationTextController,
        boxDecoration: BoxDecoration(
            border: Border(
              top: BorderSide.none,
            )
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search your destination..',
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),

        ),
        googleAPIKey: apiKey,
        debounceTime: 800,
        countries: ["np"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (prediction) async {
          await _onPlaceSelected(prediction.description!);
        },

        itemClick: (prediction) async {
          // Update the text field with the selected option
          rideSharingController.destinationTextController.text = prediction.description!;
          await _onPlaceSelected(prediction.description!);
        },
        textStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildPickUpPlaceField() {
    // Initialize the controller with the current address if it's not already set
    rideSharingController.pickupPlaceController.text = currentAddress;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
        ),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: rideSharingController.pickupPlaceController,
          boxDecoration: BoxDecoration(
              border: Border(
                top: BorderSide.none,
              )
          ),
          textStyle: TextStyle(color: Colors.white),
          googleAPIKey: apiKey,
          debounceTime: 800,
          countries: ["np"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) async {
            await _onPlaceSelected(prediction.description!);
          },
          itemClick: (prediction) async {
            // Update the text field with the selected option
            rideSharingController.pickupPlaceController.text = prediction.description!;
            await _onPlaceSelected(prediction.description!);
          },
        ),
      ),
    );
  }




  Widget _buildBottomRideInfoContainer({bool isLoading = false}) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
        ),
        child: isLoading
            ? _buildShimmerEffect()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ride Type Selection Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRideOption(Icons.two_wheeler, "Moto"),
                _buildRideOption(Icons.directions_car, "Ride"),
                _buildRideOption(Icons.car_rental, "Comfort"),
                _buildRideOption(Icons.local_shipping, "Delivery"),
              ],
            ),
            SizedBox(height: 10.h),

            // Pickup Location
            Row(
              children: [
                Icon(Icons.radio_button_checked, color: Colors.green, size: 18),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildPickUpPlaceField(),
                ),
              ],
            ),

            // Destination Field
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.radio_button_checked, color: Colors.green, size: 18),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildSearchField(),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            _buildDistanceDurationInfo(),
            SizedBox(height: 8.h),
            _buildSearchRideButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return Container(
                width: 60.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              );
            }),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.radio_button_checked, color: Colors.green, size: 18),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  height: 40.h,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.radio_button_checked, color: Colors.green, size: 18),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  height: 40.h,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            height: 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
      ),
    );
  }


  // Helper method to build ride type option
  Widget _buildRideOption(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
      ],
    );
  }


  // Widget _buildBottomRideInfoContainer() {
  //   return Positioned(
  //     bottom: 30,
  //     left: 16,
  //     right: 16,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10.r),
  //         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6)],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           if (rideAccepted)
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("Driver: ${driverDetails['driverName']}"),
  //                 Text("Vehicle: ${driverDetails['vehicle']}"),
  //                 Text("Phone: ${driverDetails['phone']}"),
  //                 ElevatedButton(
  //                   onPressed: () => _callDriver(driverDetails['phone']),
  //                   child: Text("Call Driver"),
  //                 ),
  //               ],
  //             )
  //           else
  //             Column(
  //               children: [
  //                 _buildPickUpPlaceField(),
  //                 SizedBox(height: 10.h),
  //                 if (rideSharingController.distance != null && duration != null)
  //                   _buildDistanceDurationInfo(),
  //                 SizedBox(height: 10.h),
  //                 _buildSearchRideButton(),
  //               ],
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  Widget _buildDistanceDurationInfo() {
    return Center(
      child: Column(
        children: [
          Text('Distance: $distance', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          Text('Duration: $duration', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          Text('Estimated Price: $price', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
        ],
      ),
    );
  }


  Set<Marker> _createMarkers() {
    final markers = <Marker>{};
    if (sourceMarker != null) markers.add(sourceMarker!);
    if (destinationMarker != null) markers.add(destinationMarker!);
    return markers;
  }
}