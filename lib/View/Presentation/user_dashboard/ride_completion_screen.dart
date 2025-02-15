import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kantipur_ride/Components/dt_button.dart';
import 'package:kantipur_ride/View/Presentation/payment/esewa_payment.dart';
import 'package:kantipur_ride/utils/dt_colors.dart';

class RideCompletionPage extends StatefulWidget {
  final String pickupAddress;
  final String dropOffAddress;
  final double fare;
  final String tripDuration;
  final String tripDistance;

  RideCompletionPage({
    required this.pickupAddress,
    required this.dropOffAddress,
    required this.fare,
    required this.tripDuration,
    required this.tripDistance,
  });

  @override
  _RideCompletionPageState createState() => _RideCompletionPageState();
}

class _RideCompletionPageState extends State<RideCompletionPage> {
  double _rating = 0.0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Summary
            Text("Trip Summary", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Text("Pickup: ${widget.pickupAddress}"),
            Text("Drop Off: ${widget.dropOffAddress}"),
            SizedBox(height: 10.h),
            Text("Trip Duration: ${widget.tripDuration}"),
            Text("Trip Distance: ${widget.tripDistance} km"),
            SizedBox(height: 10.h),
            Text("Fare: \$${widget.fare.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/esewa.jpeg',width: 100.w,),
                CustomButton(
                    text: 'Esewa Payment',
                    textColor: Colors.white,
                    borderRadius: 20.r,
                    bottonColor: AppColors.primaryColor,
                    width: 160.w,
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EsewaApp(title: 'Payment')));
                    }),
              ],
            ),

            // Driver Rating
            SizedBox(height: 20.h),
            Text("Rate Your Driver", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            _buildRatingStars(),
            SizedBox(height: 10.h),

            // Feedback Text Field
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: "Leave Feedback (Optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            Spacer(),

            // Confirm Button
            ElevatedButton(
              onPressed: _submitRatings,
              child: Text("Submit Rating & Feedback",style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),),
            )
          ],
        ),
      ),
    );
  }

  // Build rating stars widget
  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
          },
        );
      }),
    );
  }

  void _submitRatings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Thank you for your feedback!",
            style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

}
