import 'package:energy_app/data/menu_data.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatefulWidget {
  final int currentIndex;

  const SideMenuWidget({required this.currentIndex});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: const Color(0xFF171821),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Main Menu',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.menu.length,
              itemBuilder: (context, index) => buildMenuEntry(data, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? Colors.white : Colors.transparent,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });

          // Navigate to the selected page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(data.menu[index].title),
                  backgroundColor: const Color(0xFF171821),
                ),
                body: data.menu[index].page,
                drawer: Drawer(
                  child: SideMenuWidget(currentIndex: index),
                ),
              ),
            ),
          );
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
