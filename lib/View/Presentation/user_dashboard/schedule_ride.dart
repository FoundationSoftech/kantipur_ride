import 'package:flutter/material.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Schedule/ride_schedule_screen.dart';

class ScheduleRide extends StatefulWidget {
  const ScheduleRide({super.key});

  @override
  State<ScheduleRide> createState() => _ScheduleRideState();
}

class _ScheduleRideState extends State<ScheduleRide> {
  // Boolean variable to toggle the visibility of RideScheduleScreen
  bool _isRideScheduleVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 40.h),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                bottonColor: AppColors.primaryColor,
                textColor: Colors.white,
                text: 'Click here to schedule your Ride',
                onPressed: () {
                  setState(() {
                    // Toggle the visibility of RideScheduleScreen
                    _isRideScheduleVisible = !_isRideScheduleVisible;
                  });
                },
              ),
              SizedBox(height: 10.h),  // Add some spacing
              // Conditionally render the RideScheduleScreen
              if (_isRideScheduleVisible)
                Expanded(child: RideScheduleScreen()),  // This widget will appear below the button
            ],
          ),
        ),
      ),
    );
  }
}

