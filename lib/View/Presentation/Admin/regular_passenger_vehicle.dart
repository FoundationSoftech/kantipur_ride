import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class RequestItem extends StatelessWidget {
  final String requestId;
  final String passengerName;
  final String requestTime;
  final bool isRegular; // Indicates if the passenger is a regular customer

  const RequestItem({
    required this.requestId,
    required this.passengerName,
    required this.requestTime,
    required this.isRegular,
  });

  @override
  Widget build(BuildContext context) {
    // Only show the item if the passenger is regular
    if (!isRegular) return SizedBox.shrink();

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      title: Text('$passengerName - $requestId'),
      subtitle: Text('Requested at: $requestTime'),
      trailing: ElevatedButton(
        onPressed: () {
          // Handle vehicle assignment
          showVehicleAssignmentDialog(context);
        },
        child: Text('Assign Vehicle',style: GoogleFonts.openSans(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),),
      ),
    );
  }

  void showVehicleAssignmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assign Vehicle',style: GoogleFonts.openSans(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Passenger: $passengerName'),
              // Dropdown or list for available vehicles
              DropdownButton<String>(
                hint: Text('Select Vehicle',style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),),
                items: <String>['Vehicle 1', 'Vehicle 2'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle vehicle selection
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel',style: GoogleFonts.openSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),),
            ),
            TextButton(
              onPressed: () {
                // Handle confirm action
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Assign',style: GoogleFonts.openSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),),
            ),
          ],
        );
      },
    );
  }
}

class RegularPassengerRequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          // Example list of vehicle requests from regular passengers
          // Replace with actual data and widget implementation
          RequestItem(
            requestId: '001',
            passengerName: 'John Doe',
            requestTime: '2024-09-19 14:00',
            isRegular: true, // Only show if passenger is regular
          ),
          RequestItem(
            requestId: '002',
            passengerName: 'Jane Smith',
            requestTime: '2024-09-19 14:30',
            isRegular: true, // Only show if passenger is regular
          ),
          // Add more RequestItem widgets here
        ],
      ),
    );
  }
}

