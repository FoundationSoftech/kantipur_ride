import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Confirmation"),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Rating: 4.8 ★"),
                    Text("Vehicle: Tesla Model X"),
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
                  title: Text("Estimated Arrival"),
                  subtitle: Text("5 mins"),
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
