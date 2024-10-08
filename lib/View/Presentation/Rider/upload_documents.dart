import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/View/Presentation/Rider/rider_login.dart';
import '../../../Components/dt_button.dart';
import '../../../utils/dt_colors.dart';

class RiderDocumentsUpload extends StatefulWidget {
  const RiderDocumentsUpload({super.key});

  @override
  State<RiderDocumentsUpload> createState() => _RiderDocumentsUploadState();
}

class _RiderDocumentsUploadState extends State<RiderDocumentsUpload> {

  File? _image;
  final ImagePicker _picker = ImagePicker();

  File? _bluebook;
  File? _insurance;
  File? _registration;



  // Function to capture image from the camera
  Future<void> _pickDocumentFromGallery() async {
    final licenseFile = await _picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
    );

    if (licenseFile != null) {
      setState(() {
        _image = File(licenseFile.path);

      });
    }

    final bluebookFile = await _picker.pickImage(
        source: ImageSource.gallery,

    );
    if(bluebookFile != null){
      setState(() {
        _bluebook = File(bluebookFile.path);
      });
    }

    final insuranceFile = await _picker.pickImage(
      source: ImageSource.gallery,

    );
    if(insuranceFile != null){
      setState(() {
        _insurance = File(insuranceFile.path);
      });
    }

    final registrationFile = await _picker.pickImage(
      source: ImageSource.gallery,

    );
    if(registrationFile != null){
      setState(() {
        _registration = File(registrationFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[700],
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30.h)),

        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Rider\'s Document',
            style: GoogleFonts.openSans(
              fontSize: 22.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 20.h),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            // ListTile(
                            //   leading: Icon(Icons.camera_alt),
                            //   title: Text('Capture from Camera'),
                            //   onTap: () {
                            //     Navigator.pop(context);
                            //     _pickDocumentFromCamera();
                            //   },
                            // ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Select from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                               _pickDocumentFromGallery();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Upload License',
                          style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
          
                        ),),
                      ),
                      SizedBox(height: 10.h,),
                      Container(
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: _image != null
                            ? ClipRect(
          
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/image.png',height: 50.h,),
                            SizedBox(height: 10.h),
          
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Upload Bluebook',
          
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
          
                          ),),
                      ),
                      SizedBox(height: 10.h,),
                      Container(
                        width: double.infinity,
                        height: 150.h,
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: _bluebook != null
                            ? ClipRect(
          
                          child: Image.file(
                            _bluebook!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/image.png',height: 50.h,),
                            SizedBox(height: 10.h),
          
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Upload Insurance',
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
          
                          ),),
                      ),
                      SizedBox(height: 10.h,),
                      Container(
                        width: double.infinity,
                        height: 150.h,
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: _insurance != null
                            ? ClipRect(
          
                          child: Image.file(
                            _insurance!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/image.png',height: 50.h,),
                            SizedBox(height: 10.h),
          
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Vehicle Registration',
          
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
          
                          ),),
                      ),
                      SizedBox(height: 10.h,),
                      Container(
                        width: double.infinity,
                        height: 150.h,
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: _registration != null
                            ? ClipRect(
          
                          child: Image.file(
                            _registration!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/image.png',height: 50.h,),
                            SizedBox(height: 10.h),
          
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h,),
                Center(
                  child: CustomButton(
                    text: 'Submit',
                    bottonColor:  AppColors.greenColor ,
                      width: double.infinity,
                    textColor: Colors.white,

                    onPressed:  () {
                        Get.to(() => RiderLoginScreen(),
                            transition: Transition.upToDown);
                      },
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
