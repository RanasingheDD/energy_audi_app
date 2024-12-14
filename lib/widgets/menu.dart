import 'package:energy_app/data/menu_data.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onMenuSelect;

  const SideMenuWidget({
    super.key,
    required this.currentIndex,
    required this.onMenuSelect,
  });

  @override
  Widget build(BuildContext context) {
    final menuData = SideMenuData();
    const backgroundColor = Color.fromARGB(255, 21, 17, 37); 
    const textColor = Colors.white;

    return Container(
      color: backgroundColor, 
      child: ListView(
        padding: EdgeInsets.zero, 
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: backgroundColor, 
            ),
            margin: EdgeInsets.all(5), 
            padding: EdgeInsets.only(left: 16,), 
            child: Text(
              'Main Menu',
              style: TextStyle(
                fontSize: 24,
                color: textColor, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...menuData.menu.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;

            return Container(
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.deepPurple, 
                      borderRadius: BorderRadius.circular(8), 
                    )
                  : null, 
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16), 
              child: ListTile(
                contentPadding: EdgeInsets.zero, 
                leading: Icon(
                  item.icon,
                  color: isSelected ? Colors.white : textColor, 
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: textColor, 
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  onMenuSelect(index); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item.page),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
