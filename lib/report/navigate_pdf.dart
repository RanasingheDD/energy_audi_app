import 'dart:io';
import 'package:energy_app/models/report_card_model.dart';
import 'package:energy_app/report/display_reort.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:charts_flutter/flutter.dart';
import 'package:share_plus/share_plus.dart'; // For generating charts

class ReportGeneratorPage {
  Future<void> generateAndShowPdfReport(BuildContext context, Map<String, ReportData> reportData) async {
    final pdf = pw.Document();

    // Title Page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "Environmental Report",
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Generated on: ${DateTime.now()}",
                style: pw.TextStyle(fontSize: 18, color: PdfColors.grey),
              ),
            ],
          ),
        ),
      ),
    );

    // Data Table Page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Room Data",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
            ),
            pw.Divider(color: PdfColors.grey),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 1),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.lightBlue),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Room", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Voltage (V)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Current (A)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Humidity (%)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Light (%)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                ...reportData.values.map(
                  (data) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(data.room),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(data.volt.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(data.current.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(data.hum.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(data.light.toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              pw.Text(
                "Voltage and Current Chart",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
              ),
              pw.SizedBox(height: 20),
             /* pw.Container(
                height: 200,
                child: pw.BarChart(
                  pw.Chart(
                    data: reportData.values.map((data) => [data.room, data.volt, data.current]).toList(),
                    series: pw.ChartSeries(
                      name: 'Room Metrics',
                      xValueMapper: (data, _) => data[0],
                      yValueMapper: (data, _) => data[1], // Voltage
                      barColorMapper: (_, index) => index % 2 == 0 ? PdfColors.blue : PdfColors.green,
                    ),
                  ),
                ),
              ),*/
          ],
        ),
      ),
    );

    // Graph Page
   /* pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            children: [

            ],
          ),
        ),
      ),
    );*/

    // Save the PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/environmental_report.pdf");
    await file.writeAsBytes(await pdf.save());

    // Show options to view or download
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Generated"),
        content: const Text("What would you like to do with the report?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewerPage(filePath: file.path),
                ),
              );
            },
            child: const Text("View"),
          ),
          TextButton(
            onPressed: () {
              //Share.shareFiles([file.path], text: 'Environmental Report');
            },
            child: const Text("Share/Download"),
          ),
        ],
      ),
    );
  }
}
