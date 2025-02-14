import 'dart:convert';

import '../controller/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RecentRide {
  final String id;
  final String pickupPlaceName;
  final String destinationPlaceName;
  final double fare;
  final double distance;
  final int duration;
  final int status;

  RecentRide({
    required this.id,
    required this.pickupPlaceName,
    required this.destinationPlaceName,
    required this.fare,
    required this.distance,
    required this.duration,
    required this.status,
  });

  factory RecentRide.fromJson(Map<String, dynamic> json) {
    return RecentRide(
      id: json['_id'] ?? '',
      pickupPlaceName: json['pickupPlaceName'] ?? '',
      destinationPlaceName: json['destinationPlaceName'] ?? '',
      fare: (json['fare'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      status: json['status'] ?? 0, // Ensure status is an int
    );
  }
}

// services/ride_service.dart


class RideService {
  static const String baseUrl = 'https://kantipur-rides-backend.onrender.com/api/v1/driver/getDriverRecentRides';
  final PrefrencesManager prefrencesManager = PrefrencesManager();

  static Future<List<RecentRide>> getDriverRecentRides() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/getDriverRecentRides'),
        headers: {
          'Authorization': 'Bearer ${Get.find<PrefrencesManager>().getAuthToken()}', // Assuming you have AuthController
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((ride) => RecentRide.fromJson(ride))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching recent rides: $e');
      return [];
    }
  }
}
