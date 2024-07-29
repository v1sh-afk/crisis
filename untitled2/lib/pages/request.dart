
import 'package:flutter/material.dart';
import 'package:untitled2/pages/BoatAvailable.dart';
import 'package:untitled2/pages/CanAvailability.dart';
import 'package:untitled2/pages/Medical.dart';
import 'package:untitled2/pages/Food.dart';
import 'package:untitled2/pages/Charging.dart';


class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                RequestButton(
                  label: 'Boats',
                  icon: Icons.directions_boat,
                  height: 60,
                  width: 170,
                  onPressed: () {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => const BoatAskingPage()));
    }
                ),
                SizedBox(width: 20.0,),
                RequestButton(
                  label: 'Water Cans',
                  icon: Icons.local_drink,
                  height: 60,
                  width: 170,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const CanAskingPage()));
                    }
                ),
              ],
            ),
            SizedBox(height: 10.0,),

            Row(
              children: [
                RequestButton(
                  label: 'Medical Assistance',
                  icon: Icons.medical_services,
                  height: 60,
                  width: 170,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MedicalAssistance()));
                  },
                ),
                SizedBox(width: 20.0,),
                RequestButton(
                  label: 'Food & Groceries',
                  icon: Icons.food_bank,
                  height: 60,
                  width: 170,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const FoodProvider()));
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                RequestButton(
                  label: 'Charging Stations',
                  icon: Icons.battery_charging_full,
                  height: 60,
                  width: 170,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ChargingPoint()));
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
            Text(
              'Fundraisers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RequestButton(
              label: 'Donate',
              icon: Icons.attach_money,
              height: 60,
              width: double.infinity,
              onPressed: () {
                // Handle Donate button press
                _handleDonateRequest();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  void _handleAlertPress() {
    // Handle alert button press functionality
    print("Alert button pressed");
  }

  void _handleMedicalAssistanceRequest() {
    // Handle Medical Assistance button press functionality
    print("Medical Assistance button pressed");
  }

  void _handleFoodGroceriesRequest() {
    // Handle Food & Groceries button press functionality
    print("Food & Groceries button pressed");
  }

  void _handleChargingStationsRequest() {
    // Handle Charging Stations button press functionality
    print("Charging Stations button pressed");
  }

  void _handleWeatherAnnouncement() {
    // Handle Weather button press functionality
    print("Weather button pressed");
  }

  void _handleNoticesAnnouncement() {
    // Handle Notices button press functionality
    print("Notices button pressed");
  }

  void _handleDonateRequest() {
    // Handle Donate button press functionality
    print("Donate button pressed");
  }
}

class RequestButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final double height;
  final double width;
  final VoidCallback onPressed;

  const RequestButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.height,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label,style: TextStyle(fontSize: 14.0),),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
