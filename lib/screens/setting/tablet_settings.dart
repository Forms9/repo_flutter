import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/util/my_tile.dart';
import 'package:reporting_app/util/side_menu.dart';

class TabletSettingsPage extends StatefulWidget {
  // ignore: use_super_parameters
  const TabletSettingsPage({Key? key}) : super(key: key);

  @override
  State<TabletSettingsPage> createState() => _TabletSettingsPageState();
}

class _TabletSettingsPageState extends State<TabletSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: handheldAppBar,
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer+
            // const nd.NavigationDrawer(),

            // first half of page
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: ScrollController(),
                children: [
                  // first 4 boxes in
                  Padding(
                    padding: settingsCategoryPadding,
                    child: Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: defaultTextColor,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SettingsTile(
                        text: 'User Management',
                        subtext: 'Add Users',
                        icon: FontAwesomeIcons.userGear,
                        press: () => settingsItem(context, 0),
                      ),
                      SettingsTile(
                        text: 'User Management',
                        subtext: 'Update Users.',
                        icon: FontAwesomeIcons.userGear,
                        press: () => settingsItem(context, 3),
                      ),
                      SettingsTile(
                        text: 'User Management',
                        subtext: 'Delete Users.',
                        icon: FontAwesomeIcons.userGear,
                        press: () => settingsItem(context, 3),
                      ),
                      SettingsTile(
                        text: 'POS Number Management',
                        subtext: 'Set POS Number.',
                        icon: FontAwesomeIcons.userGear,
                        press: () => settingsItem(context, 4),
                      ),
                      // ignore: prefer_const_constructors
                      const SaleModeTile(
                        text: 'Sale Mode',
                        subtext: 'Switch to Sale Mode',
                        icon: FontAwesomeIcons.percent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
