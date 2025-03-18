import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adminDashboard.dart';

class PreRegistrationScreen extends StatelessWidget {
  const PreRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      // appBar: AppBar(
      //   title: const Text('Family Milk Dairy'),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade500,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()));
        },
        label: const Text(
          'Admin',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
      ),

      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 20,
            child:
                Icon(Icons.wb_sunny, size: 60, color: Colors.yellow.shade700),
          ),
          const Positioned(
            top: 90,
            right: 40,
            child: Icon(Icons.cloud, size: 70, color: Colors.white70),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Powered by ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800),
                      ),
                      TextSpan(
                        text: "Family Milk Dairy",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: Icon(FontAwesomeIcons.cow,
                        size: 65, color: Colors.blueAccent.shade700),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "We are coming soon with ",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        TextSpan(
                          text: "fresh milk ",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900),
                        ),
                        const TextSpan(
                          text: "delivery at your doorstep!",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Are you ready? ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey.shade700),
                        ),
                        TextSpan(
                          text: "Register Now",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                context: context,
                                builder: (context) => const RegistrationPopup(),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationPopup extends StatefulWidget {
  const RegistrationPopup({super.key});

  @override
  _RegistrationPopupState createState() => _RegistrationPopupState();
}

class _RegistrationPopupState extends State<RegistrationPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? selectedDeliveryBasis;

  List<Map<String, dynamic>> registrations = [];

  @override
  void initState() {
    super.initState();
    _loadRegistrations();
  }

  Future<void> _loadRegistrations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString('registrations');

    if (data != null) {
      setState(() {
        registrations = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveRegistrations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('registrations', json.encode(registrations));
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String phone = _phoneController.text;

      // Check if phone number already exists
      bool exists = registrations.any((reg) => reg['phone'] == phone);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Phone number already registered!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
        return;
      }

      Map<String, dynamic> newRegistration = {
        'name': _nameController.text,
        'phone': phone,
        'address': _addressController.text,
        'quantity': _quantityController.text,
        'basis': selectedDeliveryBasis,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // // Save to Firebase
      // await FirebaseFirestore.instance
      //     .collection('preRegistrations')
      //     .add(newRegistration);

      // // Save to SharedPreferences
      registrations.add(newRegistration);
      await _saveRegistrations();

      setState(() {});

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Family Milk Dairy",
              style: TextStyle(
                  color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
          content: Text(
              "Registration successful! Thank you for your registration. We will notify you when our services are available in your area.",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pop(context);
              },
              child: Text("OK", style: TextStyle(color: Colors.blue.shade700)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Pre-Register Now",
          style: TextStyle(
              color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
              validator: (value) => value!.isEmpty ? "Enter your name" : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                  labelText: "Contact Number", counterText: ""),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your contact number";
                } else if (value.length < 10) {
                  return "Contact number 10 digits required";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Address"),
              validator: (value) =>
                  value!.isEmpty ? "Enter your address" : null,
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                  labelText: "Quantity (liters)", counterText: ""),
              keyboardType: TextInputType.number,
              maxLength: 3,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter required quantity";
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              items: ["Regular", "Sometimes"].map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) =>
                  setState(() => selectedDeliveryBasis = newValue),
              decoration: const InputDecoration(labelText: "Delivery Basis"),
              validator: (value) =>
                  value == null ? "Select delivery basis" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.red.shade700)),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text("Submit", style: TextStyle(color: Colors.blue.shade700)),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PreRegistrationScreen()));
}
