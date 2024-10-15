import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/Schedule/ride_schedule_screen.dart';
import 'package:kantipur_ride/Schedule/schedule_login.dart';
import 'package:kantipur_ride/View/Presentation/Rider/rider_login.dart';
import 'package:kantipur_ride/View/Presentation/Admin/admin_login.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/login_screen.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/register_user.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingRiderPassenger extends StatelessWidget {
  const OnboardingRiderPassenger({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image with blend
            Positioned.fill(
              child: Image.asset(
                'assets/select1.jpg', // Replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),

            // Content on top of the background
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 160.h),
              child: Column(
                children: [
                  // Sign in as Driver Button
                  CustomButton(
                    text: 'Sign in as Driver',
                    textColor: Colors.white,
                    bottonColor: AppColors.primaryColor,
                    onPressed: () {
                      Get.to(() => RiderLoginScreen(),
                          transition: Transition.upToDown);
                    },
                  ),

                  SizedBox(height: 50.h), // Space between buttons

                  // Sign in as Passenger Button
                  CustomButton(
                    text: 'Sign in as Passenger',
                    textColor: Colors.white,
                    bottonColor: AppColors.purpleColor,
                    onPressed: () {
                      Get.to(() => LoginScreen(), transition: Transition.upToDown);
                    },
        
                  ),
                  SizedBox(height: 50.h), // Space between buttons

                  // Sign in as Passenger Button
                  CustomButton(
                    text: 'Admin',
                    textColor: Colors.white,
                    bottonColor: AppColors.appleRedColor,
                    onPressed: () {
                      Get.to(() => AdminLoginScreen(), transition: Transition.upToDown);
                    },

                  ),
                  SizedBox(height: 50.h),
                  CustomButton(
                    text: 'Schedule your ride',
                    textColor: Colors.white,
                    bottonColor: AppColors.primaryColor,
                    onPressed: () {
                      Get.to(() => ScheduleLogin(),
                          transition: Transition.upToDown);
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
