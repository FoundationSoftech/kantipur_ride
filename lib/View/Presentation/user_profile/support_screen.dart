import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/dt_colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isExpanded = false;

  //List of question-answer pairs
  final List<Map<String,String>> faqs=[
    {
      'question':'Why do I need to register my mobile number?',
      'answer':'Your mobile number is a key that users search to \nsend you their location'
    },
    {
      'question':'How do I share my location?',
      'answer':'Your mobile number is a key that users search to \nsend you their location'
    },
    {
      'question':'How do I get my business registered',
      'answer':'Your mobile number is a key that users search to \nsend you their location'
    },
    {
      'question':'Can others see my business?',
      'answer':'Your mobile number is a key that users search to \nsend you their location'
    },
    {
      'question':'Why do I need to register my mobile number?',
      'answer':'Your mobile number is a key that users search to \nsend you their location'
    }
  ];

  //Track the expanded state of each faqs
  final List<bool> isExpandedList = List.filled(10, false);

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Support",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10), // Add spacing between items
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpandedList[index] = !isExpandedList[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Row(
                          children: [
                            Text(
                              'Q.',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                color: Colors.blue, // Replace with AppColors.primaryColor
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                faqs[index]['question']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              isExpandedList[index]
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isExpandedList[index])
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Text(
                          faqs[index]['answer']!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
