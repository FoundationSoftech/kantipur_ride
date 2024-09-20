import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/user_profile.dart';
import 'package:kantipur_ride/View/Presentation/user_dashboard/user_ride.dart';
import '../../../Components/map_example.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserDashboardScreen extends StatefulWidget {
  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String currentAddress = "Fetching current location...";


  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          currentAddress = "Location services are disabled.";
        });
        return;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            currentAddress = "Location permissions are denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          currentAddress = "Location permissions are permanently denied, we cannot request permissions.";
        });
        return;
      }

      // If permissions are granted, get the user's current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Get the address from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          currentAddress = "${place.name}, ${place.locality}, ${place.administrativeArea}";
        });
      } else {
        setState(() {
          currentAddress = "Could not fetch location";
        });
      }
    } catch (e) {
      setState(() {
        currentAddress = "Could not fetch location";
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kantipur Ride', style: TextStyle(color: Colors.red)),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfile()));
              },
                child: Icon(Icons.account_circle, color: Colors.grey)),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      currentAddress,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RideSharingScreen()));
                    },
                      child: ServiceOption(icon: Icons.motorcycle, label: 'Bike')),
                  ServiceOption(icon: Icons.directions_car, label: 'Car'),
                  ServiceOption(icon: Icons.fastfood, label: 'Food'),
                  ServiceOption(icon: Icons.local_shipping, label: 'Parcel'),
                  ServiceOption(icon: Icons.shopping_basket, label: 'Bazaar'),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapExample()),
                        );

                        if (selectedLocation != null) {
                          // Update the search field with the selected location
                          setState(() {
                            _searchController.text = selectedLocation;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Destination',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              OrderAgainSection(),
            ],
          ),
        ),
      ),

    );
  }
}


class ServiceOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 48, color: Colors.red),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class DestinationOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const DestinationOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

class OrderAgainSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Again', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        ListTile(
          leading: Image.asset('assets/f1.jpeg'),
          title: Text('The Choila House - Suke...'),
          subtitle: Text('Chicken Kothey Momo x5'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          leading: Image.asset('assets/f1.jpeg'),
          title: Text('The Choila House - Suke...'),
          subtitle: Text('Chicken Kothey Momo x5'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          leading: Image.asset('assets/f1.jpeg'),
          title: Text('The Choila House - Suke...'),
          subtitle: Text('Chicken Kothey Momo x5'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
