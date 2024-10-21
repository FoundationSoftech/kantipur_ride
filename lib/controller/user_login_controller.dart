import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:kantipur_ride/controller/shared_preferences.dart';
import '../Modal/login_auth.dart';
import 'package:get/get.dart';


class UserLoginController extends GetxController {

  final loginAuth = LoginAuth();
  final TextEditingController emailController = TextEditingController();

  final RxBool isObscure = RxBool(true);

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
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle any errors
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> loginPressed({
    required String email,
  }) async {
    // Check if any of the required parameters are null
    if (
    email.isEmpty) {
      // Handle the case where any of the parameters are null
      return false;
    }
    return await loginAuth.login(
      email: email,
    );
  }
}