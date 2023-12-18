import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/util/side_menu.dart';

// ignore: use_key_in_widget_constructors
class SearchSupplier extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SearchSupplierState createState() => _SearchSupplierState();
}

class _SearchSupplierState extends State<SearchSupplier> {
  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();
  // ignore: unused_field
  List<Map<String, dynamic>> _allResults = [];
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _fetchData(String query) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.26:8000/Supplier_api/'),
    );

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> allResults =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      setState(() {
        _allResults = allResults;
        if (query.isNotEmpty) {
          _searchResults = allResults
              .where((result) => result.values.any((value) =>
                  value != null &&
                  value.toString().toLowerCase().contains(query.toLowerCase())))
              .toList();
        } else {
          _searchResults = allResults;
        }
      });
    } else {
      // ignore: avoid_print
      print('Error Response: ${response.body}');
      // ignore: avoid_print
      print('Status Code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          'Search Supplier',
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // ignore: prefer_const_constructors
        backgroundColor: Color(0xFF655B87),
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      // ignore: prefer_const_constructors
      drawer: SideMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 80, right: 80, top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        // ignore: prefer_const_constructors
                        icon: Icon(Icons.search),
                        onPressed: () {
                          String query = _searchController.text;
                          _fetchData(query);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(height: 50),
            // ignore: sized_box_for_whitespace
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: _searchResults.isEmpty
                  // ignore: prefer_const_constructors
                  ? Center(
                      // ignore: prefer_const_constructors
                      child: Text('No results found'),
                    )
                  : DataTable(
                      // ignore: prefer_const_literals_to_create_immutables
                      columns: [
                        // ignore: prefer_const_constructors
                        DataColumn(label: Text('Sr. No')),
                        // ignore: prefer_const_constructors
                        DataColumn(label: Text('Name')),
                        // ignore: prefer_const_constructors
                        DataColumn(label: Text('Supplier Code')),
                        // ignore: prefer_const_constructors
                        DataColumn(label: Text('Contact No.')),
                        // ignore: prefer_const_constructors
                        DataColumn(label: Text('City')),
                      ],
                      rows: _searchResults
                          .asMap()
                          .entries
                          .map(
                            (entry) => DataRow(
                              cells: [
                                DataCell(Text('${entry.key + 1}')),
                                DataCell(Text(entry.value['name'] ?? '')),
                                DataCell(
                                    Text(entry.value['supplier_code'] ?? '')),
                                DataCell(
                                    Text(entry.value['mobile_no_1'] ?? '')),
                                DataCell(Text(entry.value['city'] ?? '')),
                              ],
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';
// import 'package:reporting_app/constants.dart';
// import 'package:reporting_app/models/RecentFile.dart';
// import 'package:reporting_app/screens/dashboard/components/recent_files.dart';

// class SearchSupplier extends StatelessWidget {
//   const SearchSupplier({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Search Supplier',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: bgColor,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         backgroundColor: bgColor,
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: 'Enter Supplier Name',
//                         hintStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.white,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle button press
//                         print('Search!');
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.search,
//                               color: Color.fromARGB(255, 12, 4, 15)),
//                           Text('Search', style: TextStyle(fontSize: 18.0)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Text(
//                 "Recent Files",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color.fromARGB(
//                       255, 44, 47, 68), // Customize the background color
//                 ),
//                 padding: EdgeInsets.all(defaultPadding),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: DataTable(
//                     columnSpacing: defaultPadding,
//                     columns: [
//                       DataColumn(
//                         label: Text("Supplier Name",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                       DataColumn(
//                         label: Text("Supplier Code",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                       DataColumn(
//                         label: Text("Contact",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                       DataColumn(
//                         label: Text("Address",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
//                     rows: List.generate(
//                       demoRecentFiles.length,
//                       (index) => recentFileDataRow(demoRecentFiles[index]),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
