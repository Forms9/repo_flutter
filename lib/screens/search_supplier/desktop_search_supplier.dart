// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/util/side_menu.dart';

class DesktopSearchSupplier extends StatelessWidget {
  const DesktopSearchSupplier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: handheldAppBar,
      // drawer: const nd.NavigationDrawer(),
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // open drawer+
            const SideMenu(),
          ],
        ),
      ),
    );
  }
}
