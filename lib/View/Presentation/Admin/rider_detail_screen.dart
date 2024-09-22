import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Modal/rider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class RiderDetailScreen extends StatelessWidget {
  final Rider rider;

  const RiderDetailScreen({Key? key, required this.rider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          rider.name,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rider Profile Picture Section
            Center(
              child: CircleAvatar(
                radius: 50.r,
                backgroundImage: rider.profilePictureUrl != null
                    ? NetworkImage(rider.profilePictureUrl!)
                    : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 20.h),

            // Rider Info Section
            _buildInfoTile("Rider ID", rider.id),
            _buildInfoTile("Email", rider.email),
            _buildInfoTile("Phone", rider.phone),
            _buildInfoTile("Current Ride Status", rider.currentRideStatus),

            // Ride History Section
            SizedBox(height: 20.h),
            Text(
              'Ride History',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: rider.rideHistory.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    child: ListTile(
                      leading: Icon(Icons.directions_car, color: Colors.teal),
                      title: Text(
                        rider.rideHistory[index],
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

  // Helper method to create an info tile for rider details
  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.w),
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
