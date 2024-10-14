import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/View/Presentation/payment/esewa_payment.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VehiclesDetailScreen extends StatefulWidget {
  @override
  _VehiclesDetailScreenState createState() => _VehiclesDetailScreenState();
}

class _VehiclesDetailScreenState extends State<VehiclesDetailScreen> {
  final PageController _pageController = PageController();
  DateTime? rentDate;
  DateTime? returnDate;
  String rentType = 'Rent with driver';
  bool showLicenseField = false;
  bool _agreedToTerms = false;

  Future<void> _selectDate(BuildContext context, bool isRentDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != rentDate) {
      setState(() {
        if (isRentDate) {
          rentDate = pickedDate;
        } else {
          returnDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 20.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background gradient
            Container(
              height: 400.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent.shade700, Colors.lightBlue.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                // Vehicle image carousel
                Center(
                  child: SizedBox(
                    height: 260.h,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset(
                              'assets/rent.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 5,
                    effect: WormEffect(
                      dotColor: Colors.grey.shade400,
                      activeDotColor: Colors.blueAccent.shade700,
                      dotHeight: 10.h,
                      dotWidth: 10.w,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Vehicle Info Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Card(
                    elevation: 6,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            "Classic 500",
                            style: GoogleFonts.poppins(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "An old-school, post-war design built around an engine that one can count on...",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Specifications
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildSpecItem("Mileage", "35Kmpl"),
                              buildSpecItem("Max Power", "27.2 bhp"),
                              buildSpecItem("Displacement", "499cc"),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Select Rent & Return Dates
                          buildDateSelector("Renting Date", rentDate, true),
                          SizedBox(height: 20.h),
                          buildDateSelector("Returning Date", returnDate, false),

                          SizedBox(height: 20.h),
                          // Select Rent Type
                          Text("Select Rent Type:", style: GoogleFonts.poppins(fontSize: 16.sp)),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: Text("Rent with driver",style: GoogleFonts.abyssinicaSil(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,

                                  ),),
                                  value: 'Rent with driver',
                                  groupValue: rentType,
                                  onChanged: (value) {
                                    setState(() {
                                      rentType = value.toString();
                                      showLicenseField = false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: Text("Rent without driver",style: GoogleFonts.abyssinicaSil(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),),
                                  value: 'Rent without driver',
                                  groupValue: rentType,
                                  onChanged: (value) {
                                    setState(() {
                                      rentType = value.toString();
                                      showLicenseField = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // License Field if Rent without driver
                          if (showLicenseField)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Enter Driving License Number", style: GoogleFonts.poppins(fontSize: 16.sp)),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "License Number",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          CheckboxListTile(
                            value: _agreedToTerms,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _agreedToTerms = newValue ?? false;
                              });
                            },
                            title: Text("Agree to terms and conditions", style: GoogleFonts.poppins(fontSize: 14.sp)),
                          )

                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: CustomButton(
                      text: 'Rent Now',
                      textColor: Colors.white,
                      width: 200.w,
                      onPressed: (){
                        Get.to(()=> EsewaApp(title: ''));
                      },
                    bottonColor: AppColors.greenColor,
                    borderRadius: 20.r,
                  ),
                ),


                SizedBox(height: 30.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each specification item
  Widget buildSpecItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Widget to build date selector
  Widget buildDateSelector(String label, DateTime? date, bool isRentDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isRentDate),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.bold),
          ),
          Text(
            date != null ? DateFormat.yMd().format(date) : "Select Date",
            style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey[800],fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
