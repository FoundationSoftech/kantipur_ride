import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:kantipur_ride/Modal/user_login_modal.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/controller/user_login_controller.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';
import '../../../Components/dt_button.dart';
import '../../../controller/shared_preferences.dart';
import 'otp_verify.dart';


class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final UserLoginController userLoginController = Get.put(UserLoginController());
  final PrefrencesManager preferencesManager = Get.put(PrefrencesManager());
  late IO.Socket socket;

  bool isValidEmail(String email) {
    String pattern = r'^.+@.+\..+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeSocket();
  // }

  // Future<void> _emitPassengerLocation() async {
  //   // Ensure the user has a valid userId from preferences
  //   String? passengerId = await preferencesManager.getuserId();
  //
  //   if (passengerId == null) {
  //     print("User ID is null! Cannot emit location.");
  //     return;
  //   }
  //
  //   if (!socket.connected) {
  //     print("Socket not connected. Retrying...");
  //     await Future.delayed(Duration(seconds: 3));
  //     _emitPassengerLocation(); // Retry until connected
  //     return;
  //   }
  //
  //   try {
  //     // Request location permission
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location permission denied.')));
  //         return;
  //       }
  //     }
  //
  //     // Fetch current position (latitude and longitude)
  //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //     double latitude = position.latitude;
  //     double longitude = position.longitude;
  //
  //     // Print the fetched location
  //     print('Socket connected, emitting location...');
  //     socket.emitWithAck("update-passenger-location", {
  //       "userId": passengerId,
  //       "currentLatitude": latitude,
  //       "currentLongitude": longitude,
  //       "socketId": socket.id,  // Ensure that socket.id is passed
  //     }, ack: (response) {
  //       if (response != null && response['success'] == true) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location updated successfully')));
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update location: ${response["message"] ?? "Unknown error"}')));
  //       }
  //     });
  //
  //     // Store current location and socketId in preferences for future use
  //     preferencesManager.saveCurrentLocation(
  //       latitude: latitude,
  //       longitude: longitude,
  //       socketId: socket.id!, // Ensure socket.id is available
  //     );
  //
  //     // Confirm the location update
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location sent to server')));
  //   } catch (e) {
  //     print("Error fetching location: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to retrieve location.')));
  //   }
  // }


  // Initialize socket connection
  // void _initializeSocket() {
  //   socket = IO.io(
  //     'https://kantipur-rides-backend.onrender.com',
  //     IO.OptionBuilder().setTransports(['websocket']).build(),
  //   );
  //
  //   socket.onConnect((_) {
  //     print('Connected to the socket server. Socket ID: ${socket.id}');
  //     _emitPassengerLocation(); // Emit location after socket connection is established
  //   });
  //
  //   socket.onConnectError((error) {
  //     print('Connection error: $error');
  //   });
  //
  //   socket.onDisconnect((_) {
  //     print('Disconnected from the socket server');
  //   });
  //
  //   socket.onError((error) {
  //     print('Socket error: $error');
  //   });
  //
  //   socket.connect();
  // }

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
                      'kantipurRide',
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
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
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 50.h),
                CustomButton(
                  bottonColor: AppColors.greenColor,
                  textColor: Colors.white,
                  borderRadius: 10.r,
                  onPressed: () {
                    Get.dialog(Center(child: CircularProgressIndicator()));
                    sendOTP();
                  },
                  text: 'Sign In',
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


