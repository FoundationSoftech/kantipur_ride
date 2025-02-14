import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../View/Presentation/user_dashboard/rider_request.dart';
import '../controller/shared_preferences.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import '../services/web_socket_services.dart';

class RideSharingController extends GetxController {
  // Ride details
  var rideType = 'bike'.obs; // Default to 'bike'
  final String apiKey = 'AIzaSyBw9VKmwCrmGzw9GXTm2QwJIOl40ag_Ick';
  Rx<LatLng?> sourceLocation = Rx<LatLng?>(null);
  Rx<LatLng?> destinationLocation = Rx<LatLng?>(null);
  RxString sourceAddress = ''.obs;
  RxString destinationAddress = ''.obs;
  RxString distance = ''.obs;
  RxString duration = ''.obs;
  RxString price = ''.obs;
  RxSet<Polyline> polylines = RxSet<Polyline>();

  final PrefrencesManager prefrencesManager = PrefrencesManager();


  RxString passengerId = ''.obs;
  RxString driverId = ''.obs;
  Rx<String?> currentRideId = Rx<String?>(null);
  Rx<String> currentRideStatus = Rx<String>("");

  final String apiUrl = 'https://kantipur-rides-backend.onrender.com/api/v1/user/createRide';
  final TextEditingController destinationTextController = TextEditingController();
  final TextEditingController pickupPlaceController = TextEditingController();

  // Use Get.find to get the singleton instance
  final UserWebSocketService webSocketService = Get.find<UserWebSocketService>();

  Rx<Map<String, dynamic>?> rideCancel = Rx<Map<String, dynamic>?>(null);

  // Keep the ride request as Rx
  Rx<Map<String, dynamic>?> acceptRide = Rx<Map<String, dynamic>?>(null);

  Rx<Map<String, dynamic>?> cancelRide = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();

    // Get driver ID when initializing
    prefrencesManager.getuserId().then((id) {
      if (id != null) {
        driverId.value = id;
      }
    });

    // Set up the callback
    webSocketService.onRideAcceptReceived = (rideData) {
      print("RiderMapController received ride data: $rideData"); // Debug log
      try {
        currentRideId.value = rideData['rideId'] ?? '';
        acceptRide.value = rideData;
        update();
      } catch (e) {
        print("Error updating ride request in controller: $e"); // Debug log
      }
    };


    // Set up WebSocket listener
    UserWebSocketService().onRideAcceptReceived= (rideData) {
      print("Ride request data received: $rideData");
      acceptRide.value = rideData;
      update(); // Trigger UI update
    };


    // Set up WebSocket connection and listener
    prefrencesManager.getAuthToken().then((token) {
      if (token != null) {
        webSocketService.initializeConnection(
            "https://kantipur-rides-backend.onrender.com",
            token
        );

        // Single listener for ride requests
        webSocketService.socket?.on('accept-ride', (data) {
          print('Raw ride accepted: $data'); // Debug log

          if (data != null) {
            try {
              currentRideId.value = data['rideId'] ?? '';
              acceptRide.value = Map<String, dynamic>.from(data);

              print('Accepted ride request: ${acceptRide.value}'); // Debug log

              update();

              Get.snackbar(
                "Accpted ride",
                "From: ${data['pickupPlaceName']}\nTo: ${data['destinationPlaceName']}",
                duration: Duration(seconds: 10),
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            } catch (e) {
              print("Error processing ride request: $e");
              Get.snackbar(
                "Error",
                "Failed to process ride request: $e",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          }
        });
      }
    });

    // Get driver ID when initializing
    prefrencesManager.getuserId().then((id) {
      if (id != null) {
        driverId.value = id;
      }
    });

    // Set up the callback
    webSocketService.onRideCancelReceived = (rideData) {
      print("RiderMapController cancel ride data: $rideData"); // Debug log
      try {
        currentRideId.value = rideData['rideId'] ?? '';
        cancelRide.value = rideData;
        update();
      } catch (e) {
        print("Error updating ride request in controller: $e"); // Debug log
      }
    };

    // Set up WebSocket listener
    UserWebSocketService().onRideCancelReceived= (rideData) {
      print("Ride request data received: $rideData");
      cancelRide.value = rideData;
      update(); // Trigger UI update
    };


    // Set up WebSocket connection and listener
    prefrencesManager.getAuthToken().then((token) {
      if (token != null) {
        webSocketService.initializeConnection(
            "https://kantipur-rides-backend.onrender.com",
            token
        );

        // Single listener for ride requests
        webSocketService.socket?.on('ride-cancel', (data) {
          print('Raw ride accepted: $data'); // Debug log

          if (data != null) {
            try {
              currentRideId.value = data['rideId'] ?? '';
              cancelRide.value = Map<String, dynamic>.from(data);

              print('Accepted ride request: ${cancelRide.value}'); // Debug log

              update();
              Get.snackbar(
                "Cancel ride",
                "From: ${data['pickupPlaceName']}\nTo: ${data['destinationPlaceName']}",
                duration: Duration(seconds: 10),
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            } catch (e) {
              print("Error processing ride request: $e");
              Get.snackbar(
                "Error",
                "Failed to process ride request: $e",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          }
        });
      }
    });

  }

  @override
  void onClose() {
    webSocketService.disconnect();
    super.onClose();
  }

  Future<void> createRide() async {
    try {
      // Validate required fields
      if (sourceLocation.value == null || destinationLocation.value == null) {
        throw Exception("Source or destination location is not set.");
      }

      // Get token with await
      final token = await prefrencesManager.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception("Authentication token is missing. Please login again.");
      }
      print("Using token: $token");

      // Get user ID with await
      final userId = await prefrencesManager.getuserId();
      if (userId == null || userId.isEmpty) {
        throw Exception("User ID is missing. Please login again.");
      }
      print("User ID: $userId");

      // Clean distance and price
      final cleanDistance = distance.value.replaceAll(RegExp(r'[^0-9.]'), '');
      final cleanFare = price.value.replaceAll(RegExp(r'[^0-9.]'), '');

      print('Clean distance: $cleanDistance');
      print('Clean fare: $cleanFare');

      // Create the request body
      final Map<String, dynamic> body = {
        "pickupLatitude": sourceLocation.value?.latitude ?? 0.0,
        "pickupLongitude": sourceLocation.value?.longitude ?? 0.0,
        "destinationLatitude": destinationLocation.value?.latitude ?? 0.0,
        "destinationLongitude": destinationLocation.value?.longitude ?? 0.0,
        "fare": double.parse(cleanFare), // Ensure it's a number
        "distance": double.parse(cleanDistance), // Ensure it's a number
        "pickupPlaceName": pickupPlaceController.text,
        "destinationPlaceName": destinationTextController.text,
        "rideType": rideType.value, // Ensure it sends "cab" as expected
        "userId": userId, // Include user ID
      };

      print('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('https://kantipur-rides-backend.onrender.com/api/v1/user/createRide'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Ensure proper token format
        },
        body: jsonEncode(body),
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        Get.snackbar(
          "Success",
          "Ride Created Successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please login again.");
      } else {
        throw Exception("Failed to create ride: ${responseData['message']}");
      }
    } catch (e) {
      print("Error creating ride: $e");
      Get.snackbar(
        "Error",
        "Failed to create ride: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );

      if (e.toString().contains("unauthorized") || e.toString().contains("expired")) {
        // Redirect to login if session expired
        // Get.offAll(() => LoginScreen());
      }
    } finally {
      Get.back(); // Close the loading dialog
    }
  }


  void setRideType(String type) {
    rideType.value = type;
  }
}

