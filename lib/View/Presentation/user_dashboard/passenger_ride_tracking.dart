import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';

class PassengerRideTrackingScreen extends StatefulWidget {
  @override
  _PassengerRideTrackingScreenState createState() => _PassengerRideTrackingScreenState();
}

class _PassengerRideTrackingScreenState extends State<PassengerRideTrackingScreen> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Your Ride"),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Call driver action
            },
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Message driver action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map for ride tracking
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(27.7172, 85.3240), // Driver's current location
              zoom: 14,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            // Add driver marker and route here
          ),

          // Ride information overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
                  // Driver and ride details
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/driver.png'),
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Driver: Harry Harry',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Vehicle: XYZ123'),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('ETA: 5 mins'),
                          Text('Fare: Rs.105', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Cancel ride action
                        },
                        icon: Icon(Icons.cancel),
                        label: Text("Cancel Ride"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Emergency/SOS action
                        },
                        icon: Icon(Icons.warning),
                        label: Text("SOS"),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.appleRedColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
