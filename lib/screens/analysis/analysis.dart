import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reporting_app/screens/analysis/responsive/mobile_analysis.dart';

class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MobileAnalysissPage(),
      // home: const Responsive(
      //   mobile: MobileAnalysissPage(),
      //   tablet: TabletAnalysisPage(),
      //   desktop: DesktopAnalysissPage(),
      // ),
    );
  }
}
