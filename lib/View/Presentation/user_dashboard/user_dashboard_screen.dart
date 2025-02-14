import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kantipur_ride/View/Presentation/Rental/rental_onboarding.dart';
import 'package:kantipur_ride/View/Presentation/restaurant/restaurant_screen.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/user_profile.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/ride_sharing_screen.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/user_recent_rides.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import '../../../Components/map_example.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/recent_ride_controller.dart';
import '../../../controller/shared_preferences.dart';
import '../../../services/web_socket_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class UserDashboardScreen extends StatefulWidget {
  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String currentAddress = "Fetching current location...";

  Timer? locationTimer;
  final UserWebSocketService userWebSocket = UserWebSocketService();
  bool isConnecting = true;


  Future<void> _initializeServices() async {
    try {
      setState(() => isConnecting = true);

      if (!userWebSocket.isConnected) {
        await userWebSocket.reconnect();
      }

      print("WebSocket Connected: ${userWebSocket.isConnected}");
      print("Socket ID: ${userWebSocket.socketId}");

      _getCurrentLocation();
      locationTimer = Timer.periodic(Duration(minutes: 1), (_) => _getCurrentLocation());
    } catch (e) {
      print("Error initializing services: $e");
    } finally {
      setState(() => isConnecting = false);
    }
  }
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          currentAddress = "Location services are disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            currentAddress = "Location permissions are denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          currentAddress = "Location permissions are permanently denied.";
        });
        return;
      }

      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          currentAddress = "${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
        });

        // Send location update to backend (if necessary)
        // _sendLocationToBackend(position.latitude, position.longitude);
      } else {
        setState(() {
          currentAddress = "Could not fetch location";
        });
      }
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        currentAddress = "Could not fetch location";
      });
    }
  }



  @override
  void dispose() {
    locationTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _getCurrentLocation();
    // locationTimer = Timer.periodic(Duration(minutes: 1), (_) => _getCurrentLocation());
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kantipur Ride', style: TextStyle(color: AppColors.primaryColor)),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfile()));
              },
                child: Icon(Icons.account_circle, color: Colors.grey)),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8.w),
                Text(
                  currentAddress,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

              SizedBox(height: 16.h),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RideSharingScreen()));
                    },
                      child: ServiceOption(icon: Icons.motorcycle, label: 'Ride')),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RentalOnboarding()));
                      },
                      child: ServiceOption(icon: Icons.directions_car, label: 'Rental')),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RestaurantScreen()));
                      },
                      child: ServiceOption(icon: Icons.fastfood, label: 'Restaurant')),
                  ServiceOption(icon: Icons.local_shipping, label: 'Parcel'),
                  ServiceOption(icon: Icons.shopping_basket, label: 'Bazaar'),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapExample()),
                        );

                        if (selectedLocation != null) {
                          // Update the search field with the selected location
                          setState(() {
                            _searchController.text = selectedLocation;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Destination',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              buildRecentRidesSection(),
            ],
          ),
        ),
      ),

    );
  }



  Widget buildRecentRidesSection() {
    final RecentRidesController controller = Get.put(RecentRidesController());

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Rides",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 10.h),
          if (controller.isLoading.value)
            Column(
              children: List.generate(3, (index) => buildShimmerRideTile()),
            )
          else if (controller.recentRides.isEmpty)
            Center(
              child: Text(
                'No recent rides found',
                style: TextStyle(fontSize: 16.sp),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentRides.length,
              itemBuilder: (context, index) {
                final ride = controller.recentRides[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text("Ride to ${ride.destinationPlaceName}"),
                    subtitle: Text(
                        "₨${ride.fare.toStringAsFixed(0)} | ${ride.distance.toStringAsFixed(1)} KM | ${ride.duration} mins"
                    ),
                  ),
                );
              },
            ),
        ],
      );
    });
  }

  Widget buildShimmerRideTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: ListTile(
          leading: Container(width: 40, height: 40, color: Colors.white),
          title: Container(width: double.infinity, height: 16, color: Colors.white),
          subtitle: Container(width: double.infinity, height: 12, color: Colors.white),
        ),
      ),
    );
  }
}


class ServiceOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 48, color:AppColors.primaryColor),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class DestinationOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const DestinationOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

