import 'package:flutter/material.dart';

import '../widgets/input_field.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Image.asset("assets/logo.jpg"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal:24.0),
            child: Card(
            
              child: Padding(
              padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    InputField(hint: "Enter Your Email", title: 'Email',textType: TextInputType.emailAddress,),
                    
                    InputField(hint: "Enter Your Password", title: 'Password',textType: TextInputType.visiblePassword,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}