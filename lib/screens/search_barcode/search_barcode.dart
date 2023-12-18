import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';

class SearchBarcode extends StatelessWidget {
  const SearchBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text(
            'Search Barcode',
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: bgColor,
          leading: IconButton(
            // ignore: prefer_const_constructors
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
              // ignore: prefer_const_constructors
              Expanded(
                // ignore: prefer_const_constructors
                child: TextField(
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    hintText: 'Enter Supplier Name',
                    // ignore: prefer_const_constructors
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ), // Set hint text color to white
                    // ignore: prefer_const_constructors
                    enabledBorder: OutlineInputBorder(
                      // ignore: prefer_const_constructors
                      borderSide: BorderSide(
                        color: Colors.white,
                      ), // Set border color to white
                    ),
                    // ignore: prefer_const_constructors
                    focusedBorder: OutlineInputBorder(
                      // ignore: prefer_const_constructors
                      borderSide: BorderSide(
                        color: Colors.white,
                      ), // Set focused border color to white
                    ),
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(width: 8),
              Padding(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    // ignore: avoid_print
                    print('Search!');
                  },
                  // ignore: prefer_const_constructors
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      // ignore: prefer_const_constructors
                      Icon(Icons.search, color: Color.fromARGB(255, 12, 4, 15)),
                      // ignore: prefer_const_constructors
                      Text('Search', style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: bgColor,
      ),
    );
  }
}
