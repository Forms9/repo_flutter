import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:reporting_app/main.dart';

class UpdatePricePage extends StatefulWidget {
  const UpdatePricePage({super.key});

  @override
  State<UpdatePricePage> createState() => _UpdatePricePageState();
}

class _UpdatePricePageState extends State<UpdatePricePage> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Update Price',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: bgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchUsers,
          child: Icon(Icons.refresh),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final inwardNo = user['Inward_no'];
            final supplierNames = user['Supplier_names'];
            final billNumbers = user['Bill_numbers'];

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(billNumbers),
              ),
              title: Text(inwardNo.toString()),
              subtitle: Text(supplierNames),
            );
          },
        ),
      ),
    );
  }

  void fetchUsers() async {
    print('fetchUsers called');
    final url = 'http://$apiURL/pos/load_table_data/';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['table_data'];
    });
    print('fetchUsers completed');
  }
}
