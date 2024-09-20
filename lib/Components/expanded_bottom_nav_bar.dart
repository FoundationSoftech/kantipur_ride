import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/user_dashboard_screen.dart';
import '../Controller/expanded_nav_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../View/Presentation/Rental/rental_onboarding.dart';
import '../utils/dt_colors.dart';


class ExpandedBottomNavBar extends StatefulWidget {
  // final PrefrencesManager prefs = Get.put(PrefrencesManager());

  ExpandedBottomNavBar({
    Key? key,

  }) : super(key: key);

  @override
  State<ExpandedBottomNavBar> createState() => _ExpandedBottomNavBarState();
}

class _ExpandedBottomNavBarState extends State<ExpandedBottomNavBar> {
  late ExpandedNavController controller = ExpandedNavController();


  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ExpandedNavController());
    // var token = prefrencesManager.getAuthToken();

    var navbarItem = [
      BottomNavigationBarItem(
        icon: Obx(() => Image.asset(
          'assets/home.png',  // For PNG
          width: 24,
          height: 24,
          color: controller.currentNavIndex.value == 0
              ? AppColors.redColor
              : Colors.black,
        )),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Obx(() => Image.asset(
          // key: foryou,
          'assets/bell.png',
          width: 24,
          height: 24,
          color: controller.currentNavIndex.value == 1
              ? AppColors.redColor
              : Colors.black
        )),
        label: 'For you',
      ),
      BottomNavigationBarItem(
        icon: Obx(
              () => Image.asset(

                'assets/rent.png',
            width: 24,
            height: 24,
            color: controller.currentNavIndex.value == 2
                ? AppColors.redColor
                : Color(0xff868686),
          ),
        ),
        label: 'Rental',
      ),


    ];

    var navBody = [
     UserDashboardScreen(),
      Container(),
      RentalOnboarding(),


    ];

    return WillPopScope(
      onWillPop: () async {
        if (controller.currentNavIndex.value == 0) {
          SystemNavigator.pop();
          return false;
        } else {
          controller.currentNavIndex.value = 0;
          return false;
        }
      },
      child: Scaffold(
        body: Obx(() => navBody[controller.currentNavIndex.value]),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.redColor,
          unselectedItemColor: AppColors.backgroundColor,
          selectedIconTheme: IconThemeData(color: AppColors.redColor),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Color(0xff222222)
              : Color(0xffFFFFFF),
          items: navbarItem,
          selectedLabelStyle: TextStyle(
            color: AppColors.redColor,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            color: Color(0xff868686),
            fontSize: 10,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (value) {
            controller.currentNavIndex.value = value;
            IconThemeData(color: Colors.red);
          },
        )),

      ),
    );
  }
}
