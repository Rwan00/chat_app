import 'package:chat_app/theme/fonts.dart';
import 'package:flutter/material.dart';

class WaitingSplashScreen extends StatelessWidget {
  const WaitingSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Waiting",
          style: heading,
        ),
        centerTitle: true,
       
      ),
      body: const Center(child: Text("Loading...")),
    );
  }
}
