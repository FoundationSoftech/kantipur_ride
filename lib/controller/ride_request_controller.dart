import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/ride_sharing_screen.dart';
import 'package:kantipur_ride/controller/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:kantipur_ride/services/web_socket_services.dart';

class RideRequestController extends GetxController {
  final socketService = UserWebSocketService();

  @override
  void onInit() {
    super.onInit();
    // Initialize the WebSocket connection
    socketService.initializeConnection("https://kantipur-rides-backend.onrender.com");
  }

  Future<void> rideCancelled() async {
    final apiUrl =
        'https://kantipur-rides-backend.onrender.com/api/v1/driver/cancelRide/0281abd4-6af5-418d-8797-ff51432c63db';

    try {
      // Retrieve the token from SharedPreferences
      PrefrencesManager preferencesManager = PrefrencesManager();
      String? token = await preferencesManager.getAuthToken();

      if (token == null || token.isEmpty) {
        Get.snackbar(
          "Error",
          "Authentication token is missing. Please log in again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Initialize Dio and set the headers
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Make the GET request
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          socketService.listenForRideRequests();
          socketService.registerSocketListeners();

          Get.snackbar(
            "Success",
            responseData['message'] ?? "Ride Cancelled",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.to(() => RideSharingScreen(), transition: Transition.upToDown);
        } else {
          Get.snackbar(
            "Error",
            responseData['message'] ?? "Failed to cancel ride. Please try again.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to cancel ride. Status Code: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (e is DioError) {
        print("DioError: ${e.response?.data}");
        print("Status code: ${e.response?.statusCode}");
        Get.snackbar(
          "Error",
          "Dio Error: ${e.response?.data['message'] ?? e.message}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print("Error: ${e.toString()}");
        Get.snackbar(
          "Error",
          "An unexpected error occurred: ${e.toString()}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
