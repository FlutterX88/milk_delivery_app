import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your expense app',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home'); // Navigate to Home
      }
    } catch (e) {
      print("Authentication error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate(); // Auto-trigger biometric prompt on launch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Colors.blueGrey),
            const SizedBox(height: 20),
            const Text(
              "Secure Login",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Use your fingerprint to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Authenticate"),
            ),
          ],
        ),
      ),
    );
  }
}
