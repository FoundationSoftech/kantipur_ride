import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/user_register_screen.dart';
import 'package:kantipur_ride/controller/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Components/dt_button.dart';
import '../../../Components/expanded_bottom_nav_bar.dart';

class OTPScreen extends StatefulWidget {
  final String email; // Add a variable to hold the email

  OTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  // Instantiate PreferencesManager
  final PrefrencesManager prefrencesManager = Get.put(PrefrencesManager());

  void _submitOTP() async {
    String otp = _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text +
        _controller5.text +
        _controller6.text;

    if (otp.length == 6) {
      try {
        dio.Response response = await dio.Dio().post(
          'https://kantipur-rides-backend.onrender.com/api/v1/user/verifyCode',
          data: {'code': otp},
        );

        print("OTP Verification Response: ${response.data}"); // Print the entire response

        if (response.data['success']) {
          bool isUserExist = response.data['data']['isUserExist'];
          print("isUserExist: $isUserExist"); // Check if user exists

          if (isUserExist) {
            print("User exists, proceeding to login..."); // Indicate we're about to log in

            // Use the email passed from UserLoginScreen
            print("Email retrieved for login: ${widget.email}"); // Print the retrieved email

            dio.Response loginResponse = await dio.Dio().post(
              'https://kantipur-rides-backend.onrender.com/api/v1/user/loginUser',
              data: {
                'email': widget.email, // Use the passed email here
                // You may need to include additional data like password, if required
              },
            );

            print("Login Response: ${loginResponse.data}"); // Print the login response

            if (loginResponse.data['success']) {
              String token = loginResponse.data['data']['token'];
              print("Login successful, token: $token"); // Log the token
              await prefrencesManager.saveAuthToken(token); // Save the token

              // Navigate to the dashboard
              Get.off(() => ExpandedBottomNavBar(), transition: Transition.rightToLeft);
            } else {
              print("Login failed: ${loginResponse.data}"); // Print failure response
            Get.to(()=>UserRegisterScreen(email: widget.email,));
            }
          } else {
            print("User does not exist."); // Print that user doesn't exist
            Get.to(()=>UserRegisterScreen(email: widget.email,));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid OTP. Please try again.')),
          );
        }
      } on dio.DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the complete OTP')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOTPField(_controller1, _focusNode1, _focusNode2),
                _buildOTPField(_controller2, _focusNode2, _focusNode3),
                _buildOTPField(_controller3, _focusNode3, _focusNode4),
                _buildOTPField(_controller4, _focusNode4, _focusNode5),
                _buildOTPField(_controller5, _focusNode5, _focusNode6),
                _buildOTPField(_controller6, _focusNode6, null),
              ],
            ),
            SizedBox(height: 30.h),
            CustomButton(
              text: 'Submit',
              bottonColor: Colors.blue,
              textColor: Colors.white,
              onPressed: _submitOTP,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPField(TextEditingController controller, FocusNode focusNode, FocusNode? nextFocusNode) {
    return Container(
      width: 40.w,
      height: 60.h,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else if (value.isEmpty && focusNode != null) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}


