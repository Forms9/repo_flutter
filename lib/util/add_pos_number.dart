import 'package:flutter/material.dart';

class AddPosNumber extends StatefulWidget {
  const AddPosNumber({super.key});

  @override
  State<AddPosNumber> createState() => _AddPosNumberState();
}

class _AddPosNumberState extends State<AddPosNumber> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
    );
  }
}
