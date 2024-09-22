import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/Components/country_dropdown.dart';
import 'package:kantipur_ride/Components/dashboard_cards.dart';
import 'package:kantipur_ride/View/Presentation/Admin/drawer.dart';
import 'package:kantipur_ride/View/Presentation/Admin/passengers_list_screen.dart';
import 'package:kantipur_ride/View/Presentation/Admin/regular_passenger_vehicle.dart';
import '../../../Components/orders_bar_chart.dart';
import '../../../Components/overall_summary_chart.dart';
import '../../../Components/total_services_graph.dart';
import '../../../Components/transport_graph.dart';
import '../../../utils/dt_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardOverview extends StatelessWidget {
  const AdminDashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(), // Custom navigation drawer
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            expandedHeight: 60.h,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 170.w,
                    height: 120.h,
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    width: 3.w,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/menu.png',
                      height: 25.h,
                      width: 25.w,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Open drawer
                    },
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/profile.png',
                    height: 42.h,
                    width: 42.w,
                  ),
                  SizedBox(width: 10.w),
                  Image.asset(
                    'assets/drop.png',
                    color: Colors.white,
                    width: 6.w,
                    height: 16.h,
                  ),
                ],
              ),
              centerTitle: false,
              titlePadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Dashboard',
                    style: GoogleFonts.openSans(
                      fontSize: 13.sp,
                      color: AppColors.redColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Dashboard Overview',
                    style: GoogleFonts.openSans(
                      fontSize: 17.sp,
                      color: AppColors.blueColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      'Graph by country',
                      style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  CountryDropdown(),
                  SizedBox(height: 20.h),
                  Text("Regular Passenger Vehicle request:",style: GoogleFonts.openSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,

                  ),),
                  SizedBox(height: 10.h),
                  RegularPassengerRequestsList(),
                  SizedBox(height: 16.h),
                  DashboardCards(),
                  SizedBox(height: 16.h),
                  TransportGraph(),
                  SizedBox(height: 16.h),
                  TotalServicesChart(),
                  SizedBox(height: 16.h),
                  OrdersBarChart(),
                  SizedBox(height: 16.h),
                  SummaryChart(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
