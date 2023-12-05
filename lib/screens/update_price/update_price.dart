import 'package:flutter/material.dart';
import 'package:reporting_app/responsive.dart';
import 'package:reporting_app/screens/update_price/desktop_update_price.dart';
import 'package:reporting_app/screens/update_price/mobile_update_price.dart';
import 'package:reporting_app/screens/update_price/tablet_update_price.dart';

class UpdatePrice extends StatefulWidget {
  const UpdatePrice({super.key});

  @override
  State<UpdatePrice> createState() => _UpdatePriceState();
}

class _UpdatePriceState extends State<UpdatePrice> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Responsive(
        mobile: MobileUpdatePrice(),
        tablet: TabletUpdatePrice(),
        desktop: DesktopUpdatePrice(),
      ),
    );
  }
}
