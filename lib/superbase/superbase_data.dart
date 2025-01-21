import 'package:supabase_flutter/supabase_flutter.dart';

class SensorDataService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchSensorData() async {
    try {
      // Fetch data from the 'SensorData' table and select multiple columns
      final response = await supabase
          .from('SensorData')  // Table name
          .select('power, voltage, current, temperature, humidity, light') // Selecting multiple columns
          .limit(100)  // Optional: limit the number of records if needed
          .order('created_at', ascending: false);  // Optional: order by creation date if applicable

      // Ensure response data is a List
      return (response).map((data) {
        return {
          'power': data['power'],
          'voltage': data['voltage'],
          'current': data['current'],
          'temperature': data['temperature'],
          'humidity': data['humidity'],
          'light': data['light'],
        };
      }).toList();
        } catch (e) {
      // Improved error handling
      print('Error fetching sensor data: $e');
      throw Exception("Failed to fetch sensor data: $e");
    }
  }
}
