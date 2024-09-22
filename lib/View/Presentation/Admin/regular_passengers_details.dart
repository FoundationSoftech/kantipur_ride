import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Modal/regular_passenger.dart';
import '../../../Modal/rider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegularPassengerDetailScreen extends StatelessWidget {
  final RegularPassenger regularPassenger;

  const RegularPassengerDetailScreen({Key? key, required this.regularPassenger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(regularPassenger.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rider ID: ${regularPassenger.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${regularPassenger.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: ${regularPassenger.phone}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Current Ride Status: ${regularPassenger.currentRideStatus}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Ride History:', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: regularPassenger.rideHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(regularPassenger.rideHistory[index]),
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
