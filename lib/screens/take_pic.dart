import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:reporting_app/main.dart';
import 'package:reporting_app/screens/main/components/side_menu.dart';

class TakePicPage extends StatefulWidget {
  const TakePicPage({super.key});

  @override
  State<TakePicPage> createState() => _TakePicPageState();
}

class _TakePicPageState extends State<TakePicPage> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Take Price',
          ),
          backgroundColor: kPrimaryLightColor,
        ),
        drawer: SideMenu(),
        backgroundColor: bgColor,
        floatingActionButton: FloatingActionButton(
          onPressed: fetchUsers,
          child: Icon(Icons.refresh),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Your other widgets can go here before the ListView.builder if needed.

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final inwardNo = user['Inward_no'];
                  final supplierNames = user['Supplier_names'];
                  // final billNumbers = user['Bill_numbers'];

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(inwardNo.toString()),
                    subtitle: Text(supplierNames),
                  );
                },
              ),
            ],
          ),
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
