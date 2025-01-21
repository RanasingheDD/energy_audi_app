import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Ensure Supabase is imported

class LineData {
  List<FlSpot> spots = [];

  // Method to fetch power data
  Future<List<Map<String, dynamic>>> fetchPowerData() async {
    try {
      // Fetch data from the 'SensorData' table and select the 'power' column
      final response = await Supabase.instance.client
          .from('SensorData') // Table name
          .select('power') // Selecting 'power' column
          .limit(100) // Optional: limit the number of records if needed
          .order('created_at',
              ascending: false); // Optional: order by creation date

      if (response is List) {
        // Return the fetched data directly as Map<String, dynamic>
        return response;
      } else {
        throw Exception('Unexpected response type.');
      }
    } catch (e) {
      print('Error fetching power data: $e');
      throw Exception("Failed to fetch power data: $e");
    }
  }

  // Method to fetch data and map index (X-axis) and power (Y-axis)
  Future<void> fetchDataAndMap() async {
    try {
      // Fetch power data
      final powerData = await fetchPowerData();

      if (powerData.isNotEmpty) {
        // Map the fetched data to FlSpot
        spots = powerData.asMap().entries.map((entry) {
          int index = entry.key; // Sequential index for X-axis
          var row = entry.value;
          double power = (row['power'] ?? 0.0)
              .toDouble(); // Default to 0.0 if null and cast to double
          return FlSpot(
              index.toDouble(), power); // Use index as X and power as Y
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
    // Add your left title configuration if needed
  };

  final bottomTitle = {
    // Add your bottom title configuration if needed
  };
}
