import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:kantipur_ride/controller/shared_preferences.dart';
import '../Modal/login_auth.dart';
import 'package:get/get.dart';
import '../Modal/user_login_modal.dart';

class UserLoginController extends GetxController {
  final loginAuth = LoginAuth();
  final TextEditingController emailController = TextEditingController();

  Rx<UserLoginModal> loginResponse = Rx<UserLoginModal>(UserLoginModal());

  final RxBool isObscure = RxBool(true);

  // Fixed spelling for PreferencesManager and initialized with null safety
  final PrefrencesManager preferences = Get.put(PrefrencesManager());

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Method to send verification code
  Future<bool> sendVerificationCode({required String email}) async {
    final url = Uri.parse(
        'https://kantipur-rides-backend.onrender.com/api/v1/user/sendVerificationCode');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          print('Verification code sent successfully');
          return true;
        } else {
          // Failed to send verification code
          print('Error: ${data['message']}');
          return false;
        }
      } else {
        // Server error
        print('Server Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle any errors
      print('Exception while sending verification code: $e');
      return false;
    }
  }

  Future<bool> loginPressed({
    required String email,
  }) async {
    if (email.isEmpty) {
      print('Error: Email is empty');
      return false;
    }

    try {
      // Attempt login
      final bool isLoggedIn = await loginAuth.login(email: email);

      if (isLoggedIn) {
        // Null safety check for userId
        String? userId = loginAuth.userId;

        if (userId != null && userId.isNotEmpty) {
          // Store `userId` in SharedPreferences
          await preferences.saveuserId(userId);
          print('User ID stored successfully');
        } else {
          print('Error: userId is null or empty');
        }
      } else {
        print('Login failed');
      }

      return isLoggedIn;
    } catch (e) {
      // Catch any exceptions and log the error
      print('Exception during login: $e');
      return false;
    }
  }
}
