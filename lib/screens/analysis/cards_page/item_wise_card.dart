import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reporting_app/constants.dart';

class ItemWise extends StatefulWidget {
  @override
  _ItemWiseState createState() => _ItemWiseState();
}

class _ItemWiseState extends State<ItemWise> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  double grandTotal = 0.0;
  Future<void> _fetchData(String query) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.26:8000/getsales_data_all/$query/'),
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> saleData =
            List<Map<String, dynamic>>.from(json.decode(response.body) ?? []);
        setState(() {
          _searchResults = saleData;
        });
        print('_searchResults: $_searchResults');
        print('API Response: ${response.body}');
      } else if (response.statusCode == 404) {
        setState(() {
          _searchResults = [];
        });
      } else {
        print('Error Response: ${response.body}');
        print('Status Code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double calculateGrandTotal() {
    double total = 0.0;
    for (var saleItem in _searchResults) {
      // Ensure saleItem['rowTotal'] is a valid numeric string before adding
      if (saleItem['rowTotal'] is String) {
        total += double.parse(saleItem['rowTotal']);
      } else if (saleItem['rowTotal'] is num) {
        total += saleItem['rowTotal'];
      }
    }
    return total;
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
                      hintText: 'Search Item',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _fetchData('');
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Text(
              'Grand Total: ${calculateGrandTotal()}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 50),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: (_searchResults.isEmpty)
                  ? Center(
                      child: Text('No results found',
                          style: TextStyle(color: Colors.white)),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final saleItem = _searchResults[index];
                        return Card(
                          child: ListTile(
                            title: Text('Item Name: ${saleItem['headline']}'),
                            subtitle: Text('Total: ${saleItem['rowTotal']}'),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
