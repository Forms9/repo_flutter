import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reporting_app/controllers/MenuAppController.dart';
import 'package:reporting_app/screens/dashboard/components/my_fields.dart';
import 'package:reporting_app/screens/dashboard/components/recent_files.dart';
import 'package:reporting_app/util/side_menu.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'components/header.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuAppController>(
        create: (_) => MenuAppController(),
        builder: (context, child) {
          MenuAppController menuAppController =
              Provider.of<MenuAppController>(context);
          return Scaffold(
            key: menuAppController.scaffoldKey,
            drawer: SideMenu(),
            backgroundColor: bgColor,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  Expanded(
                    child: SideMenu(),
                  ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    primary: false,
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Header(),
                        SizedBox(height: defaultPadding),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Column(
                                children: [
                                  MyFiles(),
                                  SizedBox(height: defaultPadding),
                                  RecentFiles(),
                                  if (Responsive.isMobile(context))
                                    SizedBox(height: defaultPadding),
                                  if (Responsive.isMobile(context))
                                    StorageDetails(),
                                ],
                              ),
                            ),
                            if (!Responsive.isMobile(context))
                              SizedBox(width: defaultPadding),
                            // On Mobile means if the screen is less than 850 we don't want to show it
                            if (!Responsive.isMobile(context))
                              Flexible(
                                flex: 2,
                                child: StorageDetails(),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
