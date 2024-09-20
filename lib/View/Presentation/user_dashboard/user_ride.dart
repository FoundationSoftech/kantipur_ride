import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/passenger_ride_tracking.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/ride_confirm.dart';

class RideSharingScreen extends StatefulWidget {
  @override
  _RideSharingScreenState createState() => _RideSharingScreenState();
}

class _RideSharingScreenState extends State<RideSharingScreen> {
  GoogleMapController? mapController;
  Set<Polyline> _polylines = {};
  LatLng sourceLocation = LatLng(27.7172, 85.3240); // Initial position (source)
  LatLng? destinationLocation;
  Marker? destinationMarker;

  String? sourceAddress;
  String? destinationAddress;

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}"
            .trim();
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return "Unknown location"; // Provide a default or more meaningful error message.
  }

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng(sourceLocation).then((address) {
      setState(() {
        sourceAddress = address;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: sourceLocation,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _createMarkers(),
            polylines: _polylines, // Display polylines for the route
          ),

          // Action buttons
          Positioned(
            right: 16,
            top: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Action for checking ride status or similar
                  },
                  child: Icon(Icons.check),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    // Action for settings or layers
                  },
                  child: Icon(Icons.settings),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
                SizedBox(height: 10.h),
                FloatingActionButton(
                  onPressed: _goToMyLocation, // Center map on user location
                  child: Icon(Icons.my_location),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
              ],
            ),
          ),

          // Search bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6.r,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      onSubmitted: _searchDestination, // Perform search
                      decoration: InputDecoration(
                        hintText: "Search destination",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Action for adding a destination
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom saved addresses panel as a persistent bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  // Create markers for the source and destination
  Set<Marker> _createMarkers() {
    return {
      if (destinationMarker != null) destinationMarker!,
      Marker(
        markerId: MarkerId("source"),
        position: sourceLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  // Function to draw a route using the Google Directions API
  Future<void> _drawRoute(LatLng origin, LatLng destination) async {
    final apiKey = 'AIzaSyD7hi_cOIPnZHqUShJ6bJNJyqWjGpOawBs';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('API Response: $data'); // Log the response for debugging
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final route = routes.first;
        final polyline = route['overview_polyline']['points'];
        final PolylinePoints polylinePoints = PolylinePoints();
        final List<PointLatLng> points =
            polylinePoints.decodePolyline(polyline);
        final List<LatLng> latLngPoints = points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        if (points.isEmpty) {
          print('No points decoded from polyline');
        }

        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId("route"),
            points: latLngPoints,
            color: Colors.greenAccent, // Currently set to blue
            width: 5,
          ));
        });
      } else {
        print("No routes found");
      }
    } else {
      print("Error fetching directions: ${response.statusCode}");
    }
  }

  // Function to go to the user's location (stubbed here, requires location services)
  void _goToMyLocation() {
    // Logic to center the map on the user's current location.
  }

  // Build the bottom sheet dynamically with updated address
  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Information and Vehicle Details
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/user.png'),
                // Replace with actual image
                radius: 20,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harry Harry',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Gausala', style: TextStyle(fontSize: 12.sp)),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  Icon(Icons.message, color: Colors.blue),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Dynamic Journey Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the current location (source) address
                  Text(
                    'Pickup Location:',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  Text(
                    sourceAddress ?? 'Loading...',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 5.h),
                  // Display the destination address
                  Text(
                    'Destination:',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                  Text(
                    destinationAddress ?? 'Searching for destination...',
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '00:05:20',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          // Fare Display
          Text('Total fair Rs.105',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10.h,
          ),
          CustomButton(
              text: 'Confirm Ride',
              onPressed: () {
                Get.to(() => RideConfirmationScreen(), transition: Transition.upToDown);
              })
        ],
      ),
    );
  }

  // Function to search destination and update address
  void _searchDestination(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng dest =
            LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          destinationLocation = dest;
          destinationMarker = Marker(
            markerId: MarkerId("destination"),
            position: dest,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
          mapController?.animateCamera(CameraUpdate.newLatLngZoom(dest, 14));
        });

        // Fetch address for the destination
        String address = await _getAddressFromLatLng(dest);
        setState(() {
          destinationAddress = address;
        });

        // Fetch and draw the route from the source to the destination
        await _drawRoute(sourceLocation, dest);
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }
}
