import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80.h),
        child: AppBar(
          automaticallyImplyLeading: true,

          backgroundColor: Colors.blue,
          flexibleSpace: Padding(padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 40.h),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Restaurant List',
                  style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),),

              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child:TextField(
                    decoration: InputDecoration(
                      hintText: 'search restaurant',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.sort),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),

                    )
                )
            ),
            restaurantCard('assets/r1.jpg', 'PEPE PIZZA', 'Kalanki,Kathmandu',"https://foodmandu.com/Restaurant/Details/2071",context),
            restaurantCard('assets/r2.jpg', 'Daura Thakali', 'Kathmandu,Lalitpur',"https://daurathakali.com/",context),
            restaurantCard('assets/r3.png', 'The Gardens', 'Panipokhari,Kathmandu',"https://noshnepal.com/restaurant/395",context),
            restaurantCard('assets/r4.jpg', 'The Chimney Restaurant', 'Maharajgunj,Kathmandu',"https://www.yakandyeti.com/culinary-delights/the-chimney-fine-dining",context),


          ],
        ),
      ),
    );
  }
  Widget restaurantCard(String hospitalImage,String hospitalName,String location, String websiteUrl,BuildContext context){
    return Padding(

      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          final Uri url = Uri.parse(websiteUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open the website')),
            );
          }
        },
        child: Card(
          child: Column(
            children: [
              Image.asset(
                hospitalImage,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:20.w),
                  child: Text(hospitalName,style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,

                  ),),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child:  Padding(
                  padding: EdgeInsets.symmetric(horizontal:20.w),
                  child: Text(location,style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: Colors.grey,
                  ),),
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
