import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:objectbox/objectbox.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/screens/Login/add_user.dart';
import 'package:reporting_app/util/add_pos_number.dart';

class MyTile extends StatelessWidget {
  // ignore: use_super_parameters
  const MyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: tileSecondaryColor,
        ),
      ),
    );
  }
}

class RecentBillsTile extends StatelessWidget {
  // ignore: use_super_parameters
  const RecentBillsTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.billdate,
    required this.billtotal,
    required this.billdistotal,
    required this.press,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String billdate;
  final String billtotal;
  final String billdistotal;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding,
      child: Material(
        child: ListTile(
          tileColor: bgColor,
          hoverColor: Color(0xFF655B87),
          shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(1),
              side: const BorderSide(color: Colors.grey, width: 1)),
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Bill Number : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 65.0),
                      child: Text(
                        billdate,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10,
                  color: defaultTextColor,
                  thickness: 1,
                  endIndent: 65,
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(subtitle, style: drawerTextColor),
          ),
          trailing: SizedBox(
            width: 225,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Bill Total : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      billtotal,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Disc. Bill Total : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      billdistotal,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: press,
        ),
      ),
    );
  }
}

class RecentBillsTabletDashboardTile extends StatelessWidget {
  // ignore: use_super_parameters
  const RecentBillsTabletDashboardTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.billdate,
    required this.billtotal,
    required this.billdistotal,
    required this.press,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String billdate;
  final String billtotal;
  final String billdistotal;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding,
      child: Material(
        child: ListTile(
          tileColor: Colors.grey[100],
          hoverColor: defaultBgAccentColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.grey, width: 1)),
          title: Padding(
            padding: const EdgeInsets.only(left: 0.0, bottom: 4, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Bill Number : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text(
                        billdate,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10,
                  color: defaultTextColor,
                  thickness: 1,
                  endIndent: 30,
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
            child: Text(
              subtitle,
              style: TextStyle(
                color: defaultTextColor,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 12,
              ),
            ),
          ),
          trailing: SizedBox(
            width: 180,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Bill Total : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      billtotal,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Disc. Bill Total : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      billdistotal,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: press,
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  // ignore: use_super_parameters
  const SettingsTile({
    Key? key,
    required this.text,
    required this.subtext,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text;
  final String subtext;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            child: ListTile(
              tileColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              title: Text(text, style: drawerTextColor),
              subtitle: Text(subtext, style: drawerTextColor),
              iconColor: Colors.white,
              leading: FaIcon(icon, size: 30),
              trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 30),
              onTap: press,
            ),
          ),
        ],
      ),
    );
  }
}

void settingsItem(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddUser(),
        ),
      );
      break;
    case 1:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddUser(),
        ),
      );
      break;
    case 2:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddUser(),
        ),
      );
      break;
    case 3:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddUser(),
        ),
      );
      break;
    case 4:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddPosNumber(),
        ),
      );
      break;
  }
}

class SaleModeTile extends StatefulWidget {
  // ignore: use_super_parameters
  const SaleModeTile({
    Key? key,
    required this.text,
    required this.subtext,
    required this.icon,
  }) : super(key: key);

  final String text;
  final String subtext;
  final IconData icon;

  @override
  State<SaleModeTile> createState() => _SaleModeTileState();
}

class _SaleModeTileState extends State<SaleModeTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            child: ListTile(
              tileColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              title: Text(widget.text, style: drawerTextColor),
              subtitle: Text(widget.subtext, style: drawerTextColor),
              iconColor: Colors.white,
              leading: FaIcon(widget.icon, size: 30),
              trailing: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    const Text(
                      "OFF ",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Switch(
                      value: saleMode,
                      onChanged: (value) {
                        setState(() {
                          Box<SaleMode> saleBox = Box<SaleMode>(store);
                          Query<SaleMode> query2 = saleBox.query().build();
                          List<SaleMode> saleList = query2.find();
                          if (saleList.isNotEmpty) {
                            saleList[0].mode = value;
                            saleBox.put(saleList[0]);
                          } else {
                            saleBox.put(SaleMode(mode: value));
                          }
                          saleMode = value;
                        });
                      },
                    ),
                    const Text(
                      "ON",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
