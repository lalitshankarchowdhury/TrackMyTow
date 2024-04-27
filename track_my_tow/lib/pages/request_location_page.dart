import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_page.dart';

class RequestLocationPage extends StatelessWidget {
  const RequestLocationPage({super.key});

  Future<bool> _getCurrentLocationAccess() async {
    final permissionStatus = await Permission.location.request();
    return permissionStatus.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/Location.svg',
                width: 125,
                height: 125,
                colorFilter: const ColorFilter.mode(
                    Color(0xFFFCB001), BlendMode.srcATop),
              ),
              const SizedBox(height: 20),
              const Text(
                'Grant location permission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Allow fine location access to broadcast accurate coordinates while towing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (await _getCurrentLocationAccess()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }
                },
                child: const Text('Grant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
