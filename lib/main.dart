import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import 'PolicyScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PolicyScreen(),
  ));
}

Future<void> requestPermissions() async {
  var status = await Permission.location.request();
  var status1 = await Permission.ignoreBatteryOptimizations.request();
  if (status.isGranted && status1.isGranted) {
  } else {}
}

class LocationTrackingApp extends StatefulWidget {
  const LocationTrackingApp({super.key});

  @override
  _LocationTrackingAppState createState() => _LocationTrackingAppState();
}

class _LocationTrackingAppState extends State<LocationTrackingApp> {
  final channel = IOWebSocketChannel.connect('ws://192.168.137.175:3000');

  final channelreceive = IOWebSocketChannel.connect('ws://192.168.137.175:3000')
      .stream
      .asBroadcastStream();

  StreamSubscription? _subscription;
  bool isChildMode = false;
  List<Map<String, double>> locationRecords = [];
  LatLng? currentLocation; // Holds the latest location

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.location.request();
    var status1 = await Permission.ignoreBatteryOptimizations.request();
    if (status.isGranted && status1.isGranted) {
      loadSavedLocations();
    } else {
      showPermissionDeniedDialog();
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Denied"),
        content:
            const Text("Location permission is required to track location."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void toggleMode() async {
    if (!await Permission.location.isGranted) {
      requestPermissions();
      return;
    }

    setState(() {
      isChildMode = !isChildMode;
    });
    if (isChildMode) {
      startSendingLocation();
    } else {
      startReceivingLocation();
    }
  }

  void startSendingLocation() async {
    _subscription?.cancel(); // Cancel previous listener if exists
    while (isChildMode) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      Map<String, double> locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
      channel.sink.add(jsonEncode({'type': 'location', ...locationData}));
      saveLocation(locationData);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void startReceivingLocation() {
    _subscription?.cancel(); // Cancel previous listener if exists

    _subscription = channelreceive.listen((message) {
      // ✅ No need for `.stream`
      var data = jsonDecode(message);
      if (data['type'] == 'update') {
        Map<String, double> locationData = {
          'latitude': data['location']['latitude'],
          'longitude': data['location']['longitude'],
        };
        setState(() {
          locationRecords.insert(0, locationData);
          currentLocation = LatLng(
              data['location']['latitude'], data['location']['longitude']);
        });
        saveLocation(locationData);
      }
    });
  }

  Future<void> saveLocation(Map<String, double> location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedLocations = prefs.getStringList('locations') ?? [];
    savedLocations.insert(0, jsonEncode(location));
    await prefs.setStringList('locations', savedLocations);
  }

  Future<void> loadSavedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList('locations');
    if (savedLocations != null && savedLocations.isNotEmpty) {
      setState(() {
        locationRecords = savedLocations
            .map((loc) => Map<String, double>.from(jsonDecode(loc)))
            .toList();
        currentLocation = LatLng(locationRecords.first['latitude']!,
            locationRecords.first['longitude']!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize =
        MediaQuery.of(context).size; // Required for `nonRotatedSize`

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(isChildMode ? 'Child Mode' : 'Parent Mode')),
        body: Column(
          children: [
            // Display OpenStreetMap
            Expanded(
              child: currentLocation == null
                  ? const Center(child: Text("No Location Data"))
                  : FlutterMap(
                      mapController: MapController(), // Added controller
                      options: MapOptions(
                        initialCenter: currentLocation!,
                        initialZoom: 15.0,
                        initialRotation: 0.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png", // ✅ No subdomains
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: currentLocation!,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),

            FloatingActionButton(
              onPressed: toggleMode,
              child: Icon(isChildMode ? Icons.stop : Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
