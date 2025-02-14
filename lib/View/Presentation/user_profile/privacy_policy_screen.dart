import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/dt_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Privacy Policy",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
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
                'Privacy Policy',
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
                'We value your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and protect your data.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '2. Information We Collect',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We may collect the following information: your name, email address, phone number, and any other information you voluntarily provide.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '3. How We Use Your Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your information is used to provide and improve our services, communicate with you, and ensure the app’s functionality and security.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '4. Sharing Your Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We do not sell or share your personal information with third parties, except as required by law or with your consent.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '5. Data Security',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We implement robust security measures to protect your data from unauthorized access, disclosure, or misuse.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '6. Your Rights',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'You have the right to access, update, or delete your personal information. Please contact us if you wish to exercise these rights.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '7. Changes to this Privacy Policy',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We may update this Privacy Policy from time to time. Please review it periodically for changes.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                '8. Contact Us',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'If you have any questions or concerns about this Privacy Policy, please contact us at privacy@example.com.',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
