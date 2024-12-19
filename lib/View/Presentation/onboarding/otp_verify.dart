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
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';


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
  late IO.Socket socket;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    _emitPassengerLocation();
  }

  @override
  void dispose() {
    socket.dispose();
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

  // Initialize socket connection
  void _initializeSocket() {
    socket = IO.io(
      'https://kantipur-rides-backend.onrender.com',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.onConnect((_) {
      print('Connected to the socket server. Socket ID: ${socket.id}');
      _emitPassengerLocation();
    });

    socket.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });

    socket.connect();
  }

  // Emit the passenger's location
  Future<void> _emitPassengerLocation() async {
    // Step 1: Check and request location permission
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
      // Step 2: Get current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Step 3: Get user ID (or any other necessary data)
      String? passengerId = await preferencesManager.getuserId();

      // Step 4: Ensure socket is connected before emitting location
      if (socket.connected) {
        print('Socket connected, emitting location...');

        // Step 5: Emit the location to the server
        socket.emitWithAck("update-passenger-location", {
          "passengerId": passengerId,
          "currentLatitude": latitude,
          "currentLongitude": longitude,
          "socketId": socket.id, // Ensure socketId is included
        }, ack: (response) {
          print("Acknowledgment from server: $response");
          if (response != null && response['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location updated successfully')),
            );
          } else {
            print("Error updating location: ${response["message"] ?? "Unknown error"}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update location: ${response["message"] ?? "Unknown error"}')),
            );
          }
        });

        // Step 6: Save the current location to preferences
        preferencesManager.saveCurrentLocation(
          latitude: latitude,
          longitude: longitude,
          socketId: socket.id!, // Save the socket ID as well
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location sent to server')),
        );
      } else {
        print("Socket not connected. Retrying...");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Socket not connected. Cannot emit location. Retrying...')),
        );
      }
    } catch (e) {
      // Step 7: Handle errors
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

        print('OTP Verification Response: ${response.data}');

        if (response.data['success']) {
          bool isUserExist = response.data['data']['isUserExist'];

          if (isUserExist) {
            dio.Response loginResponse = await dio.Dio().post(
              'https://kantipur-rides-backend.onrender.com/api/v1/user/loginUser',
              data: {'email': widget.email},
            );

            print('Full login response: ${loginResponse.data}');

            // Inside _submitOTP() after successful login
            if (loginResponse.data != null && loginResponse.data['success'] == true) {
              String? token = loginResponse.data['data']['token'];
              String? userId = loginResponse.data['data']['userData']['userId'];

              if (token != null && userId != null) {
                await preferencesManager.saveAuthToken(token);
                await preferencesManager.saveuserId(userId);

                // Emit passenger location after successful login
                await _emitPassengerLocation();

                Get.off(() => ExpandedBottomNavBar(), transition: Transition.rightToLeft);
              } else {
                print('Error: token or userId is null. Cannot proceed.');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login failed: token or userId is null. Please try again.')),
                );
              }
            }
            else {
              print('Login failed: ${loginResponse.data['message']}');
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
        print('Error during OTP submission: ${e.response?.data ?? e.message}');
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
            SizedBox(height: 30),
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
      width: 40,
      height: 60,
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



