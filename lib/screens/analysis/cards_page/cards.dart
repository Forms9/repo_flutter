import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/screens/analysis/cards_page/city_wise_card.dart';
import 'package:reporting_app/screens/analysis/cards_page/item_wise_card.dart';
import 'package:reporting_app/screens/analysis/cards_page/price_wise_card.dart';
import 'package:reporting_app/screens/analysis/cards_page/supplier_wise_card.dart';
import 'package:reporting_app/util/side_menu.dart';

class CardAnalysis extends StatelessWidget {
  const CardAnalysis({
    Key? key,
  }) : super(key: key);

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Analysis',
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Color(0xFF655B87),
              child: SizedBox(
                width: 250,
                height: 150,
                child: InkWell(
                  splashColor: Colors.grey,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ItemWise()));
                  },
                  child: Center(
                    child: Text(
                      'Item Wise',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Card(
              color: Color(0xFF655B87),
              child: SizedBox(
                width: 250,
                height: 150,
                child: InkWell(
                  splashColor: Colors.grey,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PriceWise()));
                  },
                  child: Center(
                    child: Text('Price Wise',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Card(
              color: Color(0xFF655B87),
              child: SizedBox(
                width: 250,
                height: 150,
                child: InkWell(
                  splashColor: Colors.grey,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SupplierWise()));
                  },
                  child: Center(
                    child: Text(
                      'Supplier Wise',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Card(
              color: Color(0xFF655B87),
              child: SizedBox(
                width: 250,
                height: 150,
                child: InkWell(
                  splashColor: Colors.grey,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CityWise()));
                  },
                  child: Center(
                    child: Text(
                      'City Wise',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
