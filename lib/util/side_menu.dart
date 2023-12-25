import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/screens/analysis/analysis.dart';
import 'package:reporting_app/screens/dashboard/dashboard_screen.dart';
import 'package:reporting_app/screens/recent_bills/recent_bill.dart';
import 'package:reporting_app/screens/generate_bill/generate_bill.dart';
import 'package:reporting_app/screens/search_barcode/desktop_scan_barcode.dart';
import 'package:reporting_app/screens/search_supplier/search_supplier.dart';
import 'package:reporting_app/screens/setting/setting.dart';
import 'package:reporting_app/screens/take_pic/takepic.dart';
import 'package:reporting_app/screens/update_price/update_price.dart';

class SideMenu extends StatelessWidget {
  // ignore: use_super_parameters
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Search Supplier",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchSupplier()),
              );
            },
          ),
          DrawerListTile(
            title: "Update Price",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                // ignore: prefer_const_constructors
                MaterialPageRoute(builder: (context) => UpdatePrice()),
              );
            },
          ),
          DrawerListTile(
            title: "Generate Bill",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                // ignore: prefer_const_constructors
                MaterialPageRoute(builder: (context) => GenerateBill()),
              );
            },
          ),
          DrawerListTile(
            title: "Recent Bills",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                // ignore: prefer_const_constructors
                MaterialPageRoute(builder: (context) => RecentBill()),
              );
            },
          ),
          DrawerListTile(
            title: "Analysis",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Analysis()),
              );
            },
          ),
          DrawerListTile(
            title: "Take Pic",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TakePicPage()),
              );
            },
          ),
          DrawerListTile(
            title: "Search Barcode",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    // ignore: prefer_const_constructors
                    builder: (context) => DesktopScanBarcodePage()),
              );
            },
          ),
          DrawerListTile(
            title: "Setting",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                // ignore: prefer_const_constructors
                MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  // ignore: use_super_parameters
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        // ignore: prefer_const_constructors
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        // ignore: prefer_const_constructors
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
