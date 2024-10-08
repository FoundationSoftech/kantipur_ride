import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kantipur_ride/View/Presentation/Rider/ride_in_progress_screen.dart';
import 'package:kantipur_ride/View/Presentation/Rider/rider_dashboard.dart';
import 'package:slider_button/slider_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class RiderMap extends StatefulWidget {
  @override
  State<RiderMap> createState() => _RiderMapState();
}

class _RiderMapState extends State<RiderMap> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isOnline ? Colors.green : Colors.grey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SliderButton(
              width: 250.w,
              action: () async {
                setState(() {
                  isOnline = !isOnline;
                });
                return false;
              },
              label: Text(
                isOnline ? "ONLINE" : "OFFLINE",
                style: TextStyle(
                  color: isOnline ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 16.sp,
              ),
              backgroundColor: isOnline ? Colors.green.shade200 : Colors.grey.shade400,
              buttonColor: isOnline ? Colors.white : Colors.red.shade300,
              highlightedColor: Colors.green.shade300,
            ),
            SizedBox(width: 30.w,),
            InkWell(
              onTap: (){
                Get.to(()=>RiderDashboard(),transition: Transition.upToDown);
              },
                child: Icon(Icons.person,size: 50.h,color: Colors.white,)),
          ],
        ),
      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(27.7172, 85.3240), // Kathmandu coordinates
              zoom: 12,
            ),
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {},
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3, // Height of the bottom sheet
            minChildSize: 0.2,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.motorcycle, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          "Quest Available",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PICKUP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "Public House Cafe And Restaurant, Siddhidas Marga, Ason, KTM",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "DESTINATION",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "Chabahil Plaza, Boudha Main Road, Chabahil Chowk, KTM",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    Divider(height: 20, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Estimated",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              "₨163.49",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Distance",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              "4.52 KM",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bonus",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              "₨40.22",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(()=>RideInProgressScreen(),transition: Transition.upToDown);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "ACCEPT RIDE REQUEST",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

