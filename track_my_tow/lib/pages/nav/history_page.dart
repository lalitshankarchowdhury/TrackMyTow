import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../util/profile_manager.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key});

  Future<List<Map<String, dynamic>>?> _fetchTowHistory(
      BuildContext context) async {
    try {
      String url = 'http://13.60.64.128:3000/api/tow/tows/history';
      Map<String, dynamic> requestData = {
        "policeId": jsonDecode(profile!)['user']['_id']
      };
      String jsonEncodedData = json.encode(requestData);
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
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<Map<String, dynamic>> sortedData =
            data.cast<Map<String, dynamic>>().toList();
        sortedData.sort((a, b) => b['endTime'].compareTo(a['endTime']));
        return sortedData;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: _fetchTowHistory(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<Map<String, dynamic>> history = snapshot.data!;
                    int totalTows = history.length;
                    int totalVehiclesTowedCount = history
                        .map((tow) => tow['towedVehicles'].length)
                        .reduce((sum, count) => sum + count);
                    double averageSessionLength = history
                            .map((tow) => DateTime.parse(tow['endTime'])
                                .difference(DateTime.parse(tow['startTime']))
                                .inMinutes)
                            .reduce((sum, duration) => sum + duration) /
                        history.length;

                    return Column(
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tow statistics',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Tows'),
                                    Text('$totalTows'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Vehicles Towed'),
                                    Text('$totalVehiclesTowedCount'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Average Session Length'),
                                    Text(
                                        '${averageSessionLength.toStringAsFixed(2)} minutes'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              final tow = history[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Card(
                                  elevation: 4,
                                  child: ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Start Time: ${tow['startTime']}'),
                                        Text('End Time: ${tow['endTime']}'),
                                        Text(
                                            'Start Location: (${tow['startLocation']['lat'].toString().substring(0, 8)}, ${tow['startLocation']['long'].toString().substring(0, 8)})'),
                                        Text(
                                            'End Location: (${tow['endLocation']['lat'].toString().substring(0, 8)}, ${tow['endLocation']['long'].toString().substring(0, 8)})'),
                                        Text(
                                            'Number of Vehicles Towed: ${tow['towedVehicles'].length}'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
