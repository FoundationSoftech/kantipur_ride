import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/dt_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "About",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

          ],
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Welcome to HamroSampada! We are dedicated to providing a seamless experience for our users through our innovative solutions. Our team is passionate about creating applications that solve real-world problems and enhance everyday life.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Our mission is to empower individuals and businesses by delivering high-quality, reliable, and user-friendly applications that make a difference in their lives.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                'Our Vision',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'To be a leader in the app development industry by continually innovating and exceeding user expectations.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'If you have any questions, feedback, or suggestions, feel free to reach out to us at contact@example.com. We\'d love to hear from you!',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Center(child: Icon(Icons.logo_dev)),

              // Center(
              //   child: Image.asset(
              //     'assets/logo.png', // Replace with your logo path
              //     height: 100.h,
              //   ),
              // ),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
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
