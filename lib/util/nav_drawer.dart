// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:reporting_app/constants.dart';
// import 'package:reporting_app/screens/main/main_screen.dart';
// // import 'package:forms9_pos_auth/constant.dart';
// // import 'package:forms9_pos_auth/pages/dashboard.dart';
// // import 'package:forms9_pos_auth/pages/generate_bill.dart';
// // import 'package:forms9_pos_auth/pages/login.dart';
// // import 'package:forms9_pos_auth/pages/recent_bills.dart';
// // import 'package:forms9_pos_auth/pages/scan_barcode.dart';
// // import 'package:forms9_pos_auth/pages/search_product.dart';
// // import 'package:forms9_pos_auth/pages/settings.dart';
// // import 'package:forms9_pos_auth/pages/update_price.dart';

// import '../database.dart';
// import '../main.dart';

// class NavigationDrawer extends StatelessWidget {
//   const NavigationDrawer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Drawer(
//         backgroundColor: defaultBackgroundColor,
//         width: 275,
//         elevation: 0,
//         child: ListView(
//           controller: ScrollController(),
//           children: [
//             // connectionWidget,
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/logo.png'),
//                   fit: BoxFit.contain,
//                   alignment: Alignment.center,
//                 ),
//               ),
//               child: Text('Version 1.0.0'),
//             ),
//             DrawerListTile(
//               text: 'Dashboard',
//               icon: FontAwesomeIcons.house,
//               press: () => selectedItem(context, 0),
//             ),
//             DrawerListTile(
//               text: 'Generate Bill',
//               icon: FontAwesomeIcons.fileCirclePlus,
//               press: () => selectedItem(context, 1),
//             ),
//             // DrawerListTile(
//             //   text: 'Returns',
//             //   icon: FontAwesomeIcons.arrowRightArrowLeft,
//             //   press: () => selectedItem(context, 2),
//             // ),
//             if (!(Platform.isAndroid || Platform.isIOS) && cUser.type != "USER")
//               DrawerListTile(
//                 text: 'Search Product',
//                 icon: FontAwesomeIcons.magnifyingGlass,
//                 press: () => selectedItem(context, 3),
//               ),
//             DrawerListTile(
//               text: 'Recent Bills',
//               icon: FontAwesomeIcons.fileInvoice,
//               press: () => selectedItem(context, 4),
//             ),
//             DrawerListTile(
//               text: 'Update Prices',
//               icon: FontAwesomeIcons.tags,
//               press: () => selectedItem(context, 8),
//             ),
//             if ((Platform.isAndroid || Platform.isIOS) && cUser.type != "USER")
//               DrawerListTile(
//                 text: 'Scan Barcode',
//                 icon: FontAwesomeIcons.barcode,
//                 press: () => selectedItem(context, 5),
//               ),
//             // if (cUser.type != "USER")
//             //   DrawerListTile(
//             //     text: 'Statistics',
//             //     icon: FontAwesomeIcons.chartLine,
//             //     press: () => selectedItem(context, 0),
//             //   ),
//             if (cUser.type != "USER")
//               DrawerListTile(
//                 text: 'Settings',
//                 icon: FontAwesomeIcons.gear,
//                 press: () => selectedItem(context, 6),
//               ),
//             DrawerListTile(
//               text: 'Sign Out',
//               icon: FontAwesomeIcons.rightFromBracket,
//               press: () => selectedItem(context, 7),
//             ),
//             const SizedBox(
//               height: 40,
//               width: double.infinity,
//               child: ColoredBox(color: Colors.white),
//             ),
//             //Text(displayDeviceId),
//           ],
//         ),
//       );
// }

// class DrawerListTile extends StatelessWidget {
//   const DrawerListTile({
//     Key? key,
//     required this.text,
//     required this.icon,
//     required this.press,
//   }) : super(key: key);

//   final String text;
//   final IconData icon;
//   final VoidCallback? press;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: tilePadding,
//       child: ListTile(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         iconColor: defaultIconColor,
//         leading: FaIcon(icon),
//         title: Text(
//           text,
//           style: drawerTextColor,
//         ),
//         onTap: press,
//       ),
//     );
//   }
// }

// //GlobalKey<ScaffoldState> pageKey = GlobalKey<ScaffoldState>();

// void selectedItem(BuildContext context, int index) {
//   Navigator.of(context).pop();

//   switch (index) {
//     case 0:
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => MainScreen(),
//         ),
//       );
//       break;
//       // case 1:
//       //   Navigator.of(context).push(
//       //     MaterialPageRoute(
//       //       builder: (context) => const GenerateBill(),
//       //     ),
//       // );
//       // Navigator.pushAndRemoveUntil(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (context) => const GenerateBill(),
//       //       maintainState: true,
//       //     ),
//       //     (route) => false);
//       break;
//     case 2:
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => MainScreen(),
//         ),
//       );
//       break;
//       // case 3:
//       //   Navigator.of(context).push(
//       //     MaterialPageRoute(
//       //       builder: (context) => const SearchProduct(),
//       //     ),
//       //   );
//       break;
//     case 4:
//       // Navigator.of(context).push(
//       //   MaterialPageRoute(
//       //     builder: (context) => const RecentBills(),
//       //   ),
//       // );
//       break;
//     case 5:
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const ScanBarcodePage(),
//         ),
//       );
//       break;
//     case 6:
//       log("Reached Settings");
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const SettingsPage(),
//         ),
//       );
//       break;
//     case 7:
//       User user = User(username: "", password: "", type: " ", store: "");
//       cUser = user;
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const LoginPage(),
//         ),
//       );
//       break;
//     // case 8:
//     //   Navigator.of(context).push(
//     //     MaterialPageRoute(
//     //       builder: (context) => const UpdatePrice(),
//     //     ),
//     //   );
//   }
// }
