import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportGeneratorPage {
  Future<File> generateAndShowPdfReport(
      BuildContext context, Map<String, dynamic> reportData) async {
    final pdf = pw.Document();

    try {
      // Example: Add the report content to the PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Environmental Report",
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              ...reportData.values.map((data) {
                return pw.Text(
                  "Room: ${data['room']}, Voltage: ${data['volt']} V, Current: ${data['current']} A, Humidity: ${data['hum']}%, Light Intensity: ${data['light']} lx",
                  style: const pw.TextStyle(fontSize: 16),
                );
              }),
            ],
          ),
        ),
      );

      // Save the PDF to a temporary file
      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;  // Dynamic file name
      final file = File("${output.path}/environmental_report_$timestamp.pdf");
      await file.writeAsBytes(await pdf.save());
      
      return file;
    } catch (e) {
      print("Error generating PDF: $e");
      rethrow;  // Optionally rethrow to handle higher up in the call stack
    }
  }
}
