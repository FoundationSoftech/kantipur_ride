import 'package:flutter/material.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/user_register_screen.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/onboarding_rider_passenger.dart';
import '../../../utils/dt_colors.dart';
import 'onboarding_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Skip Button

          TextButton(
              // onPressed: () => Get.to(() => ExpandedBottomNavBar(), transition: Transition.cupertino),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const OnboardingRiderPassenger()));
              },
              child: Text(
                "Skip",
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              )),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 25),
        child: isLastPage
            ? getStarted() : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Indicator
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.35),
              child: SmoothPageIndicator(
                controller: pageController,
                count: controller.items.length,
                onDotClicked: (index) => pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn),
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: AppColors.primaryColor,
                ),
              ),
            ),

            // Next Button
            TextButton(
                onPressed: ()=>pageController.nextPage(
                    duration: const Duration(milliseconds: 600), curve: Curves.easeIn),
                child: const Text("Next")),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: PageView.builder(
            onPageChanged: (index) => setState(
                    () => isLastPage = controller.items.length - 1 == index),
            itemCount: controller.items.length,
            controller: pageController,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(controller.items[index].image,height: screenHeight*0.35,),
                  SizedBox(height: screenHeight*0.04),
                  Text(
                    controller.items[index].title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    margin: EdgeInsets.only(left: screenWidth*0.14,right: screenWidth*0.14),
                    child: Text(controller.items[index].descriptions,
                        style: TextStyle(color: Colors.black, fontSize: 18.sp,fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center),
                  ),
                ],
              );
            }),
      ),
    );
  }

  //  one time onboarding

  //Get started button

  Widget getStarted() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primaryColor,
      ),
      width: MediaQuery.of(context).size.width * .7,
      height: 55,
      child: CustomButton(
        onPressed: () async {
          final pres = await SharedPreferences.getInstance();
          pres.setBool("onboarding", true);

          //After we press get started button this onboarding value become true
          // same key
          if (!mounted) return;
          Get.to(() => const OnboardingRiderPassenger(), transition: Transition.upToDown);
        },


        borderRadius: 6,
        width: screenWidth * 0.6,
       text: "Get started",
        textColor: Colors.white,
      ),
    );
  }
}