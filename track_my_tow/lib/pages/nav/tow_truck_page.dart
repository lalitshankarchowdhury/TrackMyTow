import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../util/profile_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

Map<String, dynamic> currentTowSessionData = {};
bool emitLocation = false;
late Timer _timer;

void _startTimer() {
  const Duration interval = Duration(seconds: 10);
  _timer = Timer.periodic(interval, (Timer timer) {
    _emitCurrentLocation();
  });
}

void _emitCurrentLocation() async {
  if (emitLocation) {
    String url =
        'http://13.60.64.128:3000/api/tow/tows/update-current-location';
    try {
      Map<String, dynamic> requestData = {
        "towId": currentTowSessionData["_id"],
        "currentLocation": await _getCurrentLocation()
      };
      String jsonEncodedData = json.encode(requestData);
      String cookie = jsonDecode(profile!)['cookie'];
      String token = cookie.split('=')[1].split(';')[0];
      http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncodedData,
      );

      if (response.statusCode == 200) {
        print("Updated current location");
      } else {
        throw 'End tow session failed';
      }
    } catch (error) {
      print(error);
    }
  }
}

Future<Map<String, double>> _getCurrentLocation() async {
  final permissionStatus = await Permission.locationWhenInUse.request();
  if (permissionStatus.isGranted) {
    Position position = await Geolocator.getCurrentPosition();
    return {
      'lat': position.latitude,
      'long': position.longitude,
    };
  } else {
    print('Location permission denied.');
    return {};
  }
}

class TowTruckManager extends StatefulWidget {
  const TowTruckManager({super.key});

  @override
  createState() => _TowTruckManagerState();
}

class _TowTruckManagerState extends State<TowTruckManager> {
  bool isTowSessionActive = false;

