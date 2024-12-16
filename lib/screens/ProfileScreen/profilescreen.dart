import 'package:flutter/material.dart';
import '../../Widget/Navbar.dart';
import '../../Services/routes.dart'; // Import AppRoutes for named navigation

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Initially set to the "Profile" tab (index 3)

  // Handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation logic based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.map);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.transactions);
        break;
      case 3:
        // Already on Profile screen, no navigation needed
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120, // Adjusted height for the layout
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10), // Padding inside the box
          decoration: BoxDecoration(
            color: Color(0xFF655AE4), // Color #655ae4
            borderRadius:
                BorderRadius.circular(20), // 20px radius for smooth corners
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, color: Colors.white, size: 30),
              SizedBox(height: 5),
              Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: const Text("Profile Page Content"),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
