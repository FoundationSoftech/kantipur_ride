import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/dt_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "About Terms and Conditions",
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
                'Welcome to Our Terms and Conditions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                '1. Introduction',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'By accessing and using this app, you agree to comply with the terms and conditions outlined here.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '2. User Responsibilities',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'You are responsible for maintaining the confidentiality of your account information and ensuring that all activities under your account comply with our policies.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '3. Prohibited Activities',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'The following activities are strictly prohibited: unauthorized access to our systems, misuse of the app for illegal purposes, and harassment of other users.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '4. Changes to Terms',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We reserve the right to update these terms and conditions at any time. Continued use of the app constitutes acceptance of the updated terms.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '5. Contact Us',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'If you have any questions about these terms, please contact us via email at support@example.com.',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
