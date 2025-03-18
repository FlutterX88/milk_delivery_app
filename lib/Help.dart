import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Need Help"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ask a Query",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                hintText: "Type your query here...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Submit"),
            ),
            const Divider(height: 30, thickness: 2),
            const Text("FAQs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text("How to subscribe to a milk plan?"),
                    subtitle: Text(
                        "Go to subscriptions and choose a plan that fits your needs."),
                  ),
                  ListTile(
                    title: Text("Can I pause my milk delivery?"),
                    subtitle: Text(
                        "Yes, go to your subscriptions and select 'Pause Delivery'."),
                  ),
                  ListTile(
                    title: Text("How do I contact support?"),
                    subtitle: Text(
                        "You can use this screen to ask queries or email us at support@example.com."),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
