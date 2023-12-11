import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reporting_app/responsive.dart';
import 'package:reporting_app/screens/recent_bills/desktop_recent_analysis.dart';
import 'package:reporting_app/screens/recent_bills/mobile_recent_analysis.dart';
import 'package:reporting_app/screens/recent_bills/tablet_recent_analysis.dart';

class RecentBill extends StatelessWidget {
  const RecentBill({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const Responsive(
        mobile: MobileRecentBillsPage(),
        tablet: TabletRecentBillPage(),
        desktop: DesktopRecentBillsPage(),
      ),
    );
  }
}
