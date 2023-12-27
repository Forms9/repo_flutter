// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:reporting_app/constants.dart';
// import 'package:reporting_app/util/side_menu.dart';

// class MobileAnalysissPage extends StatelessWidget {
//   const MobileAnalysissPage({super.key});

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
//       body: Center(
//         child: PieChart(
//           PieChartData(
//             sectionsSpace: 0,
//             centerSpaceRadius: 40,
//             sections: [
//               PieChartSectionData(
//                 color: Colors.blue,
//                 value: 40,
//                 title: '40%',
//                 radius: 100,
//                 titleStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xffffffff)),
//               ),
//               PieChartSectionData(
//                 color: Colors.green,
//                 value: 30,
//                 title: '30%',
//                 radius: 80,
//                 titleStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xffffffff)),
//               ),
//               PieChartSectionData(
//                 color: Colors.red,
//                 value: 30,
//                 title: '30%',
//                 radius: 60,
//                 titleStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xffffffff)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
