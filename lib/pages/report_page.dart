import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 17, 37),
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 21, 17, 37), 
        title: const Text("Report",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(255, 255, 255, 1),
          letterSpacing: 1
        ),
        ),
      ),
      body: Column(
        children: [
        /*  ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Rooom1"),
              );
            }
            )*/
        ],
      ),
    );
  }
}