import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/View/Presentation/Admin/admin_dashboard_overview.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/user_register_screen.dart';
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
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoginButtonEnabled = false;

  final UserLoginController userLoginController = Get.put(UserLoginController());

  void _checkInputFields(){
    //Enable the login button only if both fields are not empty
    if(mobileController.text.isNotEmpty && passwordController.text.isNotEmpty){
      setState(() {
        isLoginButtonEnabled = true;
      });
    }else{
      setState(() {
        isLoginButtonEnabled = false;
      });
    }
  }


  bool isValidEmail(String email) {
    // Regular expression pattern to match an email address
    String pattern = r'^.+@.+\..+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }


  //  method to handle user login, for example:
  void handleLogin() async {
    // After successful login, update user details in UserDetailsController
    // await userDetailsController.getUserDetails();
  }

  void sendCode() async {
    if (userLoginController.emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email cannot be empty',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Proceed to send OTP
    try {
      bool success = await userLoginController.sendVerificationCode(email: userLoginController.emailController.text.trim());
      if (success) {
        Get.snackbar(
          'Success',
          'Verification code sent to your email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to send verification code',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void initState() {
    //Add listenders to check for text changes in both fields
    mobileController.addListener(_checkInputFields);
    passwordController.addListener(_checkInputFields);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 80.h),
          child: SingleChildScrollView(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                Row(
                  children: [
                    Image.asset('assets/logo.png',width: 200.w,color: Colors.red,),
                    Text('kantipurRIde',style: GoogleFonts.lato(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,

                    ),)
                  ],
                ),
                SizedBox(height: 20.h),
                // Mobile number field
                TextField(
                  controller: userLoginController.emailController,
                  decoration: InputDecoration(

                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )
                      ),
                      labelText: 'Enter your email',
                      labelStyle: GoogleFonts.openSans(
                        color: Colors.grey,
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 50.h),
                CustomButton(
                    text: 'Sign In',
                    bottonColor: AppColors.greenColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      Get.dialog(Center(
                        child: CircularProgressIndicator(),
                      ));

                      // Print request payload for debugging purposes
                      print('Request Payload:');

                      print('Email: ${userLoginController.emailController.text}');


                      // Check if any field is empty
                      if (userLoginController.emailController.text.isEmpty) {
                        print('Empty fields, showing snackbar');
                        Get.back(); // Close the dialog
                        Get.snackbar(
                          'Alert',
                          'Please fill all the fields',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                      // Check if email is valid
                      else if (!isValidEmail(
                          userLoginController.emailController.text)) {
                        print('Invalid email, showing snackbar');
                        Get.back(); // Close the dialog
                        Get.snackbar(
                          'Alert',
                          'Please enter a valid email',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                      // If all checks pass, proceed with sign-up
                      else {
                        bool success = await userLoginController.loginPressed(

                          email: userLoginController.emailController.text
                              .trim(),

                        );
                        if (kDebugMode) {
                          print('Register success: $success');
                        }
                        if (success) {
                          print('Successful registration, navigating');
                          Get.back(); // Close the dialog
                          sendCode();
                          Get.off(() => OTPScreen());
                          handleLogin();
                        } else {
                          print('Registration failed, showing snackbar');
                          Get.back(); // Close the dialog
                          Get.snackbar(
                            'Alert',
                            'Registration Failed',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                          );
                        }
                      }
                    }
                ),

                SizedBox(height: 50.h),
                // Login button


              ],
            ),
          ),
        ),
      ),
    );
  }
}