  void toggleTowSession() {
    if (emitLocation) {
      _timer.cancel();
    } else {
      _startTimer();
    }
    setState(() {
      emitLocation = !emitLocation;
      isTowSessionActive = !isTowSessionActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isTowSessionActive
        ? TowTruckPage(
            onEndSession: toggleTowSession,
          )
        : TowTruckStartPage(
            onStartSession: toggleTowSession,
          );
  }
}

class TowTruckStartPage extends StatelessWidget {
  final VoidCallback onStartSession;

  const TowTruckStartPage({super.key, required this.onStartSession});

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
            SvgPicture.asset(
              'assets/icons/Vehicle.svg',
              width: 125,
              height: 125,
              colorFilter:
                  const ColorFilter.mode(Color(0xFFFCB001), BlendMode.srcATop),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ImpoundLocationDialog(
                    onTowSessionStart: onStartSession,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New session'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Start a tow session to add vehicles and set their impound location',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Vehicle {
  final String numberPlate;
  Vehicle({required this.numberPlate});
}

class TowTruckPage extends StatefulWidget {
  final VoidCallback onEndSession;
  const TowTruckPage({super.key, required this.onEndSession});

  @override
  _TowTruckPageState createState() => _TowTruckPageState();
}

class _TowTruckPageState extends State<TowTruckPage> {
  List<Vehicle> vehicles = [];

  Future<String> _endCurrentTow(String jsonEncodedData) async {
    String url = 'http://13.60.64.128:3000/api/tow/tows';
    try {
      String cookie = jsonDecode(profile!)['cookie'];
      String token = cookie.split('=')[1].split(';')[0];
      print(token);
      http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncodedData,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        currentTowSessionData = responseData['data'];
        return responseData['message'];
      } else {
        throw 'End tow session failed';
      }
    } catch (error) {
      throw 'End tow session failed';
    }
  }

  void _handleCloseCurrentTowSession() async {
    try {
      Map<String, dynamic> requestData = {
        "towId": currentTowSessionData["_id"]
      };
      String jsonEncodedData = json.encode(requestData);
      String result = await _endCurrentTow(jsonEncodedData);
      if (result == 'End tow session failed') {
        print("Failed to end tow session");
      } else {
        widget.onEndSession();
      }
    } catch (error) {
      print("Failed to end tow session: $error");
    }
  }

  void _addVehicleToTow(
      String numberPlate, Map<String, double> pickupLocation) async {
    String url = 'http://13.60.64.128:3000/api/tow/tows/add-vehicle';
    try {
      Map<String, dynamic> requestData = {
        "towId": currentTowSessionData["_id"],
        "numberPlate": numberPlate,
        "pickupLocation": pickupLocation
      };
      String jsonEncodedData = json.encode(requestData);
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
        print("Success!");
        Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
      } else {
        print("Failed to end tow session:");
      }
    } catch (error) {
      print("Failed to end tow session: $error");
    }
  }

  void _addVehicle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String numberPlate = '';
        return AlertDialog(
          title: const Text('Add Vehicle'),
          content: TextField(
            controller: TextEditingController(text: "GJ"),
            onChanged: (value) {
              numberPlate = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter number plate',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (numberPlate.isNotEmpty) {
                  _addVehicleToTow(
                    numberPlate,
                    await _getCurrentLocation(),
                  );
                  setState(() {
                    vehicles.add(Vehicle(numberPlate: numberPlate));
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editVehicle(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String numberPlate = vehicles[index].numberPlate;
        return AlertDialog(
          title: const Text('Edit Vehicle'),
          content: TextField(
            controller:
                TextEditingController(text: vehicles[index].numberPlate),
            onChanged: (value) {
              numberPlate = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter number plate',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (numberPlate.isNotEmpty) {
                  setState(() {
                    vehicles[index] = Vehicle(numberPlate: numberPlate);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteVehicle(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Vehicle'),
          content: const Text('Are you sure you want to delete this vehicle?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  vehicles.removeAt(index);
                });
                Navigator.of(context).pop();
              },
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
        title: const Text('Tow vehicles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _editVehicle(context, index);
                  },
                  onLongPress: () {
                    _deleteVehicle(context, index);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(vehicles[index].numberPlate),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                _addVehicle(context);
              },
              label: const Text('Add vehicle'),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(height: 100),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC4501),
              ),
              onPressed: () {
                _handleCloseCurrentTowSession();
              },
              label: const Text('End session'),
            ),
            const SizedBox(height: 20),
            const Text(
              'End tow session when drop location is reached',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ImpoundLocationDialog extends StatefulWidget {
  final VoidCallback onTowSessionStart;

  const ImpoundLocationDialog({super.key, required this.onTowSessionStart});

  @override
  createState() => _ImpoundLocationDialogState();
}

class _ImpoundLocationDialogState extends State<ImpoundLocationDialog> {
  String selectedLocation = 'Sabarmati RTO';
  Map<String, double> impoundLocation = {
    "lat": 23.066925263101407,
    "long": 72.581401442333
  };

  Future<String> _createNewTow(String jsonEncodedData) async {
    String url = 'http://13.60.64.128:3000/api/tow/tows';
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
        Map<String, dynamic> responseData = json.decode(response.body);
        currentTowSessionData = responseData['data'];
        return responseData['message'];
      } else {
        throw 'Create tow session failed';
      }
    } catch (error) {
      throw 'Create tow session failed';
    }
  }

  void _handleNewTowSession() async {
    try {
      Map<String, dynamic> requestData = {
        "policeId": jsonDecode(profile!)['user']['_id'],
        "startLocation": await _getCurrentLocation(),
        "endLocation": impoundLocation
      };
      String jsonEncodedData = json.encode(requestData);
      String result = await _createNewTow(jsonEncodedData);
      if (result == 'Create tow session failed') {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: const Text('Failed to create new tow session.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        widget.onTowSessionStart();
      }
    } catch (error) {
      print("Failed to create new tow session: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select impound location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Sabarmati RTO'),
            onTap: () {
              setState(() {
                selectedLocation = 'Sabarmati RTO';
                impoundLocation = {
                  "lat": 23.066925263101407,
                  "long": 72.581401442333
                };
              });
            },
            leading: selectedLocation == 'Sabarmati RTO'
                ? const Icon(Icons.check_circle)
                : null,
          ),
          ListTile(
            title: const Text('Vastral RTO'),
            onTap: () {
              setState(() {
                selectedLocation = 'Vastral RTO';
                impoundLocation = {
                  "lat": 23.00090492273734,
                  "long": 72.64524546598686
                };
              });
            },
            leading: selectedLocation == 'Vastral RTO'
                ? const Icon(Icons.check_circle)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: impoundLocation.isNotEmpty
              ? () {
                  _handleNewTowSession();
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
