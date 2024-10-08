import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/onboarding_view.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/rider_request.dart';
import 'View/Presentation/onboarding/onboarding_rider_passenger.dart';
import 'View/Presentation/payment/esewa_payment.dart';

void main() {

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
        builder:((context) => const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 885),
      minTextAdapt: true,
      splitScreenMode: true,

       child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
              splash: 'assets/logo.png',

            splashIconSize: 200,

            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Colors.black,
            duration: 4000,
            nextScreen: OnboardingView(),
            // nextScreen: RiderRequestUser(),
          ),
          // home: RiderLoginScreen(),
          // home: UserSelectionScreen(),
          // home: DashboardOverview(),
          // home: MapExample(),
          // home: UserRegister(),
          // home: OnboardingRiderPassenger(),
        ),
    );
  }
}

