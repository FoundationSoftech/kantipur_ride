import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Modal/passenger.dart';

class PassengerDetailScreen extends StatelessWidget {
  final Passenger passenger;

  const PassengerDetailScreen({Key? key, required this.passenger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(passenger.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Passenger ID: ${passenger.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${passenger.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: ${passenger.phone}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Current Ride Status: ${passenger.currentRideStatus}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Ride History:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: passenger.rideHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(passenger.rideHistory[index]),
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
