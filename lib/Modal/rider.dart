class Rider {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> rideHistory;
  final String currentRideStatus;

  Rider({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.rideHistory,
    required this.currentRideStatus,
  });
}
