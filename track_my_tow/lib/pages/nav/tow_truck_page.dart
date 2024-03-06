import 'package:flutter/material.dart';

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

class TowTruckPage extends StatefulWidget {
  const TowTruckPage({super.key});

  @override
  createState() => _TowTruckPageState();
}

class _TowTruckPageState extends State<TowTruckPage> {
  List<TowTruck> towTrucks = [];
  List<Vehicle> vehicles = [];
  bool showFAB = false;

  void _showTowTruckDialog() {
    String vehicleNumber = '';
    String driverId = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Tow Truck Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  onChanged: (value) => vehicleNumber = value,
                  decoration:
                      const InputDecoration(labelText: 'Vehicle Number'),
                ),
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
          title: const Text('Enter Vehicle Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  onChanged: (value) => vehicleNumber = value,
                  decoration:
                      const InputDecoration(labelText: 'Vehicle Number'),
                ),
                TextField(
                  onChanged: (value) => impoundLocation = value,
                  decoration:
                      const InputDecoration(labelText: 'Impound Location'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (vehicleNumber.isNotEmpty && impoundLocation.isNotEmpty) {
                  setState(() {
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

  void _showEditVehicleDialog(Vehicle vehicle) {
    String editedVehicleNumber = vehicle.vehicleNumber;
    String editedImpoundLocation = vehicle.impoundLocation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Vehicle Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: TextEditingController(text: editedVehicleNumber),
                  onChanged: (value) => editedVehicleNumber = value,
                  decoration:
                      const InputDecoration(labelText: 'Vehicle Number'),
                ),
                TextField(
                  controller:
                      TextEditingController(text: editedImpoundLocation),
                  onChanged: (value) => editedImpoundLocation = value,
                  decoration:
                      const InputDecoration(labelText: 'Impound Location'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                  title: const Text('Enter tow truck details'),
                  onTap: towTrucks.isNotEmpty ? null : _showTowTruckDialog,
                ),
              ),
              ...towTrucks.map((towTruck) {
                return Card(
                  child: ListTile(
                    title: Text(
                      'Vehicle Number: ${towTruck.vehicleNumber} | Driver ID: ${towTruck.driverId}',
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
              // Card(
              //   child: ListTile(
              //     title: const Text('Vehicle Details'),
              //     onTap: _showVehicleDialog,
              //   ),
              // ),
              ...vehicles.map((vehicle) {
                return Card(
                  child: ListTile(
                    title: Text(
                      'Vehicle Number: ${vehicle.vehicleNumber} | Impound Location: ${vehicle.impoundLocation}',
                    ),
                    onTap: () => _showEditVehicleDialog(vehicle),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: _showVehicleDialog,
              tooltip: 'Add Vehicle',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
