import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Policy"),
        backgroundColor: Colors.blue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "This app respects your privacy and ensures data protection. All personal information is kept confidential.",
              ),
              Divider(height: 30),
              Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "By using this app, you agree to our terms of service, including timely payments and adherence to delivery policies.",
              ),
              Divider(height: 30),
              Text(
                "Refund & Cancellation Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Refunds are processed within 7 working days. Cancellations should be made 24 hours prior to the scheduled delivery.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
