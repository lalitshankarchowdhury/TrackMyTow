import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../util/profile_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../login_page.dart';

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
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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

  Future<void> _logout(BuildContext context) async {
    Map<String, dynamic> requestData = {
      "profileId": jsonDecode(profile!)['user']['_id']
    };
    String jsonEncodedData = json.encode(requestData);
    String url = 'http://13.60.64.128:3000/api/auth/logout';
    try {
      String cookie = jsonDecode(profile!)['cookie'];
      String token = cookie.split('=')[1].split(';')[0];
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/Policeman.svg',
                  width: 150, height: 150),
              const SizedBox(height: 16),
              Container(
                width: 400,
                child: ProfileCard(
                  name: jsonDecode(profile!)['user']['name'],
                  email: jsonDecode(profile!)['user']['email'],
                  phoneNumber: jsonDecode(profile!)['user']['phonenumber'],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC4501),
                ),
                onPressed: () {
                  _logout(context);
                },
                label: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
