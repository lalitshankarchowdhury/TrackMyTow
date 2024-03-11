import 'package:flutter/material.dart';
import 'register_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';
  String _loginState = '';

  void _handleLogin() {
    // Perform login authentication
    if (_username == 'admin' && _password == 'password') {
      setState(() {
        _loginState = 'Succeeded';
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      setState(() {
        _loginState = 'Failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_loginState == 'Failed')
              const Text(
                "Invalid credentials",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            if (_loginState == 'Succeeded')
              const Text(
                "Credentials valid",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Username',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            const Text("Not registered yet?"),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
