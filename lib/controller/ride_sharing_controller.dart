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

  final UserWebSocketService webSocketService = UserWebSocketService(); // Singleton instance

  RxString passengerId = ''.obs;
  RxString driverId = ''.obs;

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

  // Define the variable
  Rx<String?> currentRideId = Rx<String?>(null);  // Nullable reactive string
  Rx<String> currentRideStatus = Rx<String>("");  // Non-nullable reactive string

  // API endpoint
  final String apiUrl =
      'https://kantipur-rides-backend.onrender.com/api/v1/user/createRide';

  Future<void> createRide() async {
    if (!isRideDataComplete()) {
      Get.snackbar("Error", "Please fill in all ride details", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    String? token = await PrefrencesManager().getAuthToken();
    if (token == null) {
      Get.snackbar("Error", "User is not authenticated. Please login again.", snackPosition: SnackPosition.BOTTOM);
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
          Get.snackbar("Success", "Ride Created Successfully", snackPosition: SnackPosition.BOTTOM);
          webSocketService.registerSocketListeners();
          Get.to(() => RiderRequestUser());
        } else {
          print("Failed to create ride: ${responseData['message']}");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Error", "Unauthorized. Please login again.", snackPosition: SnackPosition.BOTTOM);
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
  }

  // Function to update ride type
  void setRideType(String type) {
    rideType.value = type;
  }

  final TextEditingController destinationTextController = TextEditingController();
  final TextEditingController pickupPlaceController = TextEditingController();

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

