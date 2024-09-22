import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Modal/rider.dart';

class RiderDetailScreen extends StatelessWidget {
  final Rider rider;

  const RiderDetailScreen({Key? key, required this.rider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rider.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rider ID: ${rider.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${rider.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: ${rider.phone}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Current Ride Status: ${rider.currentRideStatus}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Ride History:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: rider.rideHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(rider.rideHistory[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
