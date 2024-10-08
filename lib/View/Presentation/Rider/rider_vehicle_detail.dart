import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/Rider/rider_login.dart';
import 'package:kantipur_ride/View/Presentation/Rider/upload_documents.dart';
import '../../../utils/dt_colors.dart';
import 'package:kantipur_ride/Components/dt_button.dart';

class RiderVehicleDetail extends StatefulWidget {
  const RiderVehicleDetail({super.key});

  @override
  State<RiderVehicleDetail> createState() => _RiderVehicleDetailState();
}

class _RiderVehicleDetailState extends State<RiderVehicleDetail> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _vehiclePlateController = TextEditingController();
  final TextEditingController _vehicleYearController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _citizenshipController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();

  bool isFormComplete = false;

  // Function to capture image from the camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _checkFormCompletion();
      });
    }
  }

  // Function to select image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _checkFormCompletion();
      });
    }
  }

  // Check if all form fields are filled to change the button color
  void _checkFormCompletion() {
    if (_image != null &&
        _firstNameController.text.isNotEmpty &&

        _dateController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _licenseController.text.isNotEmpty &&
        _vehiclePlateController.text.isNotEmpty &&
        _vehicleYearController.text.isNotEmpty) {
      setState(() {
        isFormComplete = true;
      });
    } else {
      setState(() {
        isFormComplete = false;
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
            'Rider\'s vehicle detail',
            style: GoogleFonts.openSans(
              fontSize: 22.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Capture from Camera'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImageFromCamera();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Select from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImageFromGallery();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 150.w,
                    height: 150.h,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: _image != null
                        ? ClipOval(

                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt,
                            size: 50.h, color: Colors.grey),
                        SizedBox(height: 10.h),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Information',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildTextField('Full Name(Same as Driving License)', _firstNameController, TextInputType.text),
                SizedBox(height: 10.h),
                _buildTextField('Address', _addressController, TextInputType.text),
                SizedBox(height: 10.h),
                _buildTextField('Citizenship ID Number', _citizenshipController, TextInputType.text),
                SizedBox(height: 10.h),
                _buildTextField('PAN Number', _panNumberController, TextInputType.text),
                SizedBox(height: 10.h),
                _buildDateField(context),
                SizedBox(height: 10.h),
                _buildTextField('Email', _emailController, TextInputType.emailAddress),
                SizedBox(height: 30.h),
                Text(
                  'Vehicle Information',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildTextField('Driver license number', _licenseController, TextInputType.text),
                SizedBox(height: 10.h),
                _buildTextField('Vehicle Registration plate', _vehiclePlateController, TextInputType.text),
                SizedBox(height: 10.h),
                _buildTextField('Vehicle Production Year', _vehicleYearController, TextInputType.number),
                SizedBox(height: 30.h),
                Row(
                    children:[
                      Text('By signing up you are agree to terms and condition',
                        style: GoogleFonts.roboto(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 6.w,),
                      Text('terms and condition',style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.appleRedColor,
                        fontSize: 12.sp,
                        color: AppColors.appleRedColor,

                      ),),
                    ]),
                SizedBox(height: 20.h,),
                // Center(
                //   child: CustomButton(
                //     text: 'Submit',
                //     bottonColor: isFormComplete
                //         ? AppColors.greenColor // Active green color when complete
                //         : Colors.grey,         // Grey color when incomplete
                //     textColor: Colors.white,
                //     onPressed: isFormComplete
                //         ? () {
                //       Get.to(() => RiderDocumentsUpload(), transition: Transition.upToDown);
                //     }
                //         : (){}, // Disable button when form is incomplete
                //     width: double.infinity,
                //   ),
                // ),
                Center(
                  child: CustomButton(
                    text: 'Submit',
                    bottonColor: AppColors.greenColor ,
                      width: double.infinity,// Grey color when incomplete
                    textColor: Colors.white,
                    onPressed:  () {
                      Get.to(() => RiderDocumentsUpload(), transition: Transition.upToDown);
                    }


                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String labelText, TextEditingController controller, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (value) {
        _checkFormCompletion();
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  // Helper function to build the date picker text field
  Widget _buildDateField(BuildContext context) {
    return TextField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of birth',
        labelStyle: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
          setState(() {
            _dateController.text = formattedDate;
            _checkFormCompletion();
          });
        }
      },
    );
  }
}
