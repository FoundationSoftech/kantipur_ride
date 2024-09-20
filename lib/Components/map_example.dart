import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';

class MapExample extends StatefulWidget {
  const MapExample({super.key});

  @override
  State<MapExample> createState() => _MapExampleState();
}

class _MapExampleState extends State<MapExample> {

  LatLng mylatlong = LatLng(27.7172, 85.3240);

  String address = 'kathmandu';

  setMarker(LatLng value) async {
    mylatlong = value;

    List<Placemark> result = await placemarkFromCoordinates(value.latitude, value.longitude);
    if (result.isNotEmpty) {
      address = '${result[0].name}, ${result[0].locality} ${result[0].street} ${result[0].administrativeArea}';
    }

    setState(() {
      Fluttertoast.showToast(msg: address);
    });

    // Return the selected location to the previous screen
    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(target: mylatlong,zoom: 12),
        markers: {
            Marker(
              infoWindow: InfoWindow(title: address),
                markerId: MarkerId('1'),
              position: mylatlong,
              draggable: true,
              onDragEnd: (value){
                print(value);
                setMarker(value);

              }
            ),
        },
        onTap: (value){
            setMarker(value);
        },
      ),

    );
  }
}
