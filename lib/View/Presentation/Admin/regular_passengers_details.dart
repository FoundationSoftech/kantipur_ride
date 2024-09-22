import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Modal/regular_passenger.dart';

class RegularPassengerDetailScreen extends StatelessWidget {
  final RegularPassenger regularPassenger;

  const RegularPassengerDetailScreen({Key? key, required this.regularPassenger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          regularPassenger.name,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: CircleAvatar(
                radius: 50.r,
                backgroundImage: regularPassenger.profilePictureUrl != null
                    ? NetworkImage(regularPassenger.profilePictureUrl!)
                    : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 20.h),

            // Passenger Info Section
            _buildInfoTile("Passenger ID", regularPassenger.id),
            _buildInfoTile("Email", regularPassenger.email),
            _buildInfoTile("Phone", regularPassenger.phone),
            _buildInfoTile("Current Ride Status", regularPassenger.currentRideStatus),

            // Ride History Section
            SizedBox(height: 20.h),
            Text(
              'Ride History',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: regularPassenger.rideHistory.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    child: Padding(
                      padding: EdgeInsets.all(12.h),
                      child: Text(
                        regularPassenger.rideHistory[index],
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create an info tile for passenger details
  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

