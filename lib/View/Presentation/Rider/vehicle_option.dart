import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantipur_ride/View/Presentation/Rider/rider_vehicle_detail.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';

class VehicleOption extends StatelessWidget {
  const VehicleOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[700],
        leading: InkWell(
          onTap: (){
            Get.back();
          },
            child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30.h,)),

        title: Align(
          alignment: Alignment.center,
          child: Text('Going to work as:',

            style: GoogleFonts.acme(
            fontSize: 22.sp,
            color: Colors.white,
          ),),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),

              height: 180.h,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RiderVehicleDetail()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/car.gif',height: 80.h,),
                          Text('Car',style: GoogleFonts.openSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),),
                          SizedBox(width: 150.w,),
                          Icon(Icons.arrow_forward_ios,color: AppColors.purpleColor,)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[200],
                    thickness: 6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RiderVehicleDetail()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/moto.png',height: 80.h,),
                          Text('Moto',style: GoogleFonts.openSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),),
                          SizedBox(width: 150.w,),
                          Icon(Icons.arrow_forward_ios,color: AppColors.purpleColor,)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}
