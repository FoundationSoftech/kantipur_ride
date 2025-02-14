import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../controller/shared_preferences.dart';

class UserWebSocketService {
  static final UserWebSocketService _instance = UserWebSocketService._internal();

  factory UserWebSocketService() => _instance;

  // Callbacks for UI updates
  Function(Map<String, dynamic>)? onDriverLocation;
  Function(Map<String, dynamic>)? onRideStatusUpdate;

  final PrefrencesManager prefrencesManager = PrefrencesManager();

  IO.Socket? socket;
  bool isConnected = false;
  String? socketId; // Store socket ID
  String? _token;

  UserWebSocketService._internal();

  Function(Map<String, dynamic>)? onRideAcceptReceived;

  Function(Map<String, dynamic>)? onRideCancelReceived;
  Rx<Map<String, dynamic>?> acceptRide = Rx<Map<String, dynamic>?>(null);

  void onConnect(String token) {
    _token = token; // Store token for potential reconnections

    if (socket == null || !(socket?.connected ?? false)) {
      initializeConnection("https://kantipur-rides-backend.onrender.com", token);
    }
  }


  // void initializeConnection(String serverUrl, String token) {
  //   try {
  //     // Prevent multiple connection attempts
  //     if (socket != null && socket!.connected) {
  //       print("Socket already connected. Returning.");
  //       return;
  //     }
  //
  //     // Add timeout for connection
  //     socket = IO.io(
  //       serverUrl,
  //       IO.OptionBuilder()
  //           .setTransports(['websocket'])
  //           .enableAutoConnect()
  //           .setReconnectionAttempts(5)
  //           .setReconnectionDelay(1000) // 1 second delay between reconnection attempts
  //           .setTimeout(10000) // 10 seconds timeout
  //           .build(),
  //     );
  //
  //     // Handle connection events
  //     socket?.onConnect((_) async {
  //       print("Successfully Connected to WebSocket Server");
  //       print("Socket ID: ${socket?.id}");
  //       _updateConnectionState(true);
  //
  //       // Verify connection status
  //       if (socket?.connected == true) {
  //         Get.snackbar(
  //           "Connection Status",
  //           "Connected to the server",
  //           backgroundColor: Colors.green,
  //           colorText: Colors.white,
  //         );
  //
  //         // Proceed with initialization steps
  //         await initializeUserSession(token);
  //       }
  //     });
  //
  //     // Handle connection errors
  //     socket?.onConnectError((error) {
  //       print("WebSocket Connection Error: $error");
  //       _updateConnectionState(false);
  //       Get.snackbar(
  //         "Connection Error",
  //         "Failed to connect to server: $error",
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //
  //       // Retry connection after a delay
  //       Future.delayed(Duration(seconds: 5), () => reconnect());
  //     });
  //
  //     // Handle general errors
  //     socket?.onError((error) {
  //       print("WebSocket Error: $error");
  //       _updateConnectionState(false);
  //       Get.snackbar(
  //         "Socket Error",
  //         "An error occurred: $error",
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     });
  //
  //   } catch (e) {
  //     print("Unexpected error in WebSocket initialization: $e");
  //     Get.snackbar(
  //       "Initialization Error",
  //       "Could not initialize WebSocket: $e",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  void initializeConnection(String serverUrl, String token) {
    try {
      if (socket != null && socket!.connected) {
        print("Socket already connected. Returning.");
        return;
      }

      socket = IO.io(
        serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .setTimeout(10000)
            .build(),
      );

      socket?.onConnect((_) async {
        print("Successfully Connected to WebSocket Server");
        print("Socket ID: ${socket?.id}");
        _updateConnectionState(true);

        if (socket?.connected == true) {
          Get.snackbar(
            "Connection Status",
            "Connected to the server",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          await initializeUserSession(token);
        }
      });

      socket?.onConnectError((error) {
        print("WebSocket Connection Error: $error");
        _updateConnectionState(false);
        Get.snackbar(
          "Connection Error",
          "Failed to connect to server: $error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        Future.delayed(Duration(seconds: 5), () => reconnect());
      });

      socket?.onError((error) {
        print("WebSocket Error: $error");
        _updateConnectionState(false);
        Get.snackbar(
          "Socket Error",
          "An error occurred: $error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    } catch (e) {
      print("Unexpected error in WebSocket initialization: $e");
      Get.snackbar(
        "Initialization Error",
        "Could not initialize WebSocket: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Emit events to the server
  void emit(String event, dynamic data) {
    if (socket?.connected == true) {
      socket?.emit(event, data);
      print("📤 Emitted event: $event with data: $data");
    } else {
      print("❌ WebSocket not connected. Cannot emit event.");
    }
  }

  void registerSocketListeners() {
    Map<String, String> eventMessages = {
      "ride-cancel": "The ride was cancelled.",
      "ride-pickup": "Driver has arrived.",
      "ride-completed": "Ride completed successfully.",
      "accept-ride": "Ride request accepted."
    };

    eventMessages.forEach((event, message) {
      socket?.on(event, (data) {
        print("$event: $data");
        Get.snackbar(
            event.replaceAll("-", " ").capitalizeFirst!,
            message,
            backgroundColor: event.contains('decline') ? Colors.red : Colors.green,
            colorText: Colors.white
        );
      });
    });
  }

  // In a network change listener
  void onNetworkChange(bool isConnected) {
    if (!isConnected) {
      reconnect();
    }
  }

// In app lifecycle method
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      reconnect();
    }
  }

  Future<void> refreshToken() async {
    String? newToken = await prefrencesManager.getAuthToken();
    if (newToken != null) {
      _token = newToken;
    } else {
      print("Failed to refresh token.");
    }
  }

  Future<void> updatePassengerLocation(String token, String passengerId, LatLng location) async {
    if (socket?.connected != true) {
      print('❌ Socket not connected. Cannot update location.');
      return;
    }

    try {
      final completer = Completer<void>();

      print("📡 Emitting location update:");
      print("   - Passenger ID: $passengerId");
      print("   - Latitude: ${location.latitude}");
      print("   - Longitude: ${location.longitude}");
      print("   - Socket ID: ${socket?.id}");

      socket?.emitWithAck(
          'update-passenger-location',
          {
            'passengerId': passengerId,
            'currentLatitude': location.latitude,
            'currentLongitude': location.longitude,
            'socketId': socket?.id,
          },
          ack: (data) {
            print('✅ ACK received from server: $data');
            completer.complete();
          }
      );

      await completer.future.timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('❌ Location update timeout! No ACK received.');
        },
      );
    } catch (e) {
      print('❌ Error updating location: $e');
    }
  }




  // Optional: Add a method to verify the socket connection before updating
  bool verifyConnection() {
    if (socket?.connected != true) {
      print('Socket disconnected. Attempting reconnection...');
      reconnect();
      return false;
    }
    return true;
  }
  // New method to handle driver session initialization
  Future<void> initializeUserSession(String token) async {
    try {
      // Fetch driver ID
      String? passengerId = await prefrencesManager.getuserId();

      if (passengerId == null) {
        print("Error: Driver ID is null");
        return;
      }

      // Get location with error handling
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10)
        );

        LatLng currentLocation = LatLng(position.latitude, position.longitude);
        updatePassengerLocation(token,passengerId,currentLocation);
      } catch (locationError) {
        print("Location retrieval error: $locationError");
        Get.snackbar(
            "Location Error",
            "Could not retrieve current location",
            backgroundColor: Colors.orange,
            colorText: Colors.white
        );
      }

      // Setup listeners after successful connection
      setupRideAcceptListener();
      setupRideCancelListener();
      registerSocketListeners();


    } catch (sessionError) {
      print("Driver session initialization error: $sessionError");
      Get.snackbar(
          "Session Error",
          "Failed to initialize driver session",
          backgroundColor: Colors.red,
          colorText: Colors.white
      );
    }
  }


  void setupRideAcceptListener() {
    socket?.on('accept-ride', (data) {
      if (data != null) {
        // Detailed logging of the ride request
        print("Accept ride: {");
        print("  rideId: ${data['rideId']},");
        print("  pickupLatitude: ${data['pickupLatitude']},");
        print("  pickupLongitude: ${data['pickupLongitude']},");
        print("  destinationLatitude: ${data['destinationLatitude']},");
        print("  destinationLongitude: ${data['destinationLongitude']},");
        print("  destinationPlaceName: ${data['destinationPlaceName']},");
        print("  pickupPlaceName: ${data['pickupPlaceName']},");
        print("  fare: ${data['fare']},");
        print("  distance: ${data['distance']},");
        print("  rideType: ${data['rideType']}");
        print("}");

        // Convert data to proper Map if needed
        final Map<String, dynamic> rideData = data is Map
            ? Map<String, dynamic>.from(data)
            : jsonDecode(data.toString());

        // Call the callback to update UI
        if (onRideAcceptReceived != null) {
          onRideAcceptReceived!(rideData);
        }

        // Show notification
        Get.snackbar(
          "Ride Accepted",
          "From: ${data['pickupPlaceName']}\nTo: ${data['destinationPlaceName']}\nFare: ${data['fare']}",
          duration: Duration(seconds: 10),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print("Warning: Received null ride request data");
      }
    });
  }

  void setupRideCancelListener() {
    socket?.on('ride-cancel', (data) {
      if (data != null) {
        // Detailed logging of the ride request
        print("Cancel ride: {");
        print("  rideId: ${data['rideId']},");
        print("  pickupLatitude: ${data['pickupLatitude']},");
        print("  pickupLongitude: ${data['pickupLongitude']},");
        print("  destinationLatitude: ${data['destinationLatitude']},");
        print("  destinationLongitude: ${data['destinationLongitude']},");
        print("  destinationPlaceName: ${data['destinationPlaceName']},");
        print("  pickupPlaceName: ${data['pickupPlaceName']},");
        print("  fare: ${data['fare']},");
        print("  distance: ${data['distance']},");
        print("  rideType: ${data['rideType']}");
        print("}");

        // Convert data to proper Map if needed
        final Map<String, dynamic> rideData = data is Map
            ? Map<String, dynamic>.from(data)
            : jsonDecode(data.toString());

        // Call the callback to update UI
        if (onRideCancelReceived != null) {
          onRideCancelReceived!(rideData);
        }

        // Show notification
        Get.snackbar(
          "Ride Accepted",
          "From: ${data['pickupPlaceName']}\nTo: ${data['destinationPlaceName']}\nFare: ${data['fare']}",
          duration: Duration(seconds: 10),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print("Warning: Received null ride request data");
      }
    });
  }

  Future<void> reconnect() async {
    if (_token == null) {
      print("Token is null. Cannot reconnect.");
      return;
    }

    // Disconnect existing socket
    socket?.disconnect();

    // Reinitialize connection with stored token
    initializeConnection("https://kantipur-rides-backend.onrender.com", _token!);

    // Wait for connection to be established
    await Future.delayed(Duration(seconds: 2)); // Adjust delay as needed

    if (socket?.connected != true) {
      print("Failed to reconnect.");
    }
  }

  void _updateConnectionState(bool isConnected) {
    isConnected = isConnected;
    // Notify listeners or update UI if needed
    if (isConnected) {
      print("WebSocket connected.");
    } else {
      print("WebSocket disconnected.");
    }
  }

  /// Disconnect the WebSocket
  void disconnect() {
    socket?.disconnect();
    socket?.clearListeners(); // Clear all listeners
    _updateConnectionState(false);
    socketId = null;
    print("❌ WebSocket Disconnected");
  }
  /// Getter for socketId
  String? getSocketId() {
    return socketId;
  }

}

