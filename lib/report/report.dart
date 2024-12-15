import 'package:energy_app/provider/report_data_provider.dart';
import 'package:energy_app/report/navigate_pdf.dart';
import 'package:energy_app/widgets/button.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

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
                              Text("Power Factor: ${data.pF} ",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Humidity: ${data.hum} %",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Light: ${data.light} mW/m^2",
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
                      final reportData = Provider.of<ReportDataProvider>(
                              context,
                              listen: false)
                          .reportData;

                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        // Generate the PDF file
                        final pdfFile = await ReportGeneratorPage()
                            .generateAndShowPdfReport(context, reportData);

                        if (pdfFile == null) {
                          throw Exception(
                              "Failed to generate a valid PDF file.");
                        }

                        // Initialize Supabase client
                        final supabase = Supabase.instance.client;

                        // Define the file path
                        final fileName =
                            'reports/${DateTime.now()}.pdf';

                        // Upload the file to Supabase Storage
                        final response =
                            await supabase.storage.from('reports').upload(
                                  fileName,
                                  pdfFile,
                                );

                        // Get the public URL
                        final publicUrl = supabase.storage
                            .from('reports')
                            .getPublicUrl(fileName);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Report0 uploaded successfully!')),
                        );

                        print("Uploaded report URL: $publicUrl");
                      } catch (e) {
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to upload report0.')),
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
