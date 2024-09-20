import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              children: [
                Text(
                  'KANTIPUR RIDE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                  ),
                ),
                Flexible(child: Image.asset('assets/logo.png')),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            child: Text("ADMIN DASHBOARD",style: GoogleFonts.openSans(
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,

            ),),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.red),
            title: Text(
              'DashBoard',
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.local_shipping),
            title: Text('Dispatcher Panel', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),
              ),
          ),
          ExpansionTile(
            leading: Icon(Icons.support),
            title: Text(
              'Dispute Panel',
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            children: <Widget>[
              ListTile(
                title: Text('Submenu 1', style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),),
              ),
              ListTile(
                title: Text('Submenu 2', style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Heat Map', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text("God's View", style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('MEMBERS', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('ACCOUNTS', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),

          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('DETAILS', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('DETAILS', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Ratings and Reviews', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('OFFER', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),

          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('General', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('RIDES', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('DELIVERY', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 16.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('XUBER', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('STORE', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('SETTINGS', style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Roles', style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('Providers',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Fleet Owner',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Dispatcher Manager',style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: Colors.white,
            ),),
          ),
        ],
      ),
    );
  }
}
