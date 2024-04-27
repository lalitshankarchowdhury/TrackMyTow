import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'request_location_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

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
                'assets/icons/TowTruck.svg',
                width: 125,
                height: 125,
                colorFilter: const ColorFilter.mode(
                    Color(0xFFFCB001), BlendMode.srcATop),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to TrackMyTow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                  'Conveniently add towed vehicles and set their impound location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  )),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestLocationPage()),
                  );
                },
                child: const Text('Get started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
