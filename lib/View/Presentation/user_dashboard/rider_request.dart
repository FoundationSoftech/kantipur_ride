import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/controller/ride_request_controller.dart';
import 'package:kantipur_ride/services/web_socket_services.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';

class RiderRequestUser extends StatefulWidget {
  const RiderRequestUser({Key? key}) : super(key: key);

  @override
  State<RiderRequestUser> createState() => _RiderRequestUserState();
}

class _RiderRequestUserState extends State<RiderRequestUser> {
  final RideRequestController rideRequestController = RideRequestController();

  UserWebSocketService webSocketService = UserWebSocketService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Card(
            color: AppColors.cardColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.person, size: 30.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sanjaya',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'MOTOR-BIKE TVS',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 16.sp),
                              SizedBox(width: 4.w),
                              Text(
                                '4.91',
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '(550 rides)',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 12.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NPR92',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Estimated Fare',
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '5 min',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '1.0 Km',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.dialog(const Center(child: CircularProgressIndicator()));

                    // Avoid re-registering listeners every time the button is pressed
                    // rideRequestController.rideCancelled();  // Only trigger the ride cancel logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
                  ),
                  child: Text(
                    'Cancel Ride',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
