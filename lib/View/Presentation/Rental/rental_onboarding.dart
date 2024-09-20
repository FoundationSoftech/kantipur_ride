import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/View/Presentation/Rental/rental_dashboard.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class RentalOnboarding extends StatelessWidget {
  const RentalOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
           Align(
             alignment: Alignment.topLeft,
               child: Image.asset('assets/rent.jpeg')),
            Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/rent1.jpeg')),
            Spacer(),
            Text('Vehicle Rental By Kantipur Ride',style: GoogleFonts.openSans(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
            SizedBox(height: 10.h,),
            Text('Rent a vehicle online today & enjoy the best Deals, Rates, & Accessories ',style: GoogleFonts.openSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),),
            Spacer(),
            CustomButton(
              suffixIcon: Icons.double_arrow,
              bottonColor: Colors.white,
                text: 'Let\'s Go!', onPressed: (){
                Get.to(()=>RentalDashboard(),transition: Transition.upToDown);
            }
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
