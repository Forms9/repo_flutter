// import 'dart:convert';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:reporting_app/constants.dart';
// import 'package:reporting_app/util/side_menu.dart';
// import 'package:http/http.dart' as http;

// class DesktopAnalysis extends StatefulWidget {
//   const DesktopAnalysis({Key? key}) : super(key: key);

//   @override
//   State<DesktopAnalysis> createState() => _DesktopAnalysisState();
// }

// class _DesktopAnalysisState extends State<DesktopAnalysis> {
//   List<Map<String, dynamic>> users = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

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
//       body: ListView.builder(
//         itemCount: users.length + 1,
//         itemBuilder: (context, index) {
//           if (index == users.length) {
//             // Display pie chart with grand totals
//             return Center(
//                 child: Expanded(
//               child: PieChart(
//                 PieChartData(
//                   sectionsSpace: 0,
//                   centerSpaceRadius: 40,
//                   sections: [
//                     PieChartSectionData(
//                       color: Colors.blue,
//                       value: calculateGrandTotal('saleNumber'),
//                       title: 'Sale Number',
//                       radius: 100,
//                       titleStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xffffffff),
//                       ),
//                     ),
//                     PieChartSectionData(
//                       color: Colors.green,
//                       value: calculateGrandTotal('rowTotal'),
//                       title: 'Row Total',
//                       radius: 80,
//                       titleStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xffffffff),
//                       ),
//                     ),
//                     PieChartSectionData(
//                       color: Colors.red,
//                       value: calculateGrandTotal('rowRate'),
//                       title: 'Row Rate',
//                       radius: 60,
//                       titleStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xffffffff),
//                       ),
//                     ),
//                     PieChartSectionData(
//                       color: Colors.orange,
//                       value: calculateGrandTotal('rowQty'),
//                       title: 'Row Quantity',
//                       radius: 40,
//                       titleStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xffffffff),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//           } else {
//             // Display individual user data
//             final user = users[index];
//             final name = user['uniqueNumber'].toString();
//             final saleNumber = user['salenumber'].toString();
//             final rowTotal = user['rowTotal'].toString();
//             final rowRate = user['rowRate'].toString();
//             final rowQty = user['rowQty'].toString();

//             return ListTile(
//               title: Text(name),
//               textColor: Colors.white,
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Sale Number: $saleNumber'),
//                   Text('Row Total: $rowTotal'),
//                   Text('Row Rate: $rowRate'),
//                   Text('Row Quantity: $rowQty'),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   double calculateGrandTotal(String field) {
//     return users
//         .map((user) => user[field] is double
//             ? user[field]
//             : double.tryParse(user[field]!.toString()) ?? 0.0)
//         .fold(0.0, (previousValue, element) => previousValue + element);
//   }

//   void fetchUsers() async {
//     print('fetchUsers called');
//     final url = 'http://192.168.1.26:8000/saleananalysis_api';
//     final uri = Uri.parse(url);

//     try {
//       final response = await http.get(uri);

//       print('Content-Type: ${response.headers['content-type']}');
//       if (response.statusCode == 200) {
//         final body = response.body;
//         final dynamic json = jsonDecode(body.toString());

//         if (json is List) {
//           setState(() {
//             users = json.cast<Map<String, dynamic>>();
//           });
//         } else if (json is Map && json.containsKey('results')) {
//           final results = json['results'];

//           if (results is List) {
//             setState(() {
//               users = results.cast<Map<String, dynamic>>();
//             });
//           } else {
//             print('Invalid structure: "results" is not a List');
//           }
//         } else {
//           print('Invalid structure: No "results" key found');
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Error during HTTP request: $e');
//     }

//     print('fetchUsers completed');
//   }
// }
