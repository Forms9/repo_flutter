import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reporting_app/screens/Login/responsive_login/desktop_login.dart';
import 'package:reporting_app/screens/dashboard/dashboard_screen.dart';
import 'package:reporting_app/screens/search_barcode/desktop_scan_barcode.dart';
import 'package:reporting_app/screens/search_supplier.dart';
import 'package:reporting_app/screens/take_pic.dart';
import 'package:reporting_app/screens/update_price/update_price.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MainScreen()),
              // );
            },
          ),
          DrawerListTile(
            title: "Search Barcode",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DesktopScanBarcodePage()),
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
                MaterialPageRoute(builder: (context) => UpdatePrice()),
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
            title: "Analysis",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DesktopLoginPage()),
              );
            },
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
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
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
