import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../../util/profile_manager.dart';

class TowTruck {
  final String vehicleNumber;
  final String driverId;

  TowTruck({required this.vehicleNumber, required this.driverId});
}

class Vehicle {
  final String vehicleNumber;
  final String impoundLocation;

  Vehicle({required this.vehicleNumber, required this.impoundLocation});
}

class InitialPage extends StatelessWidget {
  final VoidCallback onNewTowSession;

  const InitialPage({super.key, required this.onNewTowSession});

  @override
  Widget build(BuildContext context) {
    String userName = jsonDecode(profile!)['user']['name'].split(' ')[0];
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $userName!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onNewTowSession,
              icon: const Icon(Icons.add),
              label: const Text('New session'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Start a new tow session to add vehicles and set their impound location',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TowTruckPage extends StatefulWidget {
  const TowTruckPage({super.key});

  @override
  createState() => _TowTruckPageState();
}

class _TowTruckPageState extends State<TowTruckPage> {
  List<TowTruck> towTrucks = [];
  List<Vehicle> vehicles = [];
  bool showFAB = false;

  Future<String> _startTowSession(String url, String jsonEncodedData) async {
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
      return "Tow session creation failed";
    }

    Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {}

    return responseData['message'];
  }

  void _showTowTruckDialog() {
    String vehicleNumber = '';
    String driverId = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter tow truck details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  onChanged: (value) => vehicleNumber = value,
                  decoration:
                      const InputDecoration(labelText: 'Vehicle number'),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => driverId = value,
                  decoration: const InputDecoration(labelText: 'Driver ID'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (vehicleNumber.isNotEmpty && driverId.isNotEmpty) {
                  setState(() {
                    towTrucks.add(TowTruck(
                      vehicleNumber: vehicleNumber,
                      driverId: driverId,
                    ));
                    showFAB = true;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showVehicleDialog() {
    String vehicleNumber = '';
    String impoundLocation = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter vehicle details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  onChanged: (value) => vehicleNumber = value,
                  decoration:
                      const InputDecoration(labelText: 'Vehicle number'),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => impoundLocation = value,
                  decoration:
                      const InputDecoration(labelText: 'Impound location'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (vehicleNumber.isNotEmpty && impoundLocation.isNotEmpty) {
                  setState(() {
                    _getCurrentLocation().then((value) => null);
                    vehicles.add(Vehicle(
                      vehicleNumber: vehicleNumber,
                      impoundLocation: impoundLocation,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    final permissionStatus = await Permission.locationWhenInUse.request();
    if (permissionStatus.isGranted) {
      Geolocator.getCurrentPosition()
          .then((position) => print('Current location: $position'));
    } else {
      print('Location permission denied.');
    }
  }

  void _showEditVehicleDialog(Vehicle vehicle) {
    String editedVehicleNumber = vehicle.vehicleNumber;
    String editedImpoundLocation = vehicle.impoundLocation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit vehicle details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: TextEditingController(text: editedVehicleNumber),
                  onChanged: (value) => editedVehicleNumber = value,
                  decoration:
                      const InputDecoration(labelText: 'Vehicle number'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller:
                      TextEditingController(text: editedImpoundLocation),
                  onChanged: (value) => editedImpoundLocation = value,
                  decoration:
                      const InputDecoration(labelText: 'Impound location'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (editedVehicleNumber.isNotEmpty &&
                    editedImpoundLocation.isNotEmpty) {
                  setState(() {
                    vehicles.remove(vehicle);
                    vehicles.add(Vehicle(
                      vehicleNumber: editedVehicleNumber,
                      impoundLocation: editedImpoundLocation,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Tow truck details'),
                    onTap: towTrucks.isNotEmpty ? null : _showTowTruckDialog,
                  ),
                ),
                ...towTrucks.map((towTruck) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        'Vehicle number: ${towTruck.vehicleNumber} • Driver ID: ${towTruck.driverId}',
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                if (vehicles.isNotEmpty)
                  const Text(
                    'Vehicle details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 20),
                ...vehicles.map((vehicle) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        'Vehicle number: ${vehicle.vehicleNumber} • Impound location: ${vehicle.impoundLocation}',
                      ),
                      onTap: () => _showEditVehicleDialog(vehicle),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton.extended(
              onPressed: _showVehicleDialog,
              tooltip: 'Add vehicle',
              label: const Text('Add vehicle'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}
