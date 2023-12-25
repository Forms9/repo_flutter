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
          title: Text(
            'Search Barcode',
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
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Supplier Name',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
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
      ),
    );
  }
}
