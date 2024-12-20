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
  bool isBikeView = false;

  List<Map<String, String>> cars = [];
  List<Map<String, String>> bikes = [];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    String? name = await AuthServices().getUserName();
    setState(() {
      userName = name ?? "User";
    });
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

  void _showAddVehicleDialog(BuildContext context, bool isBike) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController regNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isBike ? 'Add Bike' : 'Add Car'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: isBike ? 'Bike Name' : 'Car Name'),
              ),
              TextField(
                controller: regNumberController,
                decoration: InputDecoration(labelText: 'Registration Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    regNumberController.text.isNotEmpty) {
                  setState(() {
                    if (isBike) {
                      bikes.add({
                        'name': nameController.text,
                        'regNumber': regNumberController.text,
                      });
                    } else {
                      cars.add({
                        'name': nameController.text,
                        'regNumber': regNumberController.text,
                      });
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeVehicle(bool isBike, int index) {
    setState(() {
      if (isBike) {
        bikes.removeAt(index);
      } else {
        cars.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF655AE4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                "Park Ease",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(
                    Icons.directions_car, "Car", Colors.blue, false),
                SizedBox(width: 20),
                _buildIconButton(Icons.motorcycle, "Bike", Colors.grey, true),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: isBikeView
                  ? [
                      ...bikes
                          .asMap()
                          .map((index, bike) {
                            return MapEntry(
                              index,
                              BikeItem(
                                bikeName: bike['name']!,
                                bikeNumber: bike['regNumber']!,
                                bikeImage: 'https://via.placeholder.com/150',
                                iconColor: Colors.orange,
                                onDelete: () => _removeVehicle(true, index),
                              ),
                            );
                          })
                          .values
                          .toList(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showAddVehicleDialog(context, true),
                        child: Text('Add Bike'),
                      ),
                    ]
                  : [
                      ...cars
                          .asMap()
                          .map((index, car) {
                            return MapEntry(
                              index,
                              CarItem(
                                carName: car['name']!,
                                carNumber: car['regNumber']!,
                                carImage: 'https://via.placeholder.com/150',
                                iconColor: Colors.purple,
                                onDelete: () => _removeVehicle(false, index),
                              ),
                            );
                          })
                          .values
                          .toList(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showAddVehicleDialog(context, false),
                        child: Text('Add Car'),
                      ),
                    ],
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

  Widget _buildIconButton(
      IconData icon, String label, Color color, bool bikeView) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
              size: 40,
            ),
            onPressed: () {
              setState(() {
                isBikeView = bikeView;
              });
            },
          ),
        ),
        Text(label),
      ],
    );
  }
}

class CarItem extends StatelessWidget {
  final String carName;
  final String carNumber;
  final String carImage;
  final Color iconColor;
  final VoidCallback onDelete;

  const CarItem({
    required this.carName,
    required this.carNumber,
    required this.carImage,
    required this.iconColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(Icons.directions_car, color: iconColor),
        ),
        title: Text(
          carName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(carNumber),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                carImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class BikeItem extends StatelessWidget {
  final String bikeName;
  final String bikeNumber;
  final String bikeImage;
  final Color iconColor;
  final VoidCallback onDelete;

  const BikeItem({
    required this.bikeName,
    required this.bikeNumber,
    required this.bikeImage,
    required this.iconColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(Icons.motorcycle, color: iconColor),
        ),
        title: Text(
          bikeName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(bikeNumber),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                bikeImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
