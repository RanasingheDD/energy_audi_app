import 'package:energy_app/models/card_model.dart';
import 'package:flutter/material.dart';

class CardPage extends StatelessWidget {
  final CardData card;
  const CardPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 27, 21, 37),
          boxShadow: const [
            BoxShadow(
              color: Colors.deepPurple,
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                card.image_url,
                width: 20, // Smaller image size
                height: 20,
              ),
              const SizedBox(height: 8),
              Text(
                card.title,
                style: const TextStyle(
                  fontSize: 14, // Reduced text size
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    card.value,
                    style: const TextStyle(
                      fontSize: 18, // Adjusted font size
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    card.symbol,
                    style: const TextStyle(
                      fontSize: 18, // Adjusted font size
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
