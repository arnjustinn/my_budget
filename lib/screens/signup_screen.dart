import 'package:flutter/material.dart';
import '../services/user_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _errorMessage;

  void _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    if (_password != _confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = await _userService.registerUser(_username, _password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Registration success — navigate back to login screen
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please login.')),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Username already exists.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onSaved: (val) => _confirmPassword = val ?? '',
                validator: (val) =>
                    (val == null || val.length < 6) ? 'Minimum 6 characters' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Create Account'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
