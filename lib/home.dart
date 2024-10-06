import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/searchlocation.dart';

class HomePage extends StatefulWidget {
  final String cityName;
  HomePage({required this.cityName});

  @override
  State<HomePage> createState() => _HomePageState();
}

LatLng? _currentLocation;

class _HomePageState extends State<HomePage> {
  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal; // Default map type

  @override
  void initState() {
    super.initState();
    _getCoordinatesFromCityName();
  }

  Future<void> _getCoordinatesFromCityName() async {
    var query = '${widget.cityName}';
    final locations = await locationFromAddress(query);

    for (var location in locations) {
      setState(() {
        _currentLocation = LatLng(location.latitude, location.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentLocation = null;
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchlocationScreen()));
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 27,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Your Location',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 30,
            ),
            Positioned(
              top: 20,
              right: 15,
              child: DropdownButton<MapType>(
                value: _currentMapType,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "Normal",
                      style: TextStyle(color: Colors.black),
                    ),
                    value: MapType.normal,
                  ),
                  DropdownMenuItem(
                    child: Text("Satellite"),
                    value: MapType.satellite,
                  ),
                  DropdownMenuItem(
                    child: Text("Hybrid"),
                    value: MapType.hybrid,
                  ),
                  DropdownMenuItem(
                    child: Text("Terrain"),
                    value: MapType.terrain,
                  ),
                ],
                onChanged: (MapType? newMapType) {
                  setState(() {
                    _currentMapType = newMapType!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: _currentLocation != null
          ? Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: _markers,
                  mapType: _currentMapType, // Use the selected map type
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 10,
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          size: 30,
        ),
        onPressed: _getCurrentLocation,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    final position = await _requestPermissionAndGetLocation();
    if (position != null) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      });
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation!,
            zoom: 14,
          ),
        ),
      );
    }
  }

  Future<Position?> _requestPermissionAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}
