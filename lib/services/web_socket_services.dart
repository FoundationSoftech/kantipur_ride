import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';


// class WebSocketService {
//   IO.Socket? socket; // Make socket nullable
//
//   // Initialize and connect to the server
//   void initializeConnection(String serverUrl) {
//     socket = IO.io(
//       serverUrl,
//       IO.OptionBuilder()
//           .setTransports(['websocket']) // Ensure WebSocket transport is used
//           .enableAutoConnect() // Automatically connect to the server
//           .build(),
//     );
//
//     // Register connection events
//     socket?.onConnect((_) {
//       print("Connected to WebSocket Server");
//     });
//
//     socket?.onDisconnect((_) {
//       print("Disconnected from WebSocket Server");
//     });
//
//     // Register all listeners
//     registerSocketListeners();
//   }
//
//   void on(String event, Function(dynamic) callback) {
//     socket?.on(event, (data) => callback(data));
//   }
//
//   void emit(String event, dynamic data) {
//     socket?.emit(event, data);
//   }
//
//   // Emit driver location update
//   void updateDriverLocation(String driverId, double latitude, double longitude) {
//     socket?.emit("update-driver-location", {
//       "driverId": driverId,
//       "latitude": latitude,
//       "longitude": longitude,
//     });
//     print("Driver location sent: $latitude, $longitude");
//   }
//
//   // Emit passenger location update
//   void updatePassengerLocation(String passengerId, double latitude, double longitude) {
//     socket?.emit("update-passenger-location", {
//       "passengerId": passengerId,
//       "latitude": latitude,
//       "longitude": longitude,
//     });
//     print("Passenger location sent: $latitude, $longitude");
//   }
//
//   void listenForRideRequests(Function(Map<String, dynamic>) onRideRequest) {
//     // Listen to WebSocket event for incoming ride requests
//     socket?.on('ride-request', (data) {
//       onRideRequest(data); // Pass the data to the provided callback
//     });
//   }
//
//   // Emit ride events
//   void rideCancel(String rideId, String cancelledBy) {
//     socket?.emit("ride-cancel", {"rideId": rideId, "cancelledBy": cancelledBy});
//     print("Ride $rideId canceled by $cancelledBy");
//   }
//
//   void acceptRide(String rideId, String driverId, Map<String, dynamic> pickupLocation) {
//     socket?.emit("accept-ride", {
//       "rideId": rideId,
//       "driverId": driverId,
//       "pickupLocation": pickupLocation,
//     });
//     print("Ride $rideId accepted by driver $driverId");
//   }
//
//   void ridePickup(String rideId, String driverId, String passengerId) {
//     socket?.emit("ride-pickup", {
//       "rideId": rideId,
//       "driverId": driverId,
//       "passengerId": passengerId,
//     });
//     print("Ride $rideId picked up by driver $driverId");
//   }
//
//   void rideCompleted(String rideId, String driverId, String passengerId, double fare) {
//     socket?.emit("ride-completed", {
//       "rideId": rideId,
//       "driverId": driverId,
//       "passengerId": passengerId,
//       "fare": fare,
//     });
//     print("Ride $rideId completed. Fare: $fare");
//   }
//
//   // Register listeners for incoming events
//   void registerSocketListeners() {
//     socket?.on("ride-cancel", (data) {
//       print("Ride Cancelled: $data");
//       Get.snackbar("Ride Cancelled", "The ride has been cancelled by the user.");
//     });
//
//     socket?.on("accept-ride", (data) {
//       print("Ride Accepted: $data");
//       Get.snackbar("Ride Accepted", "Your ride request has been accepted!");
//     });
//
//     socket?.on("ride-pickup", (data) {
//       print("Ride Pickup: $data");
//       Get.snackbar("Ride Pickup", "Your driver has arrived for the pickup.");
//     });
//
//     socket?.on("ride-completed", (data) {
//       print("Ride Completed: $data");
//       Get.snackbar("Ride Completed", "Your ride has been completed!");
//     });
//
//     socket?.on("ride-request", (data) {
//       print("Ride Request received: $data");
//       Get.snackbar("New Ride Request", "A new ride request has been received!");
//     });
//   }
//
//   // Disconnect the socket
//   void disconnect() {
//     socket?.disconnect();
//     print("Disconnected from WebSocket Server");
//   }
// }


class UserWebSocketService {
  IO.Socket? socket;

  /// Initialize and connect to the server
  void initializeConnection(String serverUrl) {
    socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Ensure WebSocket transport
          .enableAutoConnect() // Automatically connect
          .build(),
    );

    // Register connection event handlers
    socket?.onConnect((_) {
      print("Connected to WebSocket Server");
      Get.snackbar("Connection Status", "Connected to the server");
    });

    socket?.onDisconnect((_) {
      print("Disconnected from WebSocket Server");
      Get.snackbar("Connection Status", "Disconnected from the server");
    });

    // Register custom event listeners
    registerSocketListeners();
  }

  /// Emit events to the server
  void emit(String event, dynamic data) {
    socket?.emit(event, data);
    print("Emitted event: $event with data: $data");
  }

  /// Emit passenger location update
  void updatePassengerLocation(String passengerId, double latitude, double longitude) {
    emit("update-passenger-location", {
      "passengerId": passengerId,
      "latitude": latitude,
      "longitude": longitude,
    });
  }

  /// Listen for incoming ride requests
  void listenForRideRequests() {
    socket?.on('ride-request', (data) {
      print('Ride request received: $data');
      // Add any additional handling logic here
    });
  }


  /// Emit ride-related events
  void rideCancel(String rideId, String cancelledBy) {
    emit("ride-cancel", {"rideId": rideId, "cancelledBy": cancelledBy});
  }

  void acceptRide(String rideId, String driverId, Map<String, dynamic> pickupLocation) {
    emit("accept-ride", {
      "rideId": rideId,
      "driverId": driverId,
      "pickupLocation": pickupLocation,
    });
  }

  void ridePickup(String rideId, String driverId, String passengerId) {
    emit("ride-pickup", {
      "rideId": rideId,
      "driverId": driverId,
      "passengerId": passengerId,
    });
  }

  void rideCompleted(String rideId, String driverId, String passengerId, double fare) {
    emit("ride-completed", {
      "rideId": rideId,
      "driverId": driverId,
      "passengerId": passengerId,
      "fare": fare,
    });
  }

  /// Register listeners for incoming events
  void registerSocketListeners() {
    socket?.on("ride-cancel", (data) {
      print("Ride Cancelled: $data");
      Get.snackbar("Ride Cancelled", "The ride was cancelled.");
    });

    socket?.on("accept-ride", (data) {
      print("Ride Accepted: $data");
      Get.snackbar("Ride Accepted", "Your ride request has been accepted.");
    });

    socket?.on("ride-pickup", (data) {
      print("Ride Pickup: $data");
      Get.snackbar("Ride Pickup", "Your driver has arrived for the pickup.");
    });

    socket?.on("ride-completed", (data) {
      print("Ride Completed: $data");
      Get.snackbar("Ride Completed", "Your ride has been completed!");
    });

    socket?.on("ride-request", (data) {
      print("Ride Request received: $data");
      Get.snackbar("New Ride Request", "A new ride request has been received!");
    });
  }

  /// Disconnect the socket
  void disconnect() {
    socket?.disconnect();
    print("Disconnected from WebSocket Server");
  }
}
