// import 'package:flutter/material.dart';
// import 'package:reporting_app/constants.dart';
// import 'package:reporting_app/screens/dashboard/components/chart.dart';
// import 'package:reporting_app/screens/dashboard/components/storage_info_card.dart';
// import 'package:reporting_app/util/side_menu.dart';

// class TabletAnalysisPage extends StatelessWidget {
//   const TabletAnalysisPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         title: Text(
//           'Analysis',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color(0xFF655B87),
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       drawer: SideMenu(),
//     );
//   }
// }

// class TabletAnalysisPage1 extends StatefulWidget {
//   const TabletAnalysisPage1({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _TabletAnalysisPage1State createState() => _TabletAnalysisPage1State();
// }

// class _TabletAnalysisPage1State extends State<TabletAnalysisPage1> {
//   String selectedDuration = "Today"; // Default selected value

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(defaultPadding),
//       decoration: BoxDecoration(
//         color: secondaryColor,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Analysis",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               DropdownButton<String>(
//                 items: ["Today", "7 days", "30 days", "1 Year"]
//                     .map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedDuration = newValue!;
//                   });
//                 },
//                 value: selectedDuration,
//               ),
//             ],
//           ),
//           SizedBox(height: defaultPadding),
//           Chart(),
//           StorageInfoCard(
//             svgSrc: "assets/icons/Documents.svg",
//             title: selectedDuration,
//             amountOfFiles: "1.3GB",
//             numOfFiles: 1328,
//           ),
//           // Add other StorageInfoCard instances with updated titles based on selectedDuration
//         ],
//       ),
//     );
//   }
// }
