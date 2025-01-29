import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/user_register_screen.dart';
import 'package:kantipur_ride/controller/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Components/dt_button.dart';
import '../../../Components/expanded_bottom_nav_bar.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';

import '../../../services/web_socket_services.dart';


class OTPScreen extends StatefulWidget {
  final String email;

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

  final PrefrencesManager preferencesManager = Get.put(PrefrencesManager());
  final UserWebSocketService _socketService = UserWebSocketService(); // Singleton WebSocket Service

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    _emitPassengerLocation();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    super.dispose();
  }

  // Initialize WebSocket connection using Singleton
  void _initializeSocket() {
    _socketService.initializeConnection('https://kantipur-rides-backend.onrender.com');
  }

  // Emit passenger location to server
  void _emitPassengerLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied. Enable permissions to proceed.')),
        );
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      String? passengerId = await preferencesManager.getuserId();
      String? socketId = _socketService.getSocketId();  // Get socketId from singleton

      if (socketId != null && socketId.isNotEmpty) {
        print('Socket connected, emitting location...');

        _socketService.emit("update-passenger-location", {
          "passengerId": passengerId,
          "currentLatitude": latitude,
          "currentLongitude": longitude,
          "socketId": socketId,
        });

        preferencesManager.saveCurrentLocation(
          latitude: latitude,
          longitude: longitude,
          socketId: socketId,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location sent to server')),
        );
      } else {
        print("Socket not connected. Retrying...");
      }
    } catch (e) {
      print("Error fetching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to retrieve location. Please try again.')),
      );
    }
  }

  // Submit OTP and handle login
  void _submitOTP() async {
    String otp = _controller1.text + _controller2.text + _controller3.text + _controller4.text + _controller5.text + _controller6.text;

    if (otp.length == 6) {
      print('Submitting OTP: $otp');

      try {
        dio.Response response = await dio.Dio().post(
          'https://kantipur-rides-backend.onrender.com/api/v1/user/verifyCode',
          data: {'code': otp},
        );

        if (response.data['success']) {
          bool isUserExist = response.data['data']['isUserExist'];

          if (isUserExist) {
            dio.Response loginResponse = await dio.Dio().post(
              'https://kantipur-rides-backend.onrender.com/api/v1/user/loginUser',
              data: {'email': widget.email},
            );

            if (loginResponse.data != null && loginResponse.data['success'] == true) {
              String? token = loginResponse.data['data']['token'];
              String? userId = loginResponse.data['data']['userData']['userId'];

              if (token != null && userId != null) {
                await preferencesManager.saveAuthToken(token);
                await preferencesManager.saveuserId(userId);

                _emitPassengerLocation();

                Get.off(() => ExpandedBottomNavBar(), transition: Transition.rightToLeft);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login failed: token or userId is null. Please try again.')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login failed: ${loginResponse.data['message']}')),
              );
            }
          } else {
            Get.to(() => UserRegisterScreen(email: widget.email));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid OTP. Please try again.')),
          );
        }
      } on dio.DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.response?.data ?? e.message}')),
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
              onPressed: () {
                Get.dialog(Center(child: CircularProgressIndicator()));
                _submitOTP();
              },
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
        decoration: InputDecoration(border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}



