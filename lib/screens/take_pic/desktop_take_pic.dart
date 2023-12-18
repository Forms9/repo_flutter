import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/util/side_menu.dart';

class DesktopTakePic extends StatelessWidget {
  const DesktopTakePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(
            'Take Pic',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFF655B87),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: SideMenu());
  }
}
