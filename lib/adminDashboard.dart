import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> demoData = [];

  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _loadRegistrations();
    filteredData = List.from(demoData);
  }

  void _filterData(String query) {
    setState(() {
      filteredData = demoData.where((user) {
        return user['name'].toLowerCase().contains(query.toLowerCase()) ||
            user['phone'].contains(query);
      }).toList();
    });
  }

  Future<void> _loadRegistrations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('registrations');
    if (data != null) {
      setState(() {
        demoData = List<Map<String, dynamic>>.from(json.decode(data));
      });
    } else {
      demoData = [
        {
          'name': 'Amit Sharma',
          'phone': '9876543210',
          'address': 'Delhi',
          'quantity': 2,
          'basis': 'Regular'
        },
        {
          'name': 'Priya Verma',
          'phone': '9123456789',
          'address': 'Mumbai',
          'quantity': 3,
          'basis': 'Sometimes'
        },
        {
          'name': 'Rajesh Kumar',
          'phone': '9898989898',
          'address': 'Bangalore',
          'quantity': 5,
          'basis': 'Regular'
        },
      ];
    }
    filteredData = List.from(demoData);
  }

  double getTotalLitersPerDay() {
    return demoData.fold(0.0, (sum, user) => sum + int.parse(user['quantity']));
  }

  double getTotalLitersPerMonth() {
    return getTotalLitersPerDay() * 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _summaryBox(
                      'Customers', demoData.length.toString(), Colors.blue),
                  const SizedBox(
                    width: 5,
                  ),
                  _summaryBox('Daily (L)', getTotalLitersPerDay().toString(),
                      Colors.green),
                  const SizedBox(
                    width: 5,
                  ),
                  _summaryBox('Monthly (L)',
                      getTotalLitersPerMonth().toString(), Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search by Name or Phone",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _filterData,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.blue.shade100),
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Phone")),
                    DataColumn(label: Text("Address")),
                    DataColumn(label: Text("Quantity (L)")),
                    DataColumn(label: Text("Delivery Type")),
                    DataColumn(label: Text("Date")),
                  ],
                  rows: filteredData.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> user = entry.value;
                    return DataRow(
                      color: WidgetStateColor.resolveWith((states) =>
                          index % 2 == 0 ? Colors.grey.shade100 : Colors.white),
                      cells: [
                        DataCell(Text(user['name'])),
                        DataCell(Text(user['phone'].toString())),
                        DataCell(Text(user['address'])),
                        DataCell(Text(user['quantity'].toString())),
                        DataCell(Text(user['basis'])),
                        DataCell(Text(_formatToIST(user['timestamp']))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryBox(String title, String value, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

String _formatToIST(String isoString) {
  DateTime utcDateTime = DateTime.parse(isoString).toUtc();
  DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
  return DateFormat('dd-MM-yyyy hh:mm a').format(istDateTime);
}

void main() {
  runApp(const MaterialApp(
    home: AdminDashboard(),
  ));
}
