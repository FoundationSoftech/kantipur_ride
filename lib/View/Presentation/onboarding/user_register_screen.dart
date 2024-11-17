import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kantipur_ride/Components/expanded_bottom_nav_bar.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/user_login_screen.dart';
import '../../../Components/dt_button.dart';
import '../../../Controller/user_register_controller.dart';
import '../../../controller/user_login_controller.dart';
import '../../../utils/dt_colors.dart';
import 'otp_verify.dart';
import 'package:email_auth/email_auth.dart';
import 'package:get/get.dart';

class UserRegisterScreen extends StatefulWidget {
  final String email;

  UserRegisterScreen({required this.email});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  final SignUpController signUpController = Get.put(SignUpController());
  final UserLoginController userLoginController = Get.put(UserLoginController());

  FocusNode focusNode = FocusNode();
  bool isPhoneValid = false;
  bool submitValid = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();

  void checkPhoneValidity(String? phone) {
    //Validate phone number and update state
    setState(() {
      isPhoneValid = phone != null && phone.isNotEmpty;
    });
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



  // Declare the object
  late EmailAuth emailAuth;

  @override
  Widget build(BuildContext context) {
    // Pre-fill the email controller with the passed email
    final signUpController = Get.put(SignUpController());
    signUpController.emailController.text = widget.email;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 90.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enter your mobile number',
                    style: GoogleFonts.openSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                IntlPhoneField(
                  initialCountryCode: "NP",
                  focusNode: focusNode,
                  controller: signUpController.mobileNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  languageCode: "en",
                  validator: (phone) {
                    if (phone == null) {
                      return 'Phone number is required';
                    }
                    return null; //Valid phone number
                  },
                  onChanged: (phone) {
                    checkPhoneValidity(phone.completeNumber);
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ' + country.name);
                  },
                ),
                SizedBox(
                  height: 6.h,
                ),

                TextField(
                  controller: signUpController.emailController,
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

                SizedBox(
                  height: 20.h,
                ),
                TextField(
                  controller: signUpController.nameController,
                  decoration: InputDecoration(

                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )
                      ),
                      labelText: 'Enter your name',
                      labelStyle: GoogleFonts.openSans(
                        color: Colors.grey,
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                //Continue Button- Only enabled when phone is valid

                SizedBox(height: 30.h,),
                CustomButton(
                  text: 'Proceed',
                  bottonColor: AppColors.greenColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    // Show loading dialog
                    Get.dialog(
                      Center(child: CircularProgressIndicator()),
                      barrierDismissible: false, // Prevent closing the dialog
                    );

                    // Debug prints for request payload
                    print('Request Payload:');
                    print('Username: ${signUpController.nameController.text}');
                    print('Number: ${signUpController.mobileNumberController.text}');
                    print('Email: ${signUpController.emailController.text}');

                    // Check for empty fields
                    if (signUpController.nameController.text.isEmpty ||
                        signUpController.emailController.text.isEmpty ||
                        signUpController.mobileNumberController.text.isEmpty) {
                      print('Empty fields, showing snackbar');
                      Get.back(); // Close loading dialog
                      Get.snackbar(
                        'Alert',
                        'Please fill all the fields',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }

                    // Validate email
                    else if (!isValidEmail(signUpController.emailController.text)) {
                      print('Invalid email, showing snackbar');
                      Get.back(); // Close loading dialog
                      Get.snackbar(
                        'Alert',
                        'Please enter a valid email',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }

                    // If validation passes, proceed with sign-up
                    else {
                      bool success = await signUpController.signUpPressed(
                        name: signUpController.nameController.text.trim(),
                        email: signUpController.emailController.text.trim(),
                        mobileNumber: signUpController.mobileNumberController.text.trim(),
                      );

                      // Debugging success response
                      if (kDebugMode) {
                        print('CreateUser success: $success');
                      }

                      // On successful user creation, proceed to login
                      if (success) {
                        Get.dialog(
                          Center(child: CircularProgressIndicator()),

                        );
                        print('User created successfully, now logging in...');
                        bool loginSuccess = await userLoginController.loginPressed(
                          email: signUpController.emailController.text.trim(),

                        );

                        if (loginSuccess) {
                          Get.dialog(
                            Center(child: CircularProgressIndicator()),

                          );
                          print('Login successful, navigating to dashboard...');
                          Get.back(); // Close loading dialog
                          Get.to(() => ExpandedBottomNavBar()); // Navigate to the next screen
                        } else {
                          print('Login failed, showing snackbar');
                          Get.back(); // Close loading dialog
                          Get.snackbar(
                            'Alert',
                            'Login Failed',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                          );
                        }
                      } else {
                        print('User creation failed, showing snackbar');
                        Get.back(); // Close loading dialog
                        Get.snackbar(
                          'Alert',
                          'Registration Failed',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                        );
                      }
                    }
                  },
                ),

                SizedBox(
                  height: 20.h,
                ),
                Wrap(
                  children: [
                    Text(
                      "By tapping continue,you agree to Terms and Conditions and Privacy Policy of Kantipur ride.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




