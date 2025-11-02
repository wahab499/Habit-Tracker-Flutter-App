import 'package:flutter/material.dart';

class Dataimportexport extends StatelessWidget {
  const Dataimportexport({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Import/Export'),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
          )
        ],
      ),
    );
  }
}
