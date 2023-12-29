import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reporting_app/constants.dart';

class PriceWise extends StatefulWidget {
  @override
  _PriceWiseState createState() => _PriceWiseState();
}

class _PriceWiseState extends State<PriceWise> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _fetchData(String query) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.26:8000/saleananalysis_api/'),
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
          'Item Wise',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF655B87),
      ),
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
                                    DataCell(Text(
                                      entry.value['headline'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    DataCell(Text(
                                      entry.value['salenumber'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    DataCell(Text(
                                      entry.value['uniqueNumber'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    DataCell(Text(
                                      entry.value['rowQty'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    DataCell(Text(
                                      entry.value['rowTotal'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white),
                                    )),
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
