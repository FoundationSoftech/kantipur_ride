import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kantipur_ride/View/Presentation/Admin/rider_detail_screen.dart';
import '../../../Modal/rider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RiderListScreen extends StatelessWidget {
  final List<Rider> riders = [
    Rider(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      rideHistory: ['Ride 1', 'Ride 2', 'Ride 3'],
      currentRideStatus: 'Completed',
      profilePictureUrl: '',
    ),
    Rider(
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
        title: Text('Rider Records',style: GoogleFonts.openSans(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),),
      ),
      body: riders.isEmpty
          ? Center(child: Text('No riders available.',style: GoogleFonts.openSans(
      fontSize: 22.sp,
        fontWeight: FontWeight.w600,
      ),))
          : ListView.builder(
        itemCount: riders.length,
        itemBuilder: (context, index) {
          final rider = riders[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(20),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(rider.name),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${rider.email}'),
                    SizedBox(height: 4.h),
                    Text('Phone: ${rider.phone}'),
                    SizedBox(height: 4.h),
                    Text('Current Ride: ${rider.currentRideStatus}'),
                  ],
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiderDetailScreen(rider: rider),
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
