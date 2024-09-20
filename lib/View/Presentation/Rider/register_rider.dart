import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantipur_ride/View/Presentation/Rider/rider_login.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/login_screen.dart';
import 'package:get/get.dart';
import '../../../Components/dt_button.dart';
import '../../../utils/dt_colors.dart';


class RiderRegister extends StatelessWidget {
  RiderRegister({super.key});

  // Controllers for TextFields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable boolean to track whether all fields are valid
  final RxBool isFormValid = false.obs;

  // Regex pattern for email validation
  RegExp get emailRegex => RegExp(emailPattern);
  String get emailPattern =>
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";

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

  @override
  Widget build(BuildContext context) {
    // Update form validation whenever text changes
    void checkFormValidity() {
      isFormValid.value = nameController.text.isNotEmpty &&
          emailRegex.hasMatch(emailController.text) &&
          phoneController.text.length == 10 &&
          passwordController.text.length >= 6;
    }

    void handleFormSubmission() {
      // Even if form is not valid, the button is still clickable,
      // so show error messages if form is invalid
      if (nameController.text.isEmpty ) {
        showSnackBar(context, 'Name cannot be empty');
      } else if (!emailRegex.hasMatch(emailController.text)) {
        showSnackBar(context, 'Enter a valid email');
      } else if (phoneController.text.length != 10) {
        showSnackBar(context, 'Phone number must be 10 digits');
      } else if (passwordController.text.length < 6) {
        showSnackBar(context, 'Password must be at least 6 characters');
      } else {
        // If form is valid, proceed to the next screen
        Get.to(() => RiderLoginScreen(), transition: Transition.upToDown);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w,),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/route.png',
                    height: 260.h,
                  ),
                  Text(
                    'Register as a Rider',
                    style: GoogleFonts.openSans(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 50.h),
          
                  // Name Field
                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => checkFormValidity(),
                  ),
                  SizedBox(height: 20.h),
          
                  // Email Field
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => checkFormValidity(),
                  ),
                  SizedBox(height: 20.h),
          
                  // Phone Field
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => checkFormValidity(),
                  ),
                  SizedBox(height: 20.h),
          
                  // Password Field
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => checkFormValidity(),
                  ),
                  SizedBox(height: 40.h),
          
                  // Allow button to be clickable but show error messages when form is invalid
                  CustomButton(
                    text: 'Create Account',

                    bottonColor: AppColors.greenColor,
                    textColor: Colors.white,
                    onPressed: () => handleFormSubmission(),
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
