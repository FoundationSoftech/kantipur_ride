import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/onboarding_view.dart';
import 'package:get/get.dart';

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
        home: OnboardingView(),
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

