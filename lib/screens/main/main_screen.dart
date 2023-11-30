// main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reporting_app/controllers/MenuAppController.dart';
import 'package:reporting_app/responsive.dart';
import 'package:reporting_app/screens/dashboard/dashboard_screen.dart';
import 'package:reporting_app/screens/main/components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(
      builder: (context, menuAppController, child) {
        return Scaffold(
          key: menuAppController.scaffoldKey,
          drawer: SideMenu(),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  Expanded(
                    child: SideMenu(),
                  ),
                Expanded(
                  flex: 5,
                  child: DashboardScreen(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
