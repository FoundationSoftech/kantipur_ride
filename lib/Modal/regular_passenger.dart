class RegularPassenger {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> rideHistory;
  final String currentRideStatus;
  final String profilePictureUrl;

  RegularPassenger({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.rideHistory,
    required this.currentRideStatus,
    required this.profilePictureUrl,
  });
}
