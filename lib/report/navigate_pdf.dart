import 'dart:io';
import 'package:energy_app/models/report_card_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class ReportGeneratorPage {
  Future<File?> generateAndShowPdfReport(
      BuildContext context, Map<String, ReportData> reportData) async {
    final pdf = pw.Document();

    // Define a table style with black text color
    final tableStyle = const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 12,
    );

    final tableHeaderStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    // Get current date and time
    final currentDateTime = DateTime.now();
    final formattedDate =
        "${currentDateTime.day}/${currentDateTime.month}/${currentDateTime.year}";
    final formattedTime =
        "${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second}";

    // Add a title page with the current date, time, and room number
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Room Report Summary',
                    style: const pw.TextStyle(fontSize: 24, color: PdfColors.black)),
                pw.SizedBox(height: 20),
                pw.Text('Date: $formattedDate',
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.black)),
                pw.Text('Time: $formattedTime',
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.black)),
                pw.SizedBox(height: 10),
                pw.Text('Room Number: ${reportData.values.first.room}',
                    style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors
                            .black)), // Room number from the first entry
              ],
            ),
          );
        },
      ),
    );

    // Add detailed content with a table
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              children: [
                pw.Text('Detailed Report',
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  context: context,
                  data: [
                    [
                      'Room',
                      'Voltage (V)',
                      'Current (A)',
                      'Power Factor'
                      'Humidity (%)',
                      'Light Intensity (mW/m²)',
                      'Temperature (°C)'
                    ],
                    ...reportData.values
                        .map((data) => [
                              data.room,
                              data.volt,
                              data.current,
                              data.pF,
                              data.hum,
                              data.light,
                              data.tempure
                            ])
                        ,
                  ],
                  headerStyle: tableHeaderStyle,
                  cellStyle: tableStyle,
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.deepPurple,
                  ),
                  cellAlignment: pw.Alignment.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save the PDF to a temporary file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/environmental_report.pdf");
    await file.writeAsBytes(await pdf.save());
    return file; // Ensure this line returns a File object
  }
}
