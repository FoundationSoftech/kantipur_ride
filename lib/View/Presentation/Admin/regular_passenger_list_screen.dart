import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kantipur_ride/View/Presentation/Admin/regular_passengers_details.dart';
import 'package:kantipur_ride/View/Presentation/Admin/rider_detail_screen.dart';
import '../../../Modal/regular_passenger.dart';
import '../../../Modal/rider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegularPassengerListScreen extends StatelessWidget {
  final List<RegularPassenger> regularPassengers = [
    RegularPassenger(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      rideHistory: ['Ride 1', 'Ride 2', 'Ride 3'],
      currentRideStatus: 'Completed',
      profilePictureUrl: ''
    ),
    RegularPassenger(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      phone: '+0987654321',
      rideHistory: ['Ride A', 'Ride B'],
      currentRideStatus: 'Active',
      profilePictureUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Records'),
      ),
      body: regularPassengers.isEmpty
          ? Center(child: Text('No riders available.'))
          : ListView.builder(
        itemCount: regularPassengers.length,
        itemBuilder: (context, index) {
          final regularPassenger = regularPassengers[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(20),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(regularPassenger.name),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${regularPassenger.email}'),
                    SizedBox(height: 4.h),
                    Text('Phone: ${regularPassenger.phone}'),
                    SizedBox(height: 4.h),
                    Text('Current Ride: ${regularPassenger.currentRideStatus}'),
                  ],
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegularPassengerDetailScreen(regularPassenger: regularPassenger),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
