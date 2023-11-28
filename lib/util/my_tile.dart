import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:forms9_pos_auth/constant.dart';
// import 'package:forms9_pos_auth/pages/add_pos_number.dart';
// import 'package:forms9_pos_auth/pages/add_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reporting_app/constants.dart';

class MyTile extends StatelessWidget {
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
          tileColor: Colors.grey[100],
          hoverColor: defaultBgAccentColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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
              tileColor: tileSecondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(text, style: drawerTextColor),
              subtitle: Text(subtext, style: drawerTextColor),
              iconColor: defaultIconColor,
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
    // case 0:
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const AddUser(),
    //     ),
    //   );
    //   break;
    // case 1:
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const AddUser(),
    //     ),
    //   );
    //   break;
    // case 2:
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const AddUser(),
    //     ),
    //   );
    //   break;
    // case 3:
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const AddUser(),
    //     ),
    //   );
    //   break;
    // case 4:
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const AddPosNumber(),
    //     ),
    //   );
    //   break;
  }
}
