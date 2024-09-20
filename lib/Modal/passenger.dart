class Passenger {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> rideHistory;
  final String currentRideStatus;

  Passenger({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.rideHistory,
    required this.currentRideStatus,
  });
}
