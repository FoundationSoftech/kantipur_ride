import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/Components/expanded_bottom_nav_bar.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  @override
  void initState() {
    super.initState();
    _addListenerToController(_controller1, _focusNode2);
    _addListenerToController(_controller2, _focusNode3);
    _addListenerToController(_controller3, _focusNode4);
    _addListenerToController(_controller4, _focusNode5);
    _addListenerToController(_controller5, _focusNode6);
  }

  void _addListenerToController(TextEditingController controller, FocusNode nextFocusNode) {
    controller.addListener(() {
      if (controller.text.length == 1) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the code sent to +97798XXXXXXXX',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _otpTextField(_controller1, _focusNode1),
                _otpTextField(_controller2, _focusNode2),
                _otpTextField(_controller3, _focusNode3),
                _otpTextField(_controller4, _focusNode4),
                _otpTextField(_controller5, _focusNode5),
                _otpTextField(_controller6, _focusNode6),
              ],
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpandedBottomNavBar()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'SUBMIT',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Code sent. Resend code in 00:42',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpTextField(TextEditingController controller, FocusNode focusNode) {
    return SizedBox(
      width: 40.w,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
