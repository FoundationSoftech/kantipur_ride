import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:kantipur_ride/View/Presentation/Admin/passenger_detail_screen.dart';

import '../../../Modal/passenger.dart';

class PassengerListScreen extends StatelessWidget {
  // Sample list of passengers
  final List<Passenger> passengers = [
    Passenger(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      rideHistory: ['Ride 1', 'Ride 2', 'Ride 3'],
      currentRideStatus: 'Completed',
    ),
    Passenger(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      phone: '+0987654321',
      rideHistory: ['Ride A', 'Ride B'],
      currentRideStatus: 'Active',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Records'),
      ),
      body: ListView.builder(
        itemCount: passengers.length,
        itemBuilder: (context, index) {
          final passenger = passengers[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(passenger.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${passenger.email}'),
                  Text('Phone: ${passenger.phone}'),
                  Text('Current Ride: ${passenger.currentRideStatus}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Open details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PassengerDetailScreen(passenger: passenger),
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
