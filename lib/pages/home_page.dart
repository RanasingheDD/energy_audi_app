import 'package:energy_app/models/card_model.dart';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:energy_app/superbase/superbase_data.dart';
import 'package:energy_app/widgets/button.dart';
import 'package:energy_app/widgets/card.dart';
import 'package:energy_app/widgets/line_chart.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Initial cards data
List<CardData> cards = [
  CardData(
      title: "Voltage",
      image_url: "assets/voltage.png",
      value: "0",
      symbol: "V"),
  CardData(
      title: "Current",
      image_url: "assets/voltage.png",
      value: "0",
      symbol: "A"),
  CardData(title: "Power", image_url: "assets/pf.png", value: "0", symbol: ""),
  CardData(
      title: "Temperature",
      image_url: "assets/hum.png",
      value: "0",
      symbol: "C"),
  CardData(
      title: "Humidity", image_url: "assets/hum.png", value: "0", symbol: "%"),
  CardData(
      title: "Light",
      image_url: "assets/bright.png",
      value: "0",
      symbol: "lux"),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SensorDataService _sensorDataService = SensorDataService();
  final supabase = Supabase.instance.client;
  double averagePower = 0.0;
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSensorData();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showTitle = true;
      });
    });
  }

  Future<void> _loadSensorData() async {
    try {
      final data = await _sensorDataService.fetchSensorData();
      setState(() {
        averagePower = _calculateAveragePower(data);

        cards[0].value = data.isNotEmpty ? data[0]['voltage'].toString() : "0";
        cards[1].value = data.isNotEmpty ? data[0]['current'].toString() : "0";
        cards[2].value = data.isNotEmpty ? data[0]['power'].toString() : "0";
        cards[3].value =
            data.isNotEmpty ? data[0]['temperature'].toString() : "0";
        cards[4].value = data.isNotEmpty ? data[0]['humidity'].toString() : "0";
        cards[5].value = data.isNotEmpty ? data[0]['light'].toString() : "0";
      });
    } catch (e) {
      print('Error loading sensor data: $e');
    }
  }

  double _calculateAveragePower(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0.0;

    double totalPower = 0.0;
    for (var entry in data) {
      totalPower += entry['power'];
    }

    return totalPower / data.length;
  }

  void _showRoomNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Room Name'),
          content: TextField(
            controller: _roomNameController,
            decoration: const InputDecoration(hintText: 'Room Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String roomName = _roomNameController.text.isNotEmpty
                    ? _roomNameController.text
                    : 'Room 01'; // Default name if not provided
                // Add the room to the report with the name
                try {
                  print(cards[2].value);
                  Provider.of<ReportDataProvider>(context, listen: false)
                      .addData(roomName, cards);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$roomName added to report')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to add room to report'),
                    ),
                  );
                }
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _confirmAndDeleteDatabase(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Database Data"),
          content: const Text(
              "Are you sure you want to delete all data from the database? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteSupabaseData(context);
                Navigator.of(context).pop(); // Close the dialog after deleting
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSupabaseData(BuildContext context) async {
    try {
      print("1234");
      // Replace 'your_table_name' with your Supabase table name
      final response = await supabase.from('SensorData').delete().neq('id', '01e3cb9c-0979-4f2b-87b8-7dae3417fd1c');
      print("123"); // Adjust the condition as needed
      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All data deleted successfully!")),
        );
      } else {
        throw response.error!.message;
      }
    } catch (e) {
      print(e);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showTitle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey
      backgroundColor: const Color.fromARGB(255, 21, 17, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 17, 37),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _showTitle
              ? const Text(
                  'Energy Audit Dashboard',
                  key: ValueKey("title"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              : const SizedBox(height: 20,),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SideMenuWidget(
          currentIndex: 0,
          onMenuSelect: (index) {
            print('Selected menu index: $index');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<ReportDataProvider>(
          builder: (context, reportData, child) {
            return Column(
              children: [
                //SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio:
                            1.7, // Adjust this for card height/width ratio
                      ),
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final CardData card = cards[index];
                        return CardPage(card: card);
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: LineChartCard(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BUTTONWIDGET(
                      name: "Add to Report",
                      color: Colors.green,
                      additem: _showRoomNameDialog
                    ),
                    BUTTONWIDGET(
                      name: "Delete database data",
                      color: Colors.red,
                      additem: () => _confirmAndDeleteDatabase(context),

                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
