import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Modal/passenger.dart';

class PassengerDetailScreen extends StatelessWidget {
  final Passenger passenger;

  const PassengerDetailScreen({Key? key, required this.passenger})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          passenger.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(passenger.profilePictureUrl ?? ''),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 20),

            // Passenger Info
            _buildInfoTile("Passenger ID", passenger.id),
            _buildInfoTile("Email", passenger.email, icon: Icons.email),
            _buildInfoTile("Phone", passenger.phone, icon: Icons.phone),
            SizedBox(height: 16),

            // Current Ride Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Ride Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    passenger.currentRideStatus,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Ride History Section
            Text(
              'Ride History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: passenger.rideHistory.length,
              itemBuilder: (context, index) {
                return _buildRideHistoryCard(passenger.rideHistory[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method to Build Info Tile
  Widget _buildInfoTile(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.blueAccent),
            SizedBox(width: 10),
          ],
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Method to Build Ride History Card
  Widget _buildRideHistoryCard(String rideInfo) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.directions_car, color: Colors.blueAccent),
        ),
        title: Text(
          rideInfo,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
      ),
    );
  }
}
