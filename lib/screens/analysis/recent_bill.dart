import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      // home: const Responsive(
      //   mobile: MobileAnalysissPage(),
      //   tablet: TabletAnalysisPage(),
      //   desktop: DesktopAnalysissPage(),
      // ),
    );
  }
}
