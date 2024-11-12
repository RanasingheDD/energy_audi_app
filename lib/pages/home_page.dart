import 'package:energy_app/data/card_data.dart';
import 'package:energy_app/widgets/card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 17, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 17, 37),
        leading: IconButton(
          onPressed: () {
            ////////////////////
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
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
    );
  }
}
