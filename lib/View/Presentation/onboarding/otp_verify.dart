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
import 'package:sms_autofill/sms_autofill.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../../services/web_socket_services.dart';


class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final PrefrencesManager preferencesManager = Get.put(PrefrencesManager());
  final UserWebSocketService userWebSocket = UserWebSocketService();

  @override
  void initState() {
    super.initState();
    _listenForOTP();
    _initializeSocket();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _otpController.dispose();
    super.dispose();
  }

  void _listenForOTP() async {
    await SmsAutoFill().listenForCode();
  }

  void _initializeSocket() {
    preferencesManager.getAuthToken().then((token) {
      if (token != null) {
        userWebSocket.initializeConnection(
          'https://kantipur-rides-backend.onrender.com',
          token,
        );
        userWebSocket.onConnect(token);
        _emitPassengerLocation();
      } else {
        print("Token not available. Unable to connect to WebSocket.");
      }
    });
  }

  Future<void> _emitPassengerLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied. Enable permissions to proceed.'),
            ),
          );
        }
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String? passengerId = await preferencesManager.getuserId();
      String? socketId = userWebSocket.getSocketId();

      if (socketId != null && socketId.isNotEmpty) {
        userWebSocket.emit("update-passenger-location", {
          "passengerId": passengerId,
          "currentLatitude": position.latitude,
          "currentLongitude": position.longitude,
          "socketId": socketId,
        });

        await preferencesManager.saveCurrentLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          socketId: socketId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location sent to server')),
          );
        }
      } else {
        print("Socket not connected. Retrying...");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to retrieve location. Please try again.'),
          ),
        );
      }
      print("Error fetching location: $e");
    }
  }

  Future<void> _submitOTP() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete OTP')),
      );
      return;
    }

    try {
      final response = await dio.Dio().post(
        'https://kantipur-rides-backend.onrender.com/api/v1/user/verifyCode',
        data: {'code': otp},
      );

      if (response.data['success']) {
        final isUserExist = response.data['data']['isUserExist'];

        if (isUserExist) {
          await _handleExistingUser();
        } else {
          Get.to(() => UserRegisterScreen(email: widget.email));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid OTP. Please try again.')),
          );
        }
      }
    } on dio.DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.response?.data ?? e.message}')),
        );
      }
    }
  }

  Future<void> _handleExistingUser() async {
    try {
      final loginResponse = await dio.Dio().post(
        'https://kantipur-rides-backend.onrender.com/api/v1/user/loginUser',
        data: {'email': widget.email},
      );

      if (loginResponse.data['success'] == true) {
        final token = loginResponse.data['data']['token'];
        final userId = loginResponse.data['data']['userData']['userId'];

        if (token != null && userId != null) {
          await preferencesManager.saveAuthToken(token);
          await preferencesManager.saveuserId(userId);
          Get.off(() =>  ExpandedBottomNavBar(),
              transition: Transition.rightToLeft);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login failed: token or userId is null. Please try again.'),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${loginResponse.data['message']}'),
            ),
          );
        }
      }
    } on dio.DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.response?.data ?? e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            PinFieldAutoFill(
              controller: _otpController,
              codeLength: 6,
              onCodeChanged: (code) {
                if (code?.length == 6) {
                  _submitOTP();
                }
              },
              decoration: BoxLooseDecoration(
                strokeColorBuilder: FixedColorBuilder(Colors.blue),
                bgColorBuilder: FixedColorBuilder(Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitOTP,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

