import 'package:flutter/material.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text("John Doe"),
              subtitle: Text("john.doe@example.com"),
              trailing: Icon(Icons.edit, color: Colors.blue),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.location_on, color: Colors.blue),
              title: Text("Delivery Address"),
              subtitle: Text("123, Main Street, City"),
              trailing: Icon(Icons.edit, color: Colors.blue),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.payment, color: Colors.blue),
              title: Text("Payment Methods"),
              subtitle: Text("UPI, Card, Wallet"),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.history, color: Colors.blue),
              title: Text("Order History"),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.lock, color: Colors.blue),
              title: Text("Change Password"),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child:
                    const Text("Logout", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
