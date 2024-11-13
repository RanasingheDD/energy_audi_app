import 'package:flutter/material.dart';
import 'package:energy_app/models/card_model.dart';  // Ensure correct import

class CardPage extends StatelessWidget {
  final CardData card;
  const CardPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 27, 21, 37),
          boxShadow: const [BoxShadow(
            color: Colors.deepPurple,
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 1), 
          ),]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(card.image_url,
              width: 20,
              height: 20,
              ),
              const SizedBox(height: 30,),
              Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 22,  
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text(
                    card.value,
                    style: const TextStyle(
                      fontSize: 30,  
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    card.symbol,
                    style: const TextStyle(
                      fontSize: 30,  
                      color: Colors.white,
                      fontWeight: FontWeight.w600
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
