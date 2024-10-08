import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/onboarding_rider_passenger.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
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
                          borderRadius: BorderRadius.circular(30.r),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
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
                        style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500),
                      ),
                      CustomButton(
                        borderRadius: 20.r,
                          text: 'View Full Ride Summary',

                          onPressed: (){
                          Get.to(()=>RideSummaryPage(totalTrips: totalTrips, earnings: earnings));

                      })
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
                      CustomButton(
                          text: 'TRACK RIDE', onPressed: (){},
                        borderRadius: 20.r,
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
                child: CustomButton(
                  
                  borderRadius: 20.r,
                    width: 200.w,
                    bottonColor: AppColors.appleRedColor,
                    textColor: Colors.white,
                    text: 'LOGOUT', onPressed: (){
                      Get.offAll(()=>OnboardingRiderPassenger(),transition: Transition.upToDown);
                }),
              ),



            ],
          ),
        ),
      ),
    );
  }
}


class RideSummaryPage extends StatelessWidget {
  final int totalTrips;
  final double earnings;

  RideSummaryPage({required this.totalTrips, required this.earnings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Ride Summary"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),

            // Total Rides Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_car_rounded,
                      size: 50.sp,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Total Rides Completed",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "$totalTrips",
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // Total Earnings Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      size: 50.sp,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Total Earnings",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "₨$earnings",
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),



            // View Detailed Rides Button

          ],
        ),
      ),
      backgroundColor: Color(0xFFF3F4F6), // Light background color for contrast
    );
  }
}
