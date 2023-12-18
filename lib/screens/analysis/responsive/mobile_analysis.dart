import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/util/side_menu.dart';

class MobileAnalysissPage extends StatelessWidget {
  const MobileAnalysissPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Analysis',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF655B87),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: SideMenu(),
    );
  }
}
