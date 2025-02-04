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
  final UserWebSocketService webSocketService = UserWebSocketService();

  RxString passengerId = ''.obs;
  RxString driverId = ''.obs;
  Rx<String?> currentRideId = Rx<String?>(null);
  Rx<String> currentRideStatus = Rx<String>("");

  final String apiUrl = 'https://kantipur-rides-backend.onrender.com/api/v1/user/createRide';
  final TextEditingController destinationTextController = TextEditingController();
  final TextEditingController pickupPlaceController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    webSocketService.initializeConnection("https://kantipur-rides-backend.onrender.com");
    _registerWebSocketListeners();
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
      };



      print('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(apiUrl),
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


  bool isRideDataComplete() {
    print("Source Location: $sourceLocation");
    print("Destination Location: $destinationLocation");
    print("Distance: $distance");
    print("Price: $price");
    print("Destination Text: ${destinationTextController.text}");
    print("Pickup location: ${pickupPlaceController.text}");
    print("Ride Type: $rideType");

    return sourceLocation.value != null &&
        destinationLocation.value != null &&
        distance.value.isNotEmpty &&
        price.value.isNotEmpty &&
        destinationTextController.text.isNotEmpty &&
        pickupPlaceController.text.isNotEmpty;
  }

  void setRideType(String type) {
    rideType.value = type;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      sourceLocation.value = LatLng(position.latitude, position.longitude);
      await _getAddressFromLatLng(sourceLocation.value!);
    } catch (e) {
      print("Error fetching current location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey'));
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        sourceAddress.value = data['results'][0]['formatted_address'];
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  Future<void> onPlaceSelected(String description) async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$description&inputtype=textquery&fields=geometry&key=$apiKey'));
      final data = jsonDecode(response.body);

      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final location = data['candidates'][0]['geometry']['location'];
        destinationLocation.value = LatLng(location['lat'], location['lng']);
        destinationAddress.value = description.trim();
        await drawRoute();
      }
    } catch (e) {
      print("Error selecting place: $e");
    }
  }

  Future<void> drawRoute() async {
    if (sourceLocation.value == null || destinationLocation.value == null) {
      print("Error: Source or destination is not set.");
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${sourceLocation.value!.latitude},${sourceLocation.value!.longitude}&destination=${destinationLocation.value!.latitude},${destinationLocation.value!.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'].first;
          final polylinePoints = PolylinePoints().decodePolyline(route['overview_polyline']['points']);
          final routePoints = polylinePoints.map((point) => LatLng(point.latitude, point.longitude)).toList();

          polylines.add(Polyline(
            polylineId: PolylineId("route"),
            points: routePoints,
            color: Colors.greenAccent,
            width: 5,
          ));

          distance.value = route['legs'][0]['distance']['text'];
          duration.value = route['legs'][0]['duration']['text'];
          price.value = (route['legs'][0]['distance']['value'] / 1000 * 20).toStringAsFixed(2);
        }
      }
    } catch (e) {
      print("Error drawing route: $e");
    }
  }

  void _registerWebSocketListeners() {
    webSocketService.socket?.on("driver-location-updated", (data) {
      print("Driver location updated: $data");
    });

    webSocketService.socket?.on("ride-completed", (data) {
      Get.snackbar("Ride Completed", "Your ride has been completed!");
    });
  }
}

