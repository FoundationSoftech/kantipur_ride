import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class PlacesScreen extends StatefulWidget {
  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String currentAddress = "Fetching current location...";
  List<Map<String, String>> nearbyRestaurants = [];

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
          _fetchNearbyRestaurants(position.latitude, position.longitude).then((restaurants) {
            setState(() {
              nearbyRestaurants = restaurants;
            });
          });
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

  Future<List<Map<String, String>>> _fetchNearbyRestaurants(double latitude, double longitude) async {
    final String apiKey = 'AIzaSyD7hi_cOIPnZHqUShJ6bJNJyqWjGpOawBs';

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1000&type=restaurant&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> restaurantDetails = [];
      print(response.body);


      for (var result in data['results']) {
        restaurantDetails.add({
          'name': result['name'],
          'imageUrl': result['icon'], // Use the icon as a placeholder image
        });
      }

      return restaurantDetails;
    } else {
      throw Exception('Failed to load nearby restaurants');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
            Text('Nearby Restaurants', style: TextStyle(color: Colors.red)),
            Icon(Icons.account_circle, color: Colors.grey),
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentAddress,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildRestaurantList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Offers'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
        ],
      ),
    );
  }

  Widget _buildRestaurantList() {
    if (nearbyRestaurants.isEmpty) {
      return Text('No restaurants found within 1000 meters.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nearbyRestaurants.map((restaurant) {
        return ListTile(
          leading: Image.network(restaurant['imageUrl']!), // Display the restaurant's icon or other image
          title: Text(restaurant['name']!),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      }).toList(),
    );
  }
}
