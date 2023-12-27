import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reporting_app/screens/analysis/cards_page/cards.dart';

class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CardAnalysis(),
      // home: const Responsive(
      //   mobile: MobileAnalysissPage(),
      //   tablet: TabletAnalysisPage(),
      //   desktop: DesktopAnalysissPage(),
      // ),
    );
  }
}
