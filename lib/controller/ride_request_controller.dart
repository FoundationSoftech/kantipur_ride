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
    socketService.initializeConnection("https://kantipur-rides-backend.onrender.com","");
  }




}
