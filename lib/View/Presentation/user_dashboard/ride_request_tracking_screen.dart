import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/web_socket_services.dart';

class RideRequestTrackingScreen extends StatefulWidget {
  @override
  _RideRequestTrackingScreenState createState() => _RideRequestTrackingScreenState();
}

class _RideRequestTrackingScreenState extends State<RideRequestTrackingScreen> {
  late Map<String, dynamic> rideRequest;
  bool isSearching = true;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finding Driver'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Cancel ride request
            UserWebSocketService().socket?.emit('cancel-ride-request', {
              'rideId': rideRequest['rideId']
            });
            Get.back();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Searching for nearby drivers...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            Text(
              'Pickup: ${rideRequest['pickupPlaceName']}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Destination: ${rideRequest['destinationPlaceName']}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up listeners if needed
    super.dispose();
  }
}