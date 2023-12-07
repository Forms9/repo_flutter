import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchSupplier extends StatefulWidget {
  @override
  _SearchSupplierState createState() => _SearchSupplierState();
}

class _SearchSupplierState extends State<SearchSupplier> {
  TextEditingController _searchController = TextEditingController();
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
      print('Error Response: ${response.body}');
      print('Status Code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 80, right: 80, top: 50),
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
            SizedBox(height: 50),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text('No results found'),
                    )
                  : DataTable(
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Supplier Code')),
                        DataColumn(label: Text('Contact No.')),
                        DataColumn(label: Text('City')),
                      ],
                      rows: _searchResults
                          .map(
                            (result) => DataRow(
                              cells: [
                                DataCell(Text(result['name'] ?? '')),
                                DataCell(Text(result['supplier_code'] ?? '')),
                                DataCell(Text(result['mobile_no_1'] ?? '')),
                                DataCell(Text(result['city'] ?? '')),
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
