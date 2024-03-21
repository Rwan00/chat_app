import 'dart:developer';

import 'package:chat_app/theme/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/input_field.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var _enteredEmail = "";
  var _enteredPassword = "";
  void _submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    if (_isLogin) {
      
    }
    
    else{
      try {
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      }on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message??"Authintication Failed!",style: titleStyle,),),
        );
      }
    }

    _formKey.currentState!.save();
    log(_enteredEmail);
    log(_enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset("assets/logo.jpg"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField(
                          hint: "Enter Your Email",
                          title: 'Email',
                          textType: TextInputType.emailAddress,
                          onSaved: (value) => _enteredEmail = value!,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return "Invalid Email Address!";
                            } else {
                              return null;
                            }
                          },
                        ),
                        InputField(
                          hint: "Enter Your Password",
                          title: 'Password',
                          textType: TextInputType.visiblePassword,
                          onSaved: (value) => _enteredPassword = value!,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return "Password Must Be 6 Characters!";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 68, 0, 80),
                            ),
                          ),
                          child: Text(
                            _isLogin ? "Login" : "Sign Up",
                            style: titleStyle.copyWith(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? "Create Account"
                                : "Already Have An Account?",
                            style: titleStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
