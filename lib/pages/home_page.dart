import 'package:energy_app/data/card_data.dart';
import 'package:energy_app/widgets/card.dart';
import 'package:energy_app/widgets/line_chart.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showTitle = false;

  // Define a GlobalKey to control the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Delay the title appearance for the animation effect
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showTitle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key here
      backgroundColor: const Color.fromARGB(255, 21, 17, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 17, 37),
        leading: IconButton(
          onPressed: () {
            // Open the drawer using the scaffold key
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _showTitle
              ? const Text(
                  'Energy Audit Dashboard',
                  key: ValueKey("title"), // Key triggers AnimatedSwitcher
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox(), // Empty widget before the title appears
        ),
        centerTitle: true,
      ),
      drawer: const Drawer(child: SideMenuWidget()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 1,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return CardPage(card: cards[index]);
                },
              ),
            ),
          ),
          const Expanded(child: LineChartCard()),
        ],
      ),
    );
  }
}
