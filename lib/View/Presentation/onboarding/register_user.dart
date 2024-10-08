import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/user_dashboard_screen.dart';

import '../../../Components/dt_button.dart';
import '../../../utils/dt_colors.dart';
import '../user_dashboard/user_profile_form.dart';


class UserRegister extends StatelessWidget {
  UserRegister({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final RxBool isPhoneValid = false.obs;
  final RxBool isOTPVerified = false.obs;
  final RxBool isProfileComplete = false.obs;

  // Method to show SnackBar
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Mock API call to verify OTP
  Future<bool> verifyOTP(String phone, String otp) async {
    // Simulate OTP verification (in a real app, you'd make an API call here)
    await Future.delayed(Duration(seconds: 2));
    return otp == "123456"; // Assume OTP is always "123456" for testing
  }

  // Mock API call to check if profile is complete
  Future<bool> checkProfileCompletion(String phone) async {
    // Simulate profile check (in a real app, you'd make an API call here)
    await Future.delayed(Duration(seconds: 2));
    return phone == "9876543210"; // Assume profile complete for this number
  }

  @override
  Widget build(BuildContext context) {
    void handlePhoneSubmission() async {
      if (phoneController.text.length != 10) {
        showSnackBar(context, 'Phone number must be 10 digits');
      } else {
        // Simulate sending OTP to the phone
        showSnackBar(context, 'OTP sent to ${phoneController.text}');
        isPhoneValid.value = true; // Enable OTP input field
      }
    }

    void handleOTPVerification() async {
      if (otpController.text.isEmpty) {
        showSnackBar(context, 'Enter the OTP');
      } else {
        bool verified = await verifyOTP(phoneController.text, otpController.text);
        if (verified) {
          isOTPVerified.value = true;
          showSnackBar(context, 'OTP Verified');

          // Check if the profile is complete
          bool profileComplete = await checkProfileCompletion(phoneController.text);
          isProfileComplete.value = profileComplete;

          if (!profileComplete) {
            Get.to(() => ProfileCompletionScreen(), transition: Transition.upToDown);
          } else {
            Get.to(() => UserDashboardScreen(), transition: Transition.upToDown);
          }
        } else {
          showSnackBar(context, 'Invalid OTP');
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/route.png',
                    height: 260.h,
                  ),
                  Text(
                    'Register or Login',
                    style: GoogleFonts.openSans(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 50.h),

                  // Phone Field
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Button to submit phone and receive OTP
                  CustomButton(
                    text: 'Send OTP',
                    bottonColor: AppColors.greenColor,
                    textColor: Colors.white,
                    onPressed: () => handlePhoneSubmission(),
                  ),

                  SizedBox(height: 20.h),

                  // OTP Field (shown only after phone submission)
                  Obx(() => Visibility(
                    visible: isPhoneValid.value,
                    child: Column(
                      children: [
                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter OTP',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Button to verify OTP and check profile
                        CustomButton(
                          text: 'Verify OTP',
                          bottonColor: AppColors.greenColor,
                          textColor: Colors.white,
                          onPressed: () => handleOTPVerification(),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class MainAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The screen shown after successful login/registration and profile completion
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to the App"),
      ),
      body: Center(
        child: Text("Main App Content Goes Here"),
      ),
    );
  }
}
