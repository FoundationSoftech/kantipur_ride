import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class RideScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Schedule System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RideScheduleForm(),
    );
  }
}

class RideScheduleForm extends StatefulWidget {
  @override
  _RideScheduleFormState createState() => _RideScheduleFormState();
}

class _RideScheduleFormState extends State<RideScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String pickupLocation = '';
  String dropLocation = '';
  String additionalRequirements = '';
  String? rideType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Controllers for form fields
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  TextEditingController additionalRequirementsController =
  TextEditingController();

  // For date format
  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Select Date';
  }

  // For time format
  String _formatTime(TimeOfDay? time) {
    return time != null ? time.format(context) : 'Select Time';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Display a snackbar on successful submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ride Scheduled Successfully')),
      );

      // You can add API integration here to send the scheduled ride details to the server
      // For example: sendRideSchedule(pickupLocation, dropLocation, selectedDate, selectedTime, additionalRequirements)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule a Ride'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: pickupController,
                  decoration: InputDecoration(labelText: 'Pickup Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pickup location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    pickupLocation = value!;
                  },
                ),
                TextFormField(
                  controller: dropController,
                  decoration: InputDecoration(labelText: 'Drop Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter drop location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    dropLocation = value!;
                  },
                ),
                SizedBox(height: 16),
                // Date Picker
                ListTile(
                  title: Text("Pickup Date: ${_formatDate(selectedDate)}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () {
                    // DatePicker.showDatePicker(
                    //   context,
                    //   showTitleActions: true,
                    //   onConfirm: (date) {
                    //     setState(() {
                    //       selectedDate = date;
                    //     });
                    //   },
                    //   currentTime: DateTime.now(),
                    //   locale: LocaleType.en,
                    // );
                  },
                ),
                // Time Picker
                ListTile(
                  title: Text("Pickup Time: ${_formatTime(selectedTime)}"),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                ),
                // Additional Requirements
                TextFormField(
                  controller: additionalRequirementsController,
                  decoration:
                  InputDecoration(labelText: 'Additional Requirements'),
                  onSaved: (value) {
                    additionalRequirements = value!;
                  },
                ),
                SizedBox(height: 16),
                // Ride Type (Day/Week/Month)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Ride Type'),
                  value: rideType,
                  items: ['Day', 'Week', 'Month']
                      .map((type) => DropdownMenuItem(
                    child: Text(type),
                    value: type,
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      rideType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a ride type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Schedule Ride'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
