import 'package:flutter/material.dart';
import 'intro_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name = '';
  String _uniqueId = '';
  String _password = '';
  String _confirmPassword = '';
  String _registerState = '';
  String _helpMessage = '';

  void _handleRegister() {
    // Validate registration details
    if (_name.isEmpty ||
        _uniqueId.isEmpty ||
        _password.isEmpty ||
        _confirmPassword.isEmpty) {
      setState(() {
        _registerState = 'Failed';
        _helpMessage = 'Please fill in all fields';
      });
      return;
    }

    if (_password != _confirmPassword) {
      setState(() {
        _registerState = 'Failed';
        _helpMessage = 'Passwords do not match';
      });
      return;
    }

    if (_password.length < 8 ||
        !_password.contains(RegExp(r'[A-Z]')) ||
        !_password.contains(RegExp(r'[a-z]')) ||
        !_password.contains(RegExp(r'[0-9]')) ||
        !_password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _registerState = 'Failed';
        _helpMessage =
            'Password must be at least 8 characters long and contain uppercase letters, lowercase letters, numbers, and symbols';
      });
      return;
    }

    // Registration successful
    setState(() {
      _registerState = 'Succeeded';
      _helpMessage = 'Registration successful';
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_registerState == 'Failed' || _registerState == 'Succeeded')
              Text(
                _helpMessage,
                style: TextStyle(
                    color:
                        _registerState == 'Failed' ? Colors.red : Colors.green),
              ),
            const SizedBox(height: 20),
            const Text(
              'Profile Picture Selector',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => _name = value,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => _uniqueId = value,
              decoration: const InputDecoration(labelText: 'Unique ID'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => _password = value,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => _confirmPassword = value,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleRegister,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
