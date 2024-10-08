import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/Components/expanded_bottom_nav_bar.dart';
import '../../../Components/dt_button.dart';
import '../../../utils/dt_colors.dart';

class ProfileCompletionScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void handleProfileCompletion() {
      String name = nameController.text.trim();
      String email = emailController.text.trim();


      print("Name: $name, Email: $email");

      if (name.isEmpty || email.isEmpty ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All fields are required'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print("Navigating to ExpandedBottomNavBar");
        FocusScope.of(context).unfocus();
        Get.to(() => ExpandedBottomNavBar(), transition: Transition.upToDown);
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Your Profile"),
        backgroundColor: AppColors.greenColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fill in your details',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30.h),

              // Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.h),

              // Email Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30.h,),

              // Submit Button
              CustomButton(
                text: 'Submit',
                bottonColor: AppColors.greenColor,
                textColor: Colors.white,
                onPressed: () {
                  handleProfileCompletion();

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
