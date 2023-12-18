import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/util/my_tile.dart';
import 'package:reporting_app/util/side_menu.dart';

class DesktopSettingsPage extends StatefulWidget {
  // ignore: use_super_parameters
  const DesktopSettingsPage({Key? key}) : super(key: key);

  @override
  State<DesktopSettingsPage> createState() => _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends State<DesktopSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // drawer: const nd.NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer+
            const SideMenu(),

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
