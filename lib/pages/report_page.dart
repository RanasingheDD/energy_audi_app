import 'package:energy_app/models/report_card_model.dart';
import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:energy_app/widgets/card.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatelessWidget {
   ReportPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 17, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 17, 37),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(), // Open the drawer
          ),
        ),
        title: const Text(
          "Report",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(255, 255, 255, 1),
            letterSpacing: 1,
          ),
        ),
      ),
      drawer: Drawer(
           child: SideMenuWidget(currentIndex: 1)
      ),
      body: Consumer<ReportDataProvider>(
        builder: (BuildContext context, ReportDataProvider reportdata, Widget? child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: reportdata.reportData.length,
                  itemBuilder: (context, index) {
                    final ReportData data = reportdata.reportData.values.toList()[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Room: ${data.room}",
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("Voltage: ${data.volt}", style: const TextStyle(color: Colors.white)),
                          Text("Current: ${data.current}", style: const TextStyle(color: Colors.white)),
                          Text("Humidity: ${data.hum}", style: const TextStyle(color: Colors.white)),
                          Text("Light: ${data.light}", style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      leading: const Icon(Icons.room, color: Colors.white),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
