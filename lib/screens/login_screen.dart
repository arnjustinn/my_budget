import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  void _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = await _userService.loginUser(_username, _password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 8),
              ],
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                onSaved: (val) => _username = val?.trim() ?? '',
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Enter username' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (val) => _password = val ?? '',
                validator: (val) =>
                    (val == null || val.length < 6) ? 'Minimum 6 characters' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
