
import 'package:energy_app/models/card_model.dart';
import 'package:energy_app/models/report_card_model.dart';
import 'package:flutter/material.dart';

class ReportDataProvider extends ChangeNotifier{

  Map<String , ReportData> _reportData = {};

  Map<String , ReportData> get reportData {
    return {..._reportData};
  }

  //add homepage data to report page
void addData(String room, List<CardData> cardData) {
  // Extract values from the cardData list
  final String voltage = cardData.firstWhere((card) => card.title == "Voltage").value;
  final String current = cardData.firstWhere((card) => card.title == "Current").value;
  final String humidity = cardData.firstWhere((card) => card.title == "Humadity").value;
  final String brightness = cardData.firstWhere((card) => card.title == "Brightness").value;

  // Add the extracted values to the _reportData map
  _reportData.putIfAbsent(
    room,
    () => ReportData(
      volt: voltage,
      current: current,
      hum: humidity,
      light: brightness,
      room: room,
    ),
  );

  // Notify listeners about the change
  notifyListeners();
}


}