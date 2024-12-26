import 'package:energy_app/models/card_model.dart';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:energy_app/superbase/superbase_data.dart';
import 'package:energy_app/widgets/button.dart';
import 'package:energy_app/widgets/card.dart';
import 'package:energy_app/widgets/line_chart.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  double averagePower = 0.0;

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
      // Fetch the sensor data from the service
      final data = await _sensorDataService.fetchSensorData();

      // Set the state after fetching and calculating values
      setState(() {
        // Update averagePower with the calculated value
        averagePower = _calculateAveragePower(data);

        // Update the 'Power' card value// Power card

        // Update other cards with respective values
        cards[0].value = data.isNotEmpty
            ? data[0]['voltage'].toString()
            : "0"; // Voltage card
        cards[1].value = data.isNotEmpty ? data[0]['current'].toString() : "0";
        cards[2].value = data.isNotEmpty ? data[0]['power'].toString() : "0";
        cards[3].value = data.isNotEmpty
            ? data[0]['temperature'].toString()
            : "0"; // Temperature card
        cards[4].value = data.isNotEmpty
            ? data[0]['humidity'].toString()
            : "0"; // Humidity card
        cards[5].value = data.isNotEmpty
            ? data[0]['light'].toString()
            : "0"; // Brightness card
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showTitle = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadSensorData,
      child: Scaffold(
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
                              1.5, // Adjust this for card height/width ratio
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
                        color: Colors.red,
                        additem: () {
                          try {
                            print(cards[2].value);
                            reportData.addData("Room 01", cards);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Room 01 added to report')),
                            );
                          } catch (e) {
                            // Check if the card values are properly updated
      
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Failed to add Room 01 to report')),
                            );
                          }
                        },
                      ),
                      BUTTONWIDGET(
                        name: "New Task",
                        color: Colors.green,
                        additem: () {},
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
