import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/View/Presentation/Admin/admin_dashboard_overview.dart';
import 'package:kantipur_ride/View/Presentation/Rider/validation.dart';
import 'package:kantipur_ride/View/Presentation/Rider/verify_rider.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:get/get.dart';


class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 80.h),
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
                SizedBox(height: 30.h),
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
                SizedBox(height: 80.h),
                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoginButtonEnabled? () {
                      Get.to(()=>AdminDashboardOverview(),transition: Transition.upToDown);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
