import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_page.dart';
import '../util/profile_manager.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name = '';
  String _email = '';
  int? _phonenumber = 0;
  String _password = '';
  String _confirmPassword = '';
  String _registerState = '';
  String _helpMessage = '';

  Future<String> _tryRegister(String url, String jsonEncodedData) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncodedData,
      );
    } catch (_) {
      return "Registration failed";
    }

    Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      String? rawCookie = response.headers[HttpHeaders.setCookieHeader];

      if (rawCookie != null) {
        Cookie cookie = Cookie.fromSetCookieValue(rawCookie);
        String cookieString = cookie.toString();

        Map<String, dynamic> profileData = {
          'user': responseData['data']['user'],
          'cookie': cookieString
        };

        try {
          await ProfileManager.saveProfile(jsonEncode(profileData));
        } catch (_) {
          return "Failed to save authentication token";
        }
      } else {
        return "Failed to retrieve authentication token";
      }
    }

    return responseData['message'];
  }

  void _handleRegister() {
    if (_name.isEmpty ||
        _email.isEmpty ||
        _phonenumber == 0 ||
        _password.isEmpty ||
        _confirmPassword.isEmpty) {
      setState(() {
        _registerState = 'Failed';
        _helpMessage = 'Please specify all the fields';
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

    String url = 'http://localhost:3000/api/auth/register';
    Map<String, dynamic> requestData = {
      "name": _name,
      "email": _email,
      "password": _password,
      "phonenumber": _phonenumber,
      "role": "65b5e135df72d28a3037ef3e",
    };
    String jsonEncodedData = json.encode(requestData);

    _tryRegister(url, jsonEncodedData).then(
      (message) => {
        if (message == "Registration successful")
          {
            setState(() {
              _registerState = 'Succeeded';
              _helpMessage = message;
            }),
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            ),
          }
        else
          {
            setState(() {
              _registerState = 'Failed';
              _helpMessage = message;
            }),
          }
      },
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
            if (_registerState.isNotEmpty)
              Text(
                _helpMessage,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
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
              onChanged: (value) => _email = value,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _phonenumber = int.tryParse(value);
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Phone number',
              ),
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
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
