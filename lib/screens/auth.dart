import 'dart:developer';
import 'dart:io';

import 'package:chat_app/theme/fonts.dart';
import 'package:chat_app/widgets/user_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  var _enteredUserName = "";
  var _enteredEmail = "";
  var _enteredPassword = "";
  File? _selectedImage;
  var _isUploading = false;
  void _submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid || (!_isLogin && _selectedImage == null)) {
      return;
    }
    try {
      setState(() {
        _isUploading = true;
      });
      if (_isLogin) {
        final UserCredential userCredential =
            await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
              
          email: _enteredEmail,
          password: _enteredPassword,
        );
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${userCredential.user!.uid}.jpg");
        await storageRef.putFile(_selectedImage!);
        final imgUrl = await storageRef.getDownloadURL();
        log(imgUrl);

       await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "userName": _enteredUserName,
          "email": _enteredEmail,
          "image_url": imgUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Authintication Failed!",
            style: titleStyle,
          ),
        ),
      );
      setState(() {
        _isUploading = false;
      });
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (File pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
                          if(!_isLogin)
                        InputField(
                          hint: "Enter Your UserName",
                          title: 'UserName',
                          textType: TextInputType.emailAddress,
                          onSaved: (value) => _enteredUserName = value!,
                          validator: (value) {
                            if (value == null ||
                                value.trim().length<4 ) {
                              return "UserName Must be at least 4 characters!";
                            } else {
                              return null;
                            }
                          },
                        ),
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
                        if (_isUploading) const CircularProgressIndicator(),
                        if (!_isUploading)
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
