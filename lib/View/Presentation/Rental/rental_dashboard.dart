import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/Rental/vehicles_detail_screen.dart';

class RentalDashboard extends StatefulWidget {
  const RentalDashboard({super.key});

  @override
  State<RentalDashboard> createState() => _RentalDashboardState();
}

class _RentalDashboardState extends State<RentalDashboard> {

  final TextEditingController _searchController = TextEditingController();
  String currentAddress = "Fetching current location...";


  // List of vehicle options with image paths (replace with your actual images)
  List<Map<String, String>> vehicles = [
    {'name': 'Car', 'image': 'assets/rent.jpeg'},
    {'name': 'Bicycle', 'image': 'assets/rent.jpeg'},
    {'name': 'Bike', 'image': 'assets/rent.jpeg'},
    // Add more vehicles as needed
    {'name': 'Car', 'image': 'assets/rent.jpeg'}, // Repeat for 10 rows
    {'name': 'Bicycle', 'image': 'assets/rent.jpeg'},
    {'name': 'Bike', 'image': 'assets/rent.jpeg'},
    {'name': 'Car', 'image': 'assets/rent.jpeg'},
    {'name': 'Bicycle', 'image': 'assets/rent.jpeg'},
    {'name': 'Bike', 'image': 'assets/rent.jpeg'},
    {'name': 'Car', 'image': 'assets/rent.jpeg'},
    {'name': 'Bicycle', 'image': 'assets/rent.jpeg'},
    {'name': 'Bike', 'image': 'assets/rent.jpeg'},
    {'name': 'Car', 'image': 'assets/rent.jpeg'},
    {'name': 'Bicycle', 'image': 'assets/rent.jpeg'},
    {'name': 'Bike', 'image': 'assets/rent.jpeg'},
  ];


  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          currentAddress = "Location services are disabled.";
        });
        return;
      }

      // Check for location permissions
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
          currentAddress = "Location permissions are permanently denied, we cannot request permissions.";
        });
        return;
      }

      // If permissions are granted, get the user's current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Get the address from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          currentAddress = "${place.name}, ${place.locality}, ${place.administrativeArea}";
        });
      } else {
        setState(() {
          currentAddress = "Could not fetch location";
        });
      }
    } catch (e) {
      setState(() {
        currentAddress = "Could not fetch location";
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                currentAddress,
                style: GoogleFonts.abel(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.visible,
                maxLines: null,
              ),
            ),

            Image.asset('assets/user.png',height: 40.h,),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 10, // spacing between columns
            mainAxisSpacing: 10, // spacing between rows
            childAspectRatio: 1, // adjust the aspect ratio of items (1:1)
          ),
          itemCount: vehicles.length, // Total vehicle count
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.grey[200], // Background color for each item
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.to(()=>VehiclesDetailScreen(),transition: Transition.upToDown);
                    },
                    child: Image.asset(
                      vehicles[index]['image']!, // Display vehicle image

                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    vehicles[index]['name']!, // Display vehicle name
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),


    )
    );
  }
}
