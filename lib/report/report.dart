import 'dart:io';
import 'package:energy_app/models/report_card_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<void> generatePdfReport(ReportData data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Environmental Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Text("Room: ${data.room}", style: const pw.TextStyle(fontSize: 16)),
          pw.Text("Voltage: ${data.volt} V", style: const pw.TextStyle(fontSize: 16)),
          pw.Text("Current: ${data.current} A", style: const pw.TextStyle(fontSize: 16)),
          pw.Text("Humidity: ${data.hum}%", style: const pw.TextStyle(fontSize: 16)),
          pw.Text("Light Intensity: ${data.light} lx", style: const pw.TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/environmental_report.pdf");
  await file.writeAsBytes(await pdf.save());

  print("Report saved at: ${file.path}");
}
