import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date and time formatting

class RideScheduleScreen extends StatefulWidget {
  @override
  _RideScheduleScreenState createState() => _RideScheduleScreenState();
}

class _RideScheduleScreenState extends State<RideScheduleScreen> {
  // Form controllers
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController additionalRequirementsController = TextEditingController();

  // Date and Time pickers
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Method to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
  }

  // Method to select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
        timeController.text = pickedTime.format(context);
      });
  }

  // Submit method for scheduling the ride
  void _scheduleRide() {
    String pickupLocation = pickupController.text;
    String dropLocation = dropController.text;
    String pickupTime = timeController.text;
    String date = dateController.text;
    String additionalRequirements = additionalRequirementsController.text;

    if (pickupLocation.isEmpty ||
        dropLocation.isEmpty ||
        pickupTime.isEmpty ||
        date.isEmpty) {
      // Show a snackbar if fields are missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // TODO: Implement API call or logic to schedule the ride

    // Show success message after scheduling the ride
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ride is scheduled')),
    );

    // Clear form after submission
    pickupController.clear();
    dropController.clear();
    timeController.clear();
    dateController.clear();
    additionalRequirementsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule a Ride'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: pickupController,
              decoration: InputDecoration(
                labelText: 'Pickup Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dropController,
              decoration: InputDecoration(
                labelText: 'Drop Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 10),
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Time',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 10),
            TextField(
              controller: additionalRequirementsController,
              decoration: InputDecoration(
                labelText: 'Additional Requirements',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleRide,
              child: Text('Schedule Ride'),
            ),
          ],
        ),
      ),
    );
  }
}
