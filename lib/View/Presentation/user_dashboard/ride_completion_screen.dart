import 'package:flutter/material.dart';

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
            Text("Trip Summary", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Pickup: ${widget.pickupAddress}"),
            Text("Drop Off: ${widget.dropOffAddress}"),
            SizedBox(height: 10),
            Text("Trip Duration: ${widget.tripDuration}"),
            Text("Trip Distance: ${widget.tripDistance} km"),
            SizedBox(height: 10),
            Text("Fare: \$${widget.fare.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // Driver Rating
            SizedBox(height: 20),
            Text("Rate Your Driver", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildRatingStars(),
            SizedBox(height: 10),

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
              onPressed: () {
                // Handle submitting rating and feedback
              },
              child: Text("Submit Rating & Feedback"),
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
}
