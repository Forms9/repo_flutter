import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:http/http.dart' as http;

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Supplier Name',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ), // Set hint text color to white
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ), // Set border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ), // Set focused border color to white
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    print('Search!');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Color.fromARGB(255, 12, 4, 15)),
                      Text('Search', style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: bgColor,
        floatingActionButton: FloatingActionButton(
          onPressed: fetchUsers,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final name = user['name']['first'];
              final email = user['email'];
              final imageUrl = user['picture']['thumbnail'];

              return ListTile(
                leading:
                    //  CircleAvatar(
                    //   // child: Text('${index + 1}'),
                    // ),
                    ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(imageUrl),
                ),
                title: Text(name.toString()),
                subtitle: Text(email),
              );
            },
          ),
        ),
      ),
    );
  }

  void fetchUsers() async {
    print('fetchUsers called');
    final url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
    });
    print('fetchUsers completed');
  }
}
