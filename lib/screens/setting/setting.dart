// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reporting_app/responsive.dart';
import 'package:reporting_app/screens/setting/desktop_settings.dart';
import 'package:reporting_app/screens/setting/mobile_settings.dart';
import 'package:reporting_app/screens/setting/tablet_settings.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const Responsive(
        mobile: MobileSettingsPage(),
        tablet: TabletSettingsPage(),
        desktop: DesktopSettingsPage(),
      ),
    );
  }
}
