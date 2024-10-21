import 'dart:convert';
import '../controller/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginAuth {
  final prefrencesController = Get.put(PrefrencesManager());
  String? token;

  Future<bool> login({
    required String email,
  }) async {
    final Map<String, dynamic> requestbody = {
      'email': email,
    };
    print("Requested dto=${requestbody.toString()}");
    try {
      final response = await http.post(
        Uri.parse('https://kantipur-rides-backend.onrender.com/api/v1/user/loginUser'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestbody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final bool success = responseData['success'] ?? false;

        // Fetch token from response and store it
        if (success) {
          final String token = responseData['data']['token']; // Adjust based on your API structure
          print('Login successful, token = $token');

          // Store the token using SharedPreferences
          await prefrencesController.saveAuthToken(token);
          print('Token saved successfully!');

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
