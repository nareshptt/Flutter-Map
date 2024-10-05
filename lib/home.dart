import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

LatLng? _currentLocation;

class _HomePageState extends State<HomePage> {
  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = const LatLng(22.3072, 73.1812); // default location
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _currentLocation != null
          ? GoogleMap(
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 10,
              ),
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
