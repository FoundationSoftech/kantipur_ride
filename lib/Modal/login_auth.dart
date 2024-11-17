import 'dart:convert';
import '../controller/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginAuth {
  final prefrencesController = Get.put(PrefrencesManager());
  String? token;
  String? userId; // Add a userId variable to store the userId from the response

  Future<bool> login({
    required String email,
  }) async {
    final Map<String, dynamic> requestBody = {
      'email': email,
    };
    print("Requested dto=${requestBody.toString()}");
    try {
      final response = await http.post(
        Uri.parse('https://kantipur-rides-backend.onrender.com/api/v1/user/loginUser'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final bool success = responseData['success'] ?? false;

        if (success) {
          // Fetch token and userId from response and store them
          token = responseData['data']['token']; // Adjust based on your API structure
          userId = responseData['data']['userId']; // Assuming 'userId' is in the response
          print('Login successful, token = $token, userId = $userId');

          // Store the token and userId in SharedPreferences
          await prefrencesController.saveAuthToken(token!);
          await prefrencesController.saveuserId(userId!);
          print('Token and userId saved successfully!');

          return true;
        } else {
          print('Login failed: ${responseData['message']}');
          return false;
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
