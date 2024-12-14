import 'package:energy_app/data/card_data.dart';
import 'package:energy_app/models/card_model.dart';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:energy_app/widgets/button.dart';
import 'package:energy_app/widgets/card.dart';
import 'package:energy_app/widgets/line_chart.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showTitle = true;
      });
    });
  }

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
              : const SizedBox(),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BUTTONWIDGET(
                      name: "Add to Report",
                      color: Colors.red,
                      additem: () {
                        try {
                          reportData.addData("Room 01", cards);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Room 01 added to report')),
                          );
                        } catch (e) {
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
    );
  }
}
