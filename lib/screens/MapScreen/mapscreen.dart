// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../Widget/Navbar.dart';
// import '../../Services/routes.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   int _selectedIndex = 1; // Initially set to the "Map" tab (index 1)
//   late GoogleMapController _mapController;
//
//   // Coordinates of the parking area
//   final LatLng _parkingLocation = const LatLng(13.1217, 79.8975);
//
// // Replace with proper parking area coords
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, AppRoutes.home);
//         break;
//       case 1:
//         Navigator.pushNamed(context, AppRoutes.map);
//         break;
//       case 2:
//         Navigator.pushNamed(context, AppRoutes.transactions);
//         break;
//       case 3:
//         Navigator.pushNamed(context, AppRoutes.profile);
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text("Map Screen"),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _parkingLocation,
//               zoom: 15, // Adjust the zoom level as needed
//             ),
//             onMapCreated: (GoogleMapController controller) {
//               _mapController = controller;
//             },
//             markers: {
//               Marker(
//                 markerId: const MarkerId("parking_marker"),
//                 position: _parkingLocation,
//                 infoWindow: const InfoWindow(title: "Parking Area"),
//               ),
//             },
//           ),
//           Positioned(
//             bottom: 50,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Navigate to the parking slot screen
//                 Navigator.pushNamed(context, AppRoutes.parkingSlot);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue, // Button color
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 32, vertical: 12), // Padding
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8), // Rounded corners
//                 ),
//               ),
//               child: const Text(
//                 "Go to Parking Slots",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: NavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _mapController.dispose();
//     super.dispose();
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import '../../Widget/Navbar.dart';
// import '../../Services/routes.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   int _selectedIndex = 1;
//   late GoogleMapController _mapController;
//   LatLng _currentLocation = const LatLng(0, 0);
//   final LatLng _parkingLocation = const LatLng(13.1217, 79.8975);
//   Set<Polyline> _polylines = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _fetchRoute();
//   }
//
//   // Get the current location
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//       });
//     } catch (e) {
//       print("Error getting current location: $e");
//     }
//   }
//
//   // Fetch route data from Directions API
//   Future<void> _fetchRoute() async {
//     final apiKey = "AIzaSyBw3LhGHKCbFLDmZ6nRUBig9HmGZA2rmQw";
//     final url =
//         "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=${_parkingLocation.latitude},${_parkingLocation.longitude}&key=$apiKey";
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final points = data['routes'][0]['overview_polyline']['points'];
//         _addPolyline(points);
//       } else {
//         print("Error fetching route: ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching route: $e");
//     }
//   }
//
//   // Decode polyline and add to the map
//   void _addPolyline(String encodedPolyline) {
//     List<LatLng> points = _decodePolyline(encodedPolyline);
//     setState(() {
//       _polylines.add(Polyline(
//         polylineId: const PolylineId("route"),
//         points: points,
//         color: Colors.blue,
//         width: 5,
//       ));
//     });
//   }
//
//   // Decode the polyline string
//   List<LatLng> _decodePolyline(String encoded) {
//     List<LatLng> points = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;
//
//     while (index < len) {
//       int shift = 0, result = 0;
//       int byte;
//       do {
//         byte = encoded.codeUnitAt(index++) - 63;
//         result |= (byte & 0x1f) << shift;
//         shift += 5;
//       } while (byte >= 0x20);
//       int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lat += dlat;
//
//       shift = 0;
//       result = 0;
//       do {
//         byte = encoded.codeUnitAt(index++) - 63;
//         result |= (byte & 0x1f) << shift;
//         shift += 5;
//       } while (byte >= 0x20);
//       int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lng += dlng;
//
//       points.add(LatLng(lat / 1E5, lng / 1E5));
//     }
//
//     return points;
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, AppRoutes.home);
//         break;
//       case 1:
//         Navigator.pushNamed(context, AppRoutes.map);
//         break;
//       case 2:
//         Navigator.pushNamed(context, AppRoutes.transactions);
//         break;
//       case 3:
//         Navigator.pushNamed(context, AppRoutes.profile);
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text("Map Screen"),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _parkingLocation,
//               zoom: 15,
//             ),
//             onMapCreated: (GoogleMapController controller) {
//               _mapController = controller;
//             },
//             markers: {
//               Marker(
//                 markerId: const MarkerId("current_location"),
//                 position: _currentLocation,
//                 infoWindow: const InfoWindow(title: "Your Location"),
//               ),
//               Marker(
//                 markerId: const MarkerId("parking_location"),
//                 position: _parkingLocation,
//                 infoWindow: const InfoWindow(title: "Parking Area"),
//               ),
//             },
//             polylines: _polylines,
//           ),
//           Positioned(
//             bottom: 50,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, AppRoutes.parkingSlot);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 "Go to Parking Slots",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: NavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _mapController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Navbar.dart';
import '../../Services/routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 1;
  late GoogleMapController _mapController;
  LatLng _currentLocation = const LatLng(0, 0);
  final LatLng _parkingLocation = const LatLng(13.1217, 79.8975);
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get the current location
  Future<void> _getCurrentLocation() async {
    try {
      // Requesting location permission
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _fetchRoute(); // Fetch route after location is received
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  // Fetch route data from Directions API
  Future<void> _fetchRoute() async {
    if (_currentLocation.latitude == 0 && _currentLocation.longitude == 0) {
      print("Current location not found");
      return;
    }

    final apiKey =
        "AIzaSyBw3LhGHKCbFLDmZ6nRUBig9HmGZA2rmQw"; // Replace with your Google Maps API key
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=${_parkingLocation.latitude},${_parkingLocation.longitude}&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final points = data['routes'][0]['overview_polyline']['points'];
        _addPolyline(points);
      } else {
        print("Error fetching route: ${response.body}");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  // Decode polyline and add to the map
  void _addPolyline(String encodedPolyline) {
    List<LatLng> points = _decodePolyline(encodedPolyline);
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId("route"),
        points: points,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  // Decode the polyline string
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.map);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.transactions);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Map Screen"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _parkingLocation,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId("current_location"),
                position: _currentLocation,
                infoWindow: const InfoWindow(title: "Your Location"),
              ),
              Marker(
                markerId: const MarkerId("parking_location"),
                position: _parkingLocation,
                infoWindow: const InfoWindow(title: "Parking Area"),
              ),
            },
            polylines: _polylines,
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.parkingSlot);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Go to Parking Slots",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
