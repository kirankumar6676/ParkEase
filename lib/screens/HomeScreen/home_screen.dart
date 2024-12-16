import 'package:flutter/material.dart';
import '../../Services/authentication.dart';
import '../../Services/routes.dart';
import '../../Widget/Navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? userName;

  @override
  void initState() {
    super.initState();
    // Fetch the user's name after screen is initialized
    _fetchUserName();
  }

  // Method to fetch user name from Firestore
  void _fetchUserName() async {
    String? name = await AuthServices().getUserName();
    setState(() {
      userName = name ?? "User"; // Default to "User" if name is not found
    });
  }

  // Method to handle bottom nav item tap
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
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
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10), // Padding inside the box
          decoration: BoxDecoration(
            color: Color(0xFF655AE4), // Color #655ae4
            borderRadius:
                BorderRadius.circular(20), // 20px radius for smooth corners
          ),
          child: Column(
            children: [
              // "Park Ease" text at the top
              Text(
                "Park Ease",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              // Space between "Park Ease" and "Hi, [userName]!"
              // "Hi, [userName]!" text at the bottom
              Text(
                "Hi, $userName!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Add the Row with IconButtons for Car, Bike, and Truck below the AppBar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Car Icon Button with white rectangular background
                _buildIconButton(Icons.directions_car, "Car", Colors.blue),
                SizedBox(width: 20),
                // Bike Icon Button with white rectangular background
                _buildIconButton(Icons.motorcycle, "Bike", Colors.grey),
                SizedBox(width: 20),
                // Truck Icon Button with white rectangular background
                _buildIconButton(Icons.local_shipping, "Truck", Colors.blue),
              ],
            ),
          ),
          // Add other widgets like _widgetOptions based on _selectedIndex
          // Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
        ],
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Helper method to build icon buttons with white rectangular background
  Widget _buildIconButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12), // Padding inside the container
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
              size: 40,
            ),
            onPressed: () {
              // Add your onPressed action here
            },
          ),
        ),
        Text(label),
      ],
    );
  }
}
