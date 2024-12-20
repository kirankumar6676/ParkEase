import 'package:flutter/material.dart';
import '../../Widget/Navbar.dart';
import '../../Services/routes.dart'; // Import AppRoutes for named navigation

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _selectedIndex = 2; // Initially set to the "Transactions" tab (index 2)

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
        // Already on Transactions screen, no navigation needed
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  final List<Map<String, dynamic>> transactions = [
    {
      "location": "Temple",
      "name": "Temple Parking",
      "spots": "10 Car Spots",
      "distance": "3.3 km",
      "price": "1 ₹",
      "time": "per hr",
    },
    {
      "location": "Opal Tower",
      "name": "Home Parking",
      "spots": "15 Car Spots",
      "distance": "3.3 km",
      "price": "25 ₹",
      "time": "per hr",
    },
    {
      "location": "Marina Mall",
      "name": "Office Parking",
      "spots": "80 Car Spots",
      "distance": "22.3 km",
      "price": "50 ₹",
      "time": "per hr",
    },
    {
      "location": "Marina Mall",
      "name": "Security Parking",
      "spots": "1222 Car Spots",
      "distance": "1.3 km",
      "price": "60 ₹",
      "time": "for 3-4 hr",
    },
  ];

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, color: Colors.white, size: 30),
              SizedBox(width: 20), // Space between icon and text
              Text(
                "Previous Transactions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction["location"],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        transaction["name"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.local_parking,
                              color: Colors.green, size: 18),
                          SizedBox(width: 4),
                          Text(
                            transaction["spots"],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.navigation,
                              color: Colors.purple, size: 18),
                          SizedBox(width: 4),
                          Text(
                            transaction["distance"],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        transaction["price"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        transaction["time"],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
