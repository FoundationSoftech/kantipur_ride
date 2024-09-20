import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/onboarding_rider_passenger.dart';

class RiderDashboard extends StatefulWidget {
  @override
  _RiderDashboardState createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  bool isOnline = false;
  double earnings = 523.75; // Example earnings
  int totalTrips = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Rider Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_image.png'), // Replace with actual image
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "4.8 ★", // Example rating
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Online/Offline Toggle Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isOnline = !isOnline;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOnline ? Colors.green : Colors.grey,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isOnline ? "GO OFFLINE" : "GO ONLINE",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Earnings Summary
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Today's Earnings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "₨$earnings",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Total Trips: $totalTrips",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Ongoing Ride Status (if any)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Ride",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Pickup: Public House Cafe And Restaurant, Siddhidas Marga, Ason, KTM",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Destination: Chabahil Plaza, Boudha Main Road, Chabahil Chowk, KTM",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to Ride Tracking screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          "TRACK RIDE",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Completed Rides Section
              Text(
                "Recent Rides",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 10.h),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3, // Example for 3 recent rides
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Ride to Chabahil Plaza"),
                      subtitle: Text("₨150 | 4.2 KM | 20 mins"),
                      trailing: Text("Completed"),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),

              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(()=>OnboardingRiderPassenger(),transition: Transition.upToDown);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
