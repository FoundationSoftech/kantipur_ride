import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kantipur_ride/View/Presentation/Admin/passenger_detail_screen.dart';

import '../../../Modal/passenger.dart';


class PassengerListScreen extends StatelessWidget {
  final List<Passenger> passengers = [
    Passenger(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      rideHistory: ['Ride 1', 'Ride 2', 'Ride 3'],
      currentRideStatus: 'Completed',
      profilePictureUrl: ''
    ),
    Passenger(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      phone: '+0987654321',
      rideHistory: ['Ride A', 'Ride B'],
      currentRideStatus: 'Active',
      profilePictureUrl: ''
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Records'),
      ),
      body: passengers.isEmpty
          ? Center(child: Text('No passengers available.'))
          : ListView.builder(
        itemCount: passengers.length,
        itemBuilder: (context, index) {
          final passenger = passengers[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(20),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(passenger.name),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${passenger.email}'),
                    SizedBox(height: 4),
                    Text('Phone: ${passenger.phone}'),
                    SizedBox(height: 4),
                    Text('Current Ride: ${passenger.currentRideStatus}'),
                  ],
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PassengerDetailScreen(passenger: passenger),
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
