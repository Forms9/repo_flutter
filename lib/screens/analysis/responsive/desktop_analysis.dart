import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/screens/dashboard/components/storage_details.dart';
import 'package:reporting_app/util/side_menu.dart';

class DesktopAnalysissPage extends StatelessWidget {
  const DesktopAnalysissPage({super.key});

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
      body: StorageDetails(),
    );
  }
}
