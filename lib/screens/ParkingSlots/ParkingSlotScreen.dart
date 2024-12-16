import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import Razorpay package
import '../../Widget/Navbar.dart';
import '../../Services/routes.dart';
import '../PaymentScreen/paymentscreen.dart';

class ParkingSlotScreen extends StatefulWidget {
  const ParkingSlotScreen({super.key});

  @override
  _ParkingSlotScreenState createState() => _ParkingSlotScreenState();
}

class _ParkingSlotScreenState extends State<ParkingSlotScreen> {
  int _selectedIndex = 1; // Initially set to "Map" tab (index 1)
  late Razorpay _razorpay; // Declare Razorpay instance

  final List<List<String>> parkingSlots = [
    ["C01", "C02", "C03", "C04"],
    ["C05", "C06", "C07", "C08"],
    ["C09", "C10", "", ""],
  ];

  final Map<String, String> slotStatus = {
    "C07": "Selected",
    "C09": "Booked",
  };

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Set up event handlers
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Clean up Razorpay instance
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   // Handle payment success
  //   print('Payment successful: ${response.paymentId}');
  //   // Navigate to another screen or show success message
  // }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Log payment success
    print('Payment successful: ${response.paymentId}');

    // Find and update the selected slot to "Booked"
    setState(() {
      slotStatus.updateAll((slot, status) {
        if (status == "Selected") {
          return "Booked";
        }
        return status;
      });
    });

    // Optionally, show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment successful! Slot has been booked."),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment failed: ${response.message}');
    // Show failure message to the user
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print('External wallet selected: ${response.walletName}');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        // Already on Map/Slots screen
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.transactions);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  // Function to check if any slot is selected
  bool get isSlotSelected {
    return slotStatus.values.contains("Selected");
  }

  // Function to open the Razorpay payment gateway
  void _openRazorpay() {
    var options = {
      'key': 'rzp_test_inABBsOaHvbISw', // Use your Razorpay API key here
      'amount': 100, // Amount in paise (100 paise = 1 INR)
      'name': 'ParkEase Payment',
      'description': 'Parking Slot Booking',
      'prefill': {'contact': '9876543210', 'email': 'test@domain.com'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Flatten parkingSlots to a single list of strings
    final flatSlots = parkingSlots.expand((e) => e).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF655AE4), // Color #655ae4
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_parking, color: Colors.white, size: 30),
              SizedBox(width: 20),
              Text(
                "Pick Parking Slot",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "ENTRY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(16.0),
              itemCount: flatSlots.length,
              itemBuilder: (context, index) {
                String slot = flatSlots[index];
                String status = slotStatus[slot] ?? "Available";

                return slot.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            if (status == "Available") {
                              slotStatus[slot] = "Selected";
                            } else if (status == "Selected") {
                              slotStatus[slot] = "Available";
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: status == "Selected"
                                ? Colors.blue
                                : status == "Booked"
                                    ? Colors.yellow
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: status == "Available"
                                    ? Colors.black
                                    : Colors.white,
                                size: 30,
                              ),
                              SizedBox(height: 8),
                              Text(
                                slot,
                                style: TextStyle(
                                  color: status == "Available"
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Legend(color: Colors.blue, label: "Selected"),
                Legend(color: Colors.yellow, label: "Booked"),
                Legend(color: Colors.white, label: "Available"),
              ],
            ),
          ),
          // Payment button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isSlotSelected
                  ? () {
                      // Open Razorpay payment gateway
                      _openRazorpay();
                    }
                  : null, // Disable button if no slot is selected
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Proceed to Payment",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
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
}

class Legend extends StatelessWidget {
  final Color color;
  final String label;

  const Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey),
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
