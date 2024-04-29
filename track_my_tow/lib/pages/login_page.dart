import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'main_page.dart';
import 'register_page.dart';
import '../util/profile_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  String _loginState = '';
  String _helpMessage = '';

  Future<String> _login(String url, String jsonEncodedData) async {
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
      return "Login failed";
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

  void _handleLogin() {
    Map<String, dynamic> requestData = {"email": _email, "password": _password};
    String url = 'http://13.60.64.128:3000/api/auth/login';
    String jsonEncodedData = json.encode(requestData);

    _login(url, jsonEncodedData).then(
      (message) => {
        if (message == "Login successful")
          {
            setState(() {
              _loginState = 'Succeeded';
              _helpMessage = message;
            }),
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            )
          }
        else
          {
            setState(() {
              _loginState = 'Failed';
              _helpMessage = message;
            }),
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Login.svg',
              width: 150,
              height: 150,
              colorFilter:
                  const ColorFilter.mode(Color(0xFFFCB001), BlendMode.srcATop),
            ),
            if (_loginState == 'Failed')
              Text(
                _helpMessage,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
            if (_loginState == 'Succeeded')
              Text(
                _helpMessage,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
            if (_loginState == 'Succeeded' || _loginState == 'Failed')
              const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Continue'),
            ),
            const SizedBox(height: 32),
            const Text("Not registered yet?"),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                "Register",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
