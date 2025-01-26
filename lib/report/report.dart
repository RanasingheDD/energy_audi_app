import 'dart:convert';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:energy_app/report/navigate_pdf.dart';
import 'package:energy_app/widgets/button.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 21, 17, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 17, 37),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        title: const Text(
          "Room Reports",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
      drawer: Drawer(
        child: SideMenuWidget(
          currentIndex: 1,
          onMenuSelect: (index) {
            print('Selected menu index: $index');
          },
        ),
      ),
      body: Consumer<ReportDataProvider>(
        builder: (BuildContext context, ReportDataProvider reportData,
            Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: reportData.reportData.length,
                    itemBuilder: (context, index) {
                      final data = reportData.reportData.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Room: ${data.room}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Voltage: ${data.volt} V",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Current: ${data.current} A",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Power : ${data.power} W",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Humidity: ${data.hum} %",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Light: ${data.light} lux",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Temperature: ${data.tempure} C",
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: BUTTONWIDGET(
                    name: "Generate & Upload Report",
                    color: Colors.green,
                    additem: () async {
                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        // API URL
                        final apiUrl =
                            'http://34.133.181.28:5000/generate-pdf';

                        // Accessing dynamic data from ReportDataProvider
                        final reportData = context
                            .read<ReportDataProvider>()
                            .reportData
                            .values;

                        // Preparing the payload dynamically
                        final details = reportData.map((data) {
                          return {
                            "room": data.room,
                            "voltage": data.volt,
                            "current": data.current,
                            "power": data.power,
                            "humidity": double.parse(data.hum.toString()),  // Converting to int
                            "light_intensity":double.parse(data.light.toString()),  // Converting to int
                            "temperature": double.parse(data.tempure.toString()),  // Converting to int
                          };
                        }).toList();

                        final payload = {
                          "room_number":
                              "010", // Replace with dynamic data if needed
                          "date": DateTime.now()
                              .toIso8601String()
                              .split('T')[0], // Current date
                          "time":
                              TimeOfDay.now().format(context), // Current time
                          "details": details,
                        };

                        // Send the POST request
                        final response = await http.post(
                          Uri.parse(apiUrl),
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(payload),
                        );

                        // Handle the response
                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Report sent successfully!')),
                          );
                          print("Response: ${response.body}");
                        } else {
                          throw Exception(
                              "Failed to send report. Status code: ${response.statusCode}");
                        }
                      } catch (e) {
                        // Error handling
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to send report.')),
                        );
                      } finally {
                        // Dismiss loading indicator
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
