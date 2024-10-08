import 'package:kantipur_ride/View/Presentation/Rider/rider_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';

class ValidationScreen extends StatelessWidget {
  const ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Validation',
            style: GoogleFonts.roboto(
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/done.gif',width: 200.w,

              ),
              Text('Validation Required',style: GoogleFonts.openSans(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),),
              SizedBox(height: 20.h,),
              Text('To give better services, we need to validate your location and phone states.We will also suggest some helpful app settings. Tap Allow in the next steps. ',

                style: GoogleFonts.openSans(

                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),),
              Spacer(),
              CustomButton(
                text: 'NEXT',
                textColor: Colors.white,
                bottonColor: AppColors.purpleColor,
                onPressed: () async{
                  //Request location and phone permissions

                  PermissionStatus locationStatus = await Permission.location.request();
                  PermissionStatus phoneStatus = await Permission.phone.request();

                  if(locationStatus.isGranted && phoneStatus.isGranted){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permissions Granted")));
                    Get.to(()=>RiderMap(),transition: Transition.upToDown);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permissions Denied")));
                  }
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),

    );
  }
}
