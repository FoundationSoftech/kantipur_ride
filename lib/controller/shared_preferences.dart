import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class PrefrencesManager extends GetxController {
  RxString authToken = ''.obs;
  RxInt userId = 0.obs;
  RxInt regID = 0.obs;
  RxString email = ''.obs;
  RxString username = ''.obs;

  static SharedPreferences? _prefs;


  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  Future<Map<String, dynamic>> getCurrentLocation() async {
    // Get current location logic
    return {"latitude": null, "longitude": null, "socketId": null};
  }

  Future<void> saveToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', token ?? '');
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token saved successfully!');
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }


  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('Retrieved token: $token');
    return token;
  }

  Future<void> saveCurrentLocation({
    required double latitude,
    required double longitude,
    required String socketId,
  }) async {
    // Use SharedPreferences or other storage methods to persist data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentLatitude', latitude);
    await prefs.setDouble('currentLongitude', longitude);
    await prefs.setString('socketId', socketId);
  }


  Future<double?> getCurrentLatitude() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('currentLatitude');
  }

  Future<double?> getCurrentLongitude() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('currentLongitude');
  }

  Future<String?> getSocketId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('socketId');
  }



  Future<void> saveuserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Method to save user email
  Future<void> saveUserEmail(String userEmail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', userEmail);
  }

  Future<String?> getuserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }


  Future<void> clearuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = 0;
    prefs.remove('userId');
  }

  Future<int> getRegId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedUserId = prefs.getInt('regID') ?? 0;
    regID.value = storedUserId; // Update userId observable
    return storedUserId;
  }

  Future<void> clearRegId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    regID.value = 0;
    prefs.remove('regID');
  }

  Future<void> saveUsername(String? name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', name ?? '');
    username.value = name ?? '';
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
    return username.value.isNotEmpty ? username.value : null;
  }

  Future<void> saveEmail(String? emailAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailAddress ?? '');
    email.value = emailAddress ?? '';
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email.value = prefs.getString('email') ?? '';
    return email.value.isNotEmpty ? email.value : null;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    authToken.value = '';
    userId.value = 0;
    username.value = '';
    email.value = '';
    print('Session cleared successfully!');
  }
}
