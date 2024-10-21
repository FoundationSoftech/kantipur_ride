import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    text: 'Sign In',
                    textColor: Colors.white,
                    bottonColor: AppColors.primaryColor,
                    onPressed: () {
                      // Get.to(() => RiderLoginScreen(),
                      //     transition: Transition.upToDown);
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
