import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  _SubscriptionsScreenState createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Map<String, dynamic>> subscriptions = [
    {"id": 1, "name": "Monthly Milk Plan", "price": 499, "status": "Active"},
    {
      "id": 2,
      "name": "Weekly Dairy Package",
      "price": 199,
      "status": "Expired"
    },
    {
      "id": 3,
      "name": "Organic Milk Delivery",
      "price": 599,
      "status": "Active"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscriptions"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subscriptions.length,
          itemBuilder: (context, index) {
            var subscription = subscriptions[index];
            bool isActive = subscription["status"] == "Active";
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.subscriptions,
                  color: isActive ? Colors.green : Colors.red,
                ),
                title: Text(subscription["name"]),
                subtitle: Text(
                    "₹${subscription["price"]} - ${subscription["status"]}"),
                trailing: isActive
                    ? ElevatedButton(
                        onPressed: () {
                          // Handle subscription details
                        },
                        child: const Text("Manage"),
                      )
                    : const Text(
                        "Expired",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
