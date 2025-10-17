import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _logout(BuildContext context) async {
    // For now, we assume login session is managed by saving username in SharedPreferences.
    // You can add a session management logic accordingly.
    // Here, just navigate back to login screen.

    // If you have session clearing, do it here.

    // Navigate to LoginScreen replacing all previous routes.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "⚙️ Account Settings Screen\n(Login/Signup to be added)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
