import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:get/get.dart';
import 'package:kantipur_ride/View/Presentation/onboarding/user_login_screen.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/ride_history.dart';

import '../../../controller/shared_preferences.dart';
import '../../../utils/dt_colors.dart';
import '../user_profile/about_us.dart';

import '../user_profile/privacy_policy_screen.dart';
import '../user_profile/support_screen.dart';
import '../user_profile/terms_conditions.dart';


// class UserProfile extends StatefulWidget {
//   const UserProfile({super.key});
//
//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//   final preferences = Get.put(PrefrencesManager());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           'Profile',
//           style: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildProfileHeader(),
//             SizedBox(height: 20),
//             _buildMenuOption('Notifications', 'assets/bell.png', () {}),
//             _buildMenuOption('Ride History', 'assets/history.png', () {
//               Get.to(() => RideHistory(), transition: Transition.fade);
//             }),
//             _buildMenuOption('Settings', 'assets/settings.png', () {}),
//             _buildMenuOption('About Us', 'assets/about.png', () {
//               // Get.to(() => AboutUsScreen(), transition: Transition.fade);
//             }),
//             _buildMenuOption('Help & Support', 'assets/help.png', () {
//               // Get.to(() => HelpSupportScreen(), transition: Transition.fade);
//             }),
//             _buildLogoutButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [Colors.redAccent, Colors.deepOrange]),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: AssetImage('assets/user.png'),
//             radius: 40,
//           ),
//           SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('John Rai',
//                   style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//               Text('9800000000',
//                   style: GoogleFonts.openSans(fontSize: 16, color: Colors.white70)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuOption(String title, String iconPath, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: Offset(0, 3))],
//         ),
//         child: Row(
//           children: [
//             Image.asset(iconPath, height: 30),
//             SizedBox(width: 15),
//             Text(
//               title,
//               style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//             Spacer(),
//             Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogoutButton() {
//     return Center(
//       child: TextButton(
//         onPressed: () async {
//           await preferences.clearAuthToken();
//           await preferences.clearuserId();
//           Get.offAll(() => UserLoginScreen());
//         },
//         child: Text('Logout',
//             style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
//       ),
//     );
//   }
// }


class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final PrefrencesManager prefrencesManager = PrefrencesManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Profile",style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),),

          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            CircleAvatar(
              radius: 30.r,
            ),
            Text("Name",style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,

            ),),
            Text("9700000012",style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey,

            ),),
            SizedBox(height: 30.h,),
            Divider(),


            profileOptions(Icons.support, 'Support',(){
              Navigator.push(context, MaterialPageRoute(builder: (_) => SupportScreen()));
            }),
            profileOptions(Icons.note, 'Terms and Conditions',(){
              Navigator.push(context, MaterialPageRoute(builder: (_) => TermsAndConditionsScreen()));
            }),
            profileOptions(Icons.privacy_tip, 'Privacy Policy',(){
              Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()));
            }),
            profileOptions(Icons.details, 'About',(){
              Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
            }),

            profileOptions(Icons.logout, 'Sign Out',()async{
              await prefrencesManager.clearAuthToken();
              await prefrencesManager.clearuserId();

              Get.offAll(() => UserLoginScreen());
            }),
          ],
        ),
      ),

    );
  }

  Widget profileOptions(IconData icons,String option,VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icons),
          title: Text(option,style: GoogleFonts.roboto(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),),
          trailing:  Icon(Icons.arrow_forward_ios_rounded,),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}

