import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kantipur_ride/Modal/send_verification_code.dart';
import '../controller/shared_preferences.dart';
import 'package:dio/dio.dart';

class SignUpAuth {
  final prefrencesController = Get.put(PrefrencesManager());
  String? token;

  Dio dio = Dio();

  Future<bool> sendVerificationCode({required String email}) async {
    try {
      final response = await dio.post(
        'https://kantipur-rides-backend.onrender.com/api/v1/user/sendVerificationCode',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        final verificationResponse =
            SendVerificationCode.fromJson(response.data);

        if (verificationResponse.success == true) {
          print("Verification code sent to email");
          // final String token = responseData['data']['token'];
          return true;
        } else {
          print(
              "Failed to send verification code: ${verificationResponse.message}");
          return false;
        }
      } else {
        print("Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String name,
    required String mobileNumber,
  }) async {
    final Map<String, dynamic> requestbody = {
      'email': email,
      'name': name,
      'mobileNumber': mobileNumber,
    };
    print("Requested dto=${requestbody.toString()}");
    try {
      final response = await http.post(
          Uri.parse(
              'https://kantipur-rides-backend.onrender.com/api/v1/user/createUser'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(requestbody));

      if (response.statusCode == 200) {
        Get.back();
        final Map<String, dynamic> responseData = json.decode(response.body);
        final bool success = responseData['success'] ?? false;
        token = responseData['token'];
        // final int? userId = await fetchUserId(email);
        // if (userId != null) {
        //   prefrencesController.saveuserId(userId);
        // }
        print('Register successful');
        prefrencesController.saveToken(token);
        print('token = $token');

        if (success) {
          print('Signup successful');
          // Save user details to local storage

          // box.write('name', name);
          // box.write('email', email);

          return true;
        } else {
          print('Signup failed: ${responseData['message']}');
          return false;
        }
      } else {
        Get.back();
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
