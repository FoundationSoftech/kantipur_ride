import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/View/Presentation/Rider/validation.dart';
import 'package:kantipur_ride/View/Presentation/Rider/verify_rider.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';


class RiderLoginScreen extends StatefulWidget {
  const RiderLoginScreen({Key? key}) : super(key: key);

  @override
  State<RiderLoginScreen> createState() => _RiderLoginScreenState();
}

class _RiderLoginScreenState extends State<RiderLoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoginButtonEnabled = false;

  void _checkInputFields(){
    //Enable the login button only if both fields are not empty
    if(mobileController.text.isNotEmpty && passwordController.text.isNotEmpty){
      setState(() {
        isLoginButtonEnabled = true;
      });
    }else{
      setState(() {
        isLoginButtonEnabled = false;
      });
    }
  }

  @override
  void initState() {
   //Add listenders to check for text changes in both fields
    mobileController.addListener(_checkInputFields);
    passwordController.addListener(_checkInputFields);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 40.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
             Row(
               children: [
                 Image.asset('assets/logo.png',width: 200.w,color: Colors.red,),
                 Text('kantipurdrive',style: GoogleFonts.lato(
                   fontSize: 22.sp,
                   fontWeight: FontWeight.w800,

                 ),)
               ],
             ),
                 SizedBox(height: 20.h),
              // Mobile number field
              TextField(
                controller: mobileController,
                decoration: InputDecoration(

                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    )
                  ),
                  labelText: 'Enter Your Mobile Number',
                  labelStyle: GoogleFonts.openSans(
                    color: Colors.grey,
                  )
                ),
                keyboardType: TextInputType.phone,
              ),
             SizedBox(height: 10.h),
              // Password field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                  ),
                  labelText: 'Enter Your Password',
                    labelStyle: GoogleFonts.openSans(
                      color: Colors.grey,
                    )
                ),
                obscureText: true,
              ),
             SizedBox(height: 20.h),
              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoginButtonEnabled? () {
                    Get.to(()=>ValidationScreen(),transition: Transition.upToDown);
                  }: (){},
                  child: Text('LOGIN',style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    backgroundColor: AppColors.appleRedColor,
                    padding:  EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            SizedBox(height: 10.h),
              // Forgot password text
              TextButton(
                onPressed: () {
                  // Add forgot password action here
                },
                child: Text(
                  'FORGOT PASSWORD?',
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
             SizedBox(height: 10.h),
              // Create new account button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                   Get.to(()=>VerifyNumber(),transition: Transition.upToDown);
                  },
                  child: Text('CREATE NEW ACCOUNT',style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appleRedColor,
                  ),),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.appleRedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    side:  BorderSide(color: AppColors.appleRedColor,),
                    padding:  EdgeInsets.symmetric(vertical: 15.h),
                  ),
                ),
              ),
            SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/drive.avif',width: 190.w,),
                  Image.asset('assets/driver1.avif',height: 250.h,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
