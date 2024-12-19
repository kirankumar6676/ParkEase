import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Widget/Navbar.dart';
import '../../Services/routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 1; // Initially set to the "Map" tab (index 1)
  late GoogleMapController _mapController;

  // Coordinates of the parking area
  final LatLng _parkingLocation = const LatLng(37.7749, -122.4194); // Replace with proper parking area coords

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
              zoom: 15, // Adjust the zoom level as needed
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId("parking_marker"),
                position: _parkingLocation,
                infoWindow: const InfoWindow(title: "Parking Area"),
              ),
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the parking slot screen
                Navigator.pushNamed(context, AppRoutes.parkingSlot);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
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
