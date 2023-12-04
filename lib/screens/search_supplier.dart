import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/models/RecentFile.dart';
import 'package:reporting_app/screens/dashboard/components/recent_files.dart';

class SearchSupplier extends StatelessWidget {
  const SearchSupplier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search Supplier',
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
        backgroundColor: bgColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        // Handle button press
                        print('Search!');
                      },
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: Color.fromARGB(255, 12, 4, 15)),
                          Text('Search', style: TextStyle(fontSize: 18.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Recent Files",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(
                      255, 44, 47, 68), // Customize the background color
                ),
                padding: EdgeInsets.all(defaultPadding),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(
                        label: Text("Supplier Name",
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text("Supplier Code",
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text("Contact",
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text("Address",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    rows: List.generate(
                      demoRecentFiles.length,
                      (index) => recentFileDataRow(demoRecentFiles[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
