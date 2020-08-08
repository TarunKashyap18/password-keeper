import 'package:flutter/material.dart';
import 'package:password_keeper/ui/PasswordScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Keeper"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: new PasswordScreen(),
    );
  }
}
