import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Modal/sign_up_auth.dart';
import 'package:kantipur_ride/controller/shared_preferences.dart';

class SignUpController extends GetxController {
  final signupAuth = SignUpAuth();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  final RxBool isObscure = RxBool(true);
  final RxBool isConfirmPAsswordObscure = RxBool(true);

  final PrefrencesManager preferences = Get.put(PrefrencesManager());

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    super.onClose();
  }



  Future<bool> signUpPressed({
    required String name,
    required String email,
    required String mobileNumber,
  }) async {
    if (name.isEmpty || email.isEmpty || mobileNumber.isEmpty) {
      return false;
    }

    return await signupAuth.signUp(
      name: name,
      email: email,
      mobileNumber: mobileNumber,
    );
  }
}
