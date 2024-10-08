import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/ride_confirm.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';

class RiderRequestUser extends StatelessWidget {
  const RiderRequestUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Likely final offers from driver',
              style: GoogleFonts.aBeeZee(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: Card(
                        color: AppColors.cardColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 20.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Sanjaya',
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.aBeeZee(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'MOTOR-BIKE TVS',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                            '4.91',
                                            style: GoogleFonts.aBeeZee(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '(550 rides)',
                                            style: GoogleFonts.aBeeZee(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Text(
                                        '5 min',
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '1,0 Km',
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'NPR92',
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                      text: 'Decline',
                                      width: 180.w,
                                      borderRadius: 20.r,
                                      bottonColor: AppColors.cardColor,
                                      textColor: Colors.white,
                                      onPressed: () {}),
                                  CustomButton(
                                      text: 'Accept',
                                      borderRadius: 20.r,
                                      width: 180.w,
                                      bottonColor: AppColors.greenColor,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Get.to(() => RideConfirmationScreen(), transition: Transition.upToDown);
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
