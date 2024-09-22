import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async'; // Add this import for Timer
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/ride_completion_screen.dart';

import '../../../utils/dt_colors.dart';

class RideConfirmationScreen extends StatefulWidget {
  @override
  _RideConfirmationScreenState createState() => _RideConfirmationScreenState();
}

class _RideConfirmationScreenState extends State<RideConfirmationScreen> {
  // Initial map camera position (coordinates of the location)
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.7172, 85.3240), // Coordinates of Kathmandu
    zoom: 12,
  );

  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();

    // Start a timer that shows the alert after 10 seconds
    Timer(Duration(seconds: 10), () {
      _showThankYouDialog();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  // Function to show the Thank You alert dialog
  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Text("Thank you for the ride!",style: GoogleFonts.openSans(
            color: AppColors.primaryColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(()=> RideCompletionPage(pickupAddress: '', dropOffAddress: 'dropOffAddress', fare: 1000, tripDuration: 'tripDuration', tripDistance: ''));
              },
              child: Text("OK",style: GoogleFonts.openSans(
        color: AppColors.primaryColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        ),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Confirmation",style: GoogleFonts.openSans(
        color: AppColors.primaryColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Driver Information Section
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/81.jpg'), // Placeholder driver image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Rating: 4.8 ★",style: GoogleFonts.openSans(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    ),),
                    Text("Vehicle: Tesla Model X",style: GoogleFonts.openSans(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    ),),
                  ],
                ),
              ],
            ),
          ),
          Divider(),

          // Ride Details Section
          Expanded(
            child: Column(
              children: [
                // Estimated Time of Arrival (ETA)
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text("Estimated Arrival",style: GoogleFonts.openSans(
    color: AppColors.primaryColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    ),),
                  subtitle: Text("5 mins",style: GoogleFonts.openSans(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),),
                ),

                // Ride Route Map (Actual Map with Google Maps)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: _initialPosition,
                      markers: {
                        Marker(
                          markerId: MarkerId('pickup'),
                          position: LatLng(37.7749, -122.4194), // Example Pickup Location
                          infoWindow: InfoWindow(title: "Pickup Location"),
                        ),
                        Marker(
                          markerId: MarkerId('destination'),
                          position: LatLng(37.7749, -122.431297), // Example Destination Location
                          infoWindow: InfoWindow(title: "Destination"),
                        ),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ride Actions Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Call Driver Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement call driver action
                  },
                  icon: Icon(Icons.phone),
                  label: Text("Call Driver"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),

                // Cancel Ride Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement cancel ride action
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Cancel Ride"),
                          content: Text("Are you sure you want to cancel the ride?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Cancel ride logic here
                                Navigator.of(context).pop();
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.cancel),
                  label: Text("Cancel Ride"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
