import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home.dart';

class SearchlocationScreen extends StatefulWidget {
  const SearchlocationScreen({super.key});

  @override
  State<SearchlocationScreen> createState() => _SearchlocationScreenState();
}

LatLng? _currentLocation;

class _SearchlocationScreenState extends State<SearchlocationScreen> {
  final _cityController = TextEditingController();

  Set<Marker> _markers = {};

  var _city = '';

  @override
  void initState() {
    super.initState();
    _cityController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            'Enter Your Location',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: 300,
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 80),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.5), // Shadow color with transparency
                        spreadRadius: 5, // How much the shadow spreads
                        blurRadius: 7, // Blurring effect of the shadow
                        offset: Offset(0, 3), // Horizontal and vertical offset
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.greenAccent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.location_on),
                          border: InputBorder.none,
                          hintText: 'Enter location',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _requestPermissionAndGetLocation();
                        _getCurrentLocation();
                      },
                      child: Text('Use current location'),
                    ),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        if (_cityController.text.isNotEmpty) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      cityName: _cityController.text)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a location'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 47,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 8),
                            Text(
                              'Next',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 270,
                child: Text(
                  "Note: Kindly provide the correct location along with the accurate name for better processing!",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _getCurrentLocation() async {
    final position = await _requestPermissionAndGetLocation();
    if (position != null) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String? city = placemark.locality; // access the city name
        setState(() {
          _cityController.text = city!;
          _city = city;

          // assuming you have a variable _currentCity to store the city name
        });
      }
    }
  }

  Future<Position?> _requestPermissionAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permission is denied'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}
