import 'package:flutter/material.dart';

class Refer extends StatelessWidget {
  const Refer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refer & Earn"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Invite your friends and earn rewards!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Your Referral Code",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  const SelectableText(
                    "REF12345",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Share functionality
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("Share Code"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "How It Works",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.person_add, color: Colors.green),
              title: Text("Invite your friends using the referral code."),
            ),
            const ListTile(
              leading: Icon(Icons.card_giftcard, color: Colors.orange),
              title: Text("Your friend signs up and makes their first order."),
            ),
            const ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.blue),
              title: Text("You both earn rewards!"),
            ),
          ],
        ),
      ),
    );
  }
}
