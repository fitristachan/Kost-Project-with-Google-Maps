import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_mobpro/views/profile/myprofile.dart';
import 'package:flutter_mobpro/views/home/home.dart';

class MyLocationScreen extends StatefulWidget {
  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  late GoogleMapController _mapController; 
  LatLng? _currentPosition;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async{
    await _getCurrentLocation();
    super.didChangeDependencies();
  }

  final List<Widget> _screens = [
    HomeScreen(),
    MyProfileScreen(),
    MyLocationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    //print('ppp');
    permission = await Geolocator.requestPermission();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location Service Has Been Disabled');
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('You didnt granted location permission.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permission has been blocked permanently, we cant access the location.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    _currentPosition != null
          ? GoogleMap(
              onMapCreated: (controller) async{

                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('current_position'),
                  position: _currentPosition!,
                  infoWindow: InfoWindow(title: 'My Location'),
                ),
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            );
  }
}
