import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kantipur_ride/controller/shared_preferences.dart';
import '../Modal/recent_rides.dart';


class RecentRidesController extends GetxController {
  final RxList<RecentRide> recentRides = <RecentRide>[].obs;
  final RxBool isLoading = false.obs;
  final PrefrencesManager preferencesManager = Get.find<PrefrencesManager>();

  @override
  void onInit() {
    super.onInit();
    getDriverRecentRides();
  }

  Future<void> getDriverRecentRides() async {
    isLoading(true);
    try {
      final token = await preferencesManager.getAuthToken(); // Retrieve the token

      print('Token being used: $token'); // Debug token

      if (token == null) {
        print('No token found');
        return;
      }

      final response = await http.get(
        Uri.parse('https://kantipur-rides-backend.onrender.com/api/v1/user/getRecentRidePassenger'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status code: ${response.statusCode}'); // Debug status code
      print('Response body: ${response.body}'); // Debug response body

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed data: $data'); // Debug parsed data

        if (data['success'] == true && data['data'] != null) {
          final rides = (data['data'] as List)
              .map((ride) => RecentRide.fromJson(ride))
              .toList();
          print('Parsed rides: $rides'); // Debug parsed rides
          recentRides.assignAll(rides);
        }
      } else {
        print('Failed to load recent rides');
      }
    } catch (e) {
      print('Error fetching recent rides: $e');
    } finally {
      isLoading(false);
    }
  }
}