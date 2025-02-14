import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/recent_ride_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserRecentRides extends StatefulWidget {
  const UserRecentRides({super.key});

  @override
  State<UserRecentRides> createState() => _UserRecentRidesState();
}

class _UserRecentRidesState extends State<UserRecentRides> {

  final RecentRidesController controller = Get.put(RecentRidesController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Rides",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 10.h),
          if (controller.isLoading.value)
            Center(child: CircularProgressIndicator())
          else if (controller.recentRides.isEmpty)
            Center(
              child: Text(
                'No recent rides found',
                style: TextStyle(fontSize: 16.sp),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentRides.length,
              itemBuilder: (context, index) {
                final ride = controller.recentRides[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text("Ride to ${ride.destinationPlaceName}"),
                    subtitle: Text(
                        "₨${ride.fare.toStringAsFixed(0)} | ${ride.distance.toStringAsFixed(1)} KM | ${ride.duration} mins"
                    ),
                    trailing: Text(ride.status as String),
                  ),
                );
              },
            ),
        ],
      );
    });
  }
}
