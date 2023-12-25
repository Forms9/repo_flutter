import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/util/side_menu.dart';

class SearchSupplier extends StatefulWidget {
  @override
  _SearchSupplierState createState() => _SearchSupplierState();
}

class _SearchSupplierState extends State<SearchSupplier> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _fetchData(String query) async {
    final response = await http.get(
      Uri.parse('http://$apiURL/supplier_api/'),
    );

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> allResults =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      setState(() {
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
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Search Supplier',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF655B87),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
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
                    onChanged: (value) {
                      _fetchData(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _fetchData('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text('No results found'),
                    )
                  : ListView(
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(label: Text('Sr. No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Supplier Code')),
                            DataColumn(label: Text('Contact No.')),
                            DataColumn(label: Text('City')),
                          ],
                          rows: _searchResults
                              .asMap()
                              .entries
                              .map(
                                (entry) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        '${entry.key + 1}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        entry.value['name'] ?? '',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        entry.value['supplier_code'] ?? '',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        entry.value['mobile_no_1'] ?? '',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        entry.value['city'] ?? '',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
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
