import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String count;

  const DashboardCard({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  count,
                  style: TextStyle(
                    color: AppColors.lightblueColor,
                    fontSize: 18.sp,

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
        child: Column(
          children: [
            DashboardCard(
              icon: Icons.person,
              iconBackgroundColor: Colors.orange,
              title: 'No. of Passengers',
              count: '30',
            ),
            DashboardCard(
              icon: Icons.motorcycle,
              iconBackgroundColor: Colors.purple,
              title: 'No. of Riders',
              count: '32',
            ),
            DashboardCard(
              icon: Icons.alt_route,
              iconBackgroundColor: Colors.pink,
              title: 'No. of regular passenger',
              count: '0',
            ),

          ],
        ),
      );

  }
}


