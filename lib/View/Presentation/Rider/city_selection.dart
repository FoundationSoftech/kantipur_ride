import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantipur_ride/View/Presentation/Rider/vehicle_option.dart';
import '../../../utils/dt_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CitySelection extends StatelessWidget {
  final List<String> cities = [
    'Kathmandu',
    'Chitwan',
    'Pokhara',
    'Hetauda',
    'Biratnagar',
    'Nepalgunj',
    'Butwal',
    'Janakpur',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: GoogleFonts.roboto(
          fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 30.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Select City',
                style: GoogleFonts.roboto(fontSize: 24.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.symmetric(vertical: 8.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appleRedColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () {
                        // Handle button press
                      },
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 25.w),
                        child: InkWell(
                          onTap: (){
                            Get.to(()=>VehicleOption(),transition: Transition.upToDown);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cities[index],
                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
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
}
