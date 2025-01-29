import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:kantipur_ride/Components/expanded_bottom_nav_bar.dart';
import 'package:kantipur_ride/controller/ride_sharing_controller.dart';
import 'View/Presentation/onboarding/user_login_screen.dart';
import 'controller/option_controller.dart';
import 'controller/shared_preferences.dart';
import 'controller/user_login_controller.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(RideSharingController());
  Get.put(UserLoginController());  // Initialize singleton
  Get.put(PrefrencesManager());    // Initialize singleton
  await PrefrencesManager.init();
  Get.put(OptionController()); // Inject OptionController

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 885),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, home) {
        return FutureBuilder<String?>(
          future: PrefrencesManager().getAuthToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              // If there's an auth token, navigate to the main app screen
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                home: AnimatedSplashScreen(
                  splash: 'assets/logo.png',
                  splashIconSize: 200,
                  splashTransition: SplashTransition.scaleTransition,
                  backgroundColor: Colors.black,
                  duration: 4000,
                  nextScreen: ExpandedBottomNavBar(),
                ),
              );
            } else {
              // If there's no auth token, navigate to the login screen
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                home: AnimatedSplashScreen(
                  splash: 'assets/logo.png',
                  splashIconSize: 200,
                  splashTransition: SplashTransition.scaleTransition,
                  backgroundColor: Colors.black,
                  duration: 4000,
                  nextScreen: UserLoginScreen(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
