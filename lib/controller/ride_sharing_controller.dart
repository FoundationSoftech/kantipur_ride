import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../View/Presentation/user_dashboard/rider_request.dart';
import '../controller/shared_preferences.dart';

class RideSharingController extends GetxController {
  // Ride details
  var sourceLocation = Rxn<LatLng>();
  var destinationLocation = Rxn<LatLng>();
  var price = ''.obs;
  var pickupPlaceName = ''.obs;
  var distance = ''.obs;
  var currentAddress = ''.obs;
  var destinationAddress = ''.obs;
  var rideType = 'cab'.obs; // Default to 'cab'

  final TextEditingController destinationTextController =
      TextEditingController();
  final TextEditingController pickupPlaceController = TextEditingController();

  // API endpoint
  final String apiUrl =
      'https://kantipur-rides-backend.onrender.com/api/v1/user/createRide';

  Future<void> createRide() async {
    if (!isRideDataComplete()) {
      Get.snackbar("Error", "Please fill in all ride details",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    String? token = await PrefrencesManager().getAuthToken();

    if (token == null) {
      Get.snackbar("Error", "User is not authenticated. Please login again.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final body = {
      "pickupLatitude": sourceLocation.value!.latitude,
      "pickupLongitude": sourceLocation.value!.longitude,
      "destinationLatitude": destinationLocation.value!.latitude,
      "destinationLongitude": destinationLocation.value!.longitude,
      "fare": double.parse(price.value),
      "distance": double.parse(distance.value.split(" ")[0]),
      "pickupPlaceName": pickupPlaceController.text.trim(),
      "destinationPlaceName": destinationTextController.text.trim(),
      "rideType": rideType.value,
    };

    print("Ride Request Body: $body");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          Get.snackbar("Success", "Ride Created Successfully",
              snackPosition: SnackPosition.BOTTOM);
          Get.to(() => RiderRequestUser());
        } else {
          print("Failed to create ride: ${responseData['message']}");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Error", "Unauthorized. Please login again.",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error creating ride: $e");
    }
  }

  bool isRideDataComplete() {
    print("Source Location: $sourceLocation");
    print("Destination Location: $destinationLocation");
    print("Distance: $distance");
    print("Price: $price");
    print("Destination Text: ${destinationTextController.text}");
    print("Pickup location: ${pickupPlaceController.text}");
    print("Ride Type: $rideType");

    // Ensure all required fields are non-empty or non-null
    return sourceLocation.value != null &&
        destinationLocation.value != null &&
        distance.value.isNotEmpty &&
        price.value.isNotEmpty &&
        destinationTextController.text.isNotEmpty &&
        pickupPlaceController.text.isNotEmpty;
    // Ensure currentAddress is filled
  }

  // Function to update ride type
  void setRideType(String type) {
    rideType.value = type;
  }
}
