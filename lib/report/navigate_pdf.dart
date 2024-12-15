import 'dart:io';
import 'package:energy_app/models/report_card_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ReportGeneratorPage {
  Future<File?> generateAndShowPdfReport(
      BuildContext context, Map<String, ReportData> reportData) async {
    final pdf = pw.Document();

    // Define text styles for the table
    final tableStyle = const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 12,
    );

    final tableHeaderStyle = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 11,
      fontWeight: pw.FontWeight.bold,
    );

    // Get current date and time
    final currentDateTime = DateTime.now();
    final formattedDate =
        "${currentDateTime.day}/${currentDateTime.month}/${currentDateTime.year}";
    final formattedTime =
        "${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second}";

    // Add a title page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Room Report Summary',
                  style: const pw.TextStyle(fontSize: 24, color: PdfColors.black),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Date: $formattedDate',
                  style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
                ),
                pw.Text(
                  'Time: $formattedTime',
                  style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Room Number: ${reportData.values.first.room}',
                  style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
                ),
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
                pw.Text(
                  'Detailed Report',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Expanded(
                  child: pw.Table.fromTextArray(
                    context: context,
                    data: [
                      [
                        'Room',
                        'Voltage (V)',
                        'Current (A)',
                        'Power Factor',
                        'Humidity (%)',
                        'Light Intensity (mW/m²)',
                        'Temperature (°C)',
                      ],
                      ...reportData.values.map((data) => [
                            data.room,
                            data.volt.toString(),
                            data.current.toString(),
                            data.pF.toString(),
                            data.hum.toString(),
                            data.light.toString(),
                            data.tempure.toString(),
                          ]),
                    ],
                    headerStyle: tableHeaderStyle,
                    cellStyle: tableStyle,
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColors.deepPurple,
                    ),
                    headerAlignment: pw.Alignment.center,
                    cellAlignment: pw.Alignment.center,
                    border: pw.TableBorder.all(
                      color: PdfColors.black,
                      width: 0.5,
                    ),
                  ),
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
    return file;
  }
}
