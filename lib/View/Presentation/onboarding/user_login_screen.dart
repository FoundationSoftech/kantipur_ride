import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/controller/user_login_controller.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';
import '../../../Components/dt_button.dart';
import 'otp_verify.dart';


class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final UserLoginController userLoginController = Get.put(UserLoginController());

  bool isValidEmail(String email) {
    String pattern = r'^.+@.+\..+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void sendOTP() async {
    if (userLoginController.emailController.text.trim().isEmpty) {
      Get.dialog(
        Center(child: CircularProgressIndicator()),

      );
      Get.snackbar(
        'Error',
        'Email cannot be empty',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!isValidEmail(userLoginController.emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Proceed to send OTP
    bool success = await userLoginController.sendVerificationCode(email: userLoginController.emailController.text.trim());
    if (success) {
      Get.dialog(
        Center(child: CircularProgressIndicator()),

      );
      Get.snackbar(
        'Success',
        'Verification code sent to your email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Pass the email to OTPScreen
      Get.off(() => OTPScreen(email: userLoginController.emailController.text.trim()));
    } else {
      Get.snackbar(
        'Error',
        'Failed to send verification code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 80.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                Row(
                  children: [
                    Image.asset('assets/logo.png', width: 200.w, color: Colors.red),
                    Text(
                      'kantipurRIde',
                      style: GoogleFonts.lato(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: userLoginController.emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: 'Enter your email',
                    labelStyle: GoogleFonts.openSans(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 50.h),
                CustomButton(
                  text: 'Sign In',
                  bottonColor: AppColors.greenColor,
                  textColor: Colors.white,
                  onPressed: (){
                    Get.dialog(
                      Center(child: CircularProgressIndicator()),

                    );
                    sendOTP();
                  },
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
