import 'package:flutter/material.dart';
import '../../util/profile_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login_page.dart';
import '../../util/profile_manager.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final int phoneNumber;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$phoneNumber',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  Future<void> _logout() async {
    Map<String, dynamic> requestData = {
      "profileId": jsonDecode(profile!)['user']['_id']
    };
    String jsonEncodedData = json.encode(requestData);
    String url = 'http://13.60.64.128:3000/api/auth/logout';
    try {
      String cookie = jsonDecode(profile!)['cookie'];
      String token = cookie.split('=')[1].split(';')[0];
      print(token);
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncodedData,
      );

      if (response.statusCode == 200) {
        await ProfileManager.deleteProfile();
        profile = "";
        print("Logout");
      } else {
        throw 'Logout failed';
      }
    } catch (error) {
      throw 'Logout failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileCard(
                name: jsonDecode(profile!)['user']['name'],
                email: jsonDecode(profile!)['user']['email'],
                phoneNumber: jsonDecode(profile!)['user']['phonenumber'],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC4501),
                ),
                onPressed: () {
                  _logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                label: const Text('End session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
