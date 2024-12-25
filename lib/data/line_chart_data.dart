import 'package:energy_app/superbase/superbase_data.dart';
import 'package:fl_chart/fl_chart.dart';

class LineData {
  final SensorDataService _sensorDataService = SensorDataService();

  List<FlSpot> spots = [];

  // Method to fetch data and map index (X-axis) and power (Y-axis)
  Future<void> fetchDataAndMap() async {
    try {
      // Fetch data from SensorDataService
      final sensorData = await _sensorDataService.fetchSensorData();

      if (sensorData.isNotEmpty) {
        // Map the fetched data to FlSpot
        spots = sensorData.asMap().entries.map((entry) {
          int index = entry.key; // Sequential index for X-axis
          var row = entry.value;
          double power = row['power'].toDouble();
          return FlSpot(index.toDouble(), power); // Use index as X and power as Y
        }).toList();

        print('Mapped FlSpot data: $spots');
      } else {
        print('No sensor data available');
      }
    } catch (e) {
      print('Error in fetchDataAndMap: $e');
    }
  }

  // Optional: Define titles and labels if required
  final leftTitle = {

  };

  final bottomTitle = {

  };
}
