import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/Rider/city_selection.dart';

import '../../../Components/dt_button.dart';
import '../../../utils/dt_colors.dart';


class VerifyNumber extends StatefulWidget {
  const VerifyNumber({super.key});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {

  GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode focusNode = FocusNode();
  bool isPhoneValid = false;
  final TextEditingController phoneController = TextEditingController();

  void checkPhoneValidity(String? phone){
    //Validate phone number and update state
    setState(() {
      isPhoneValid = phone != null && phone.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 90.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(


              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Enter your mobile number',

                    style: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),),
                ),
                SizedBox(height: 20.h,),
                IntlPhoneField(
                  initialCountryCode: "NP",
                  focusNode: focusNode,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  languageCode: "en",
                  validator: (phone){
                    if(phone == null ){
                      return 'Phone number is required';
                    }
                    return null; //Valid phone number
                  },
                  onChanged: (phone) {
                    checkPhoneValidity(phone.completeNumber);
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ' + country.name);
                  },
                ),

                //Continue Button- Only enabled when phone is valid
                CustomButton(
                  text: 'Continue',
                  bottonColor: AppColors.greenColor,
                  textColor: Colors.white,

                  onPressed: isPhoneValid ? () {
                    if(_formKey.currentState?.validate() ?? false){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CitySelection()));
                    }

                    // Get.to(()=>OTPScreen());
                  } : () {},
                ),




              ],
            ),
          ),
        ),
      ),
    );
  }
}