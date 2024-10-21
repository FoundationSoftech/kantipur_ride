import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class PrefrencesManager extends GetxController {
  RxString authToken = ''.obs;
  RxInt userId = 0.obs;
  RxInt regID = 0.obs;
  RxString email = ''.obs;
  RxString username = ''.obs;


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


  Future<void> saveuserId(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', id ?? 0);
    userId.value = id ?? 0;
  }
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('Retrieved token: $token');
    return token;
  }


  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedUserId = prefs.getInt('userId') ?? 0;
    userId.value = storedUserId; // Update userId observable
    return storedUserId;
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
