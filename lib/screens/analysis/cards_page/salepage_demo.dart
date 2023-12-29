import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reporting_app/constants.dart';

class Sale {
  final int id;
  final String saleNumber;
  final String uniqueNumber;
  final String storeName;
  final String salesCreatedDate;
  final String saleTotal;
  final String saleDiscount;
  final String saleCard;
  final String saleCash;
  final String salePoints;
  final String saleBalance;
  final bool isNotExchange;
  final List<Map<String, dynamic>> sale;

  Sale({
    required this.id,
    required this.saleNumber,
    required this.uniqueNumber,
    required this.storeName,
    required this.salesCreatedDate,
    required this.saleTotal,
    required this.saleDiscount,
    required this.saleCard,
    required this.saleCash,
    required this.salePoints,
    required this.saleBalance,
    required this.isNotExchange,
    required this.sale,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      saleNumber: json['saleNumber'],
      uniqueNumber: json['uniqueNumber'] ?? '',
      storeName: json['storeName'],
      salesCreatedDate: json['salesCreatedDate'],
      saleTotal: json['saleTotal'],
      saleDiscount: json['saleDiscount'],
      saleCard: json['saleCard'],
      saleCash: json['saleCash'],
      salePoints: json['salePoints'],
      saleBalance: json['saleBalance'],
      isNotExchange: json['isNotExchange'] is String
          ? (json['isNotExchange'].toLowerCase() == 'true')
          : json['isNotExchange'],
      sale: List<Map<String, dynamic>>.from(json['sale']),
    );
  }
}

class ItemWise extends StatefulWidget {
  @override
  _ItemWiseState createState() => _ItemWiseState();
}

class _ItemWiseState extends State<ItemWise> {
  List<Sale> sales = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.26:8000/getsales_data_all'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        sales = jsonData.map((data) => Sale.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Sale Number', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label:
                  Text('Unique Number', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Headline', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Row Qty', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Row Total', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Row Rate', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Store Name', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Sale Total', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label:
                  Text('Sale Discount', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Sale Card', style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text('Sale Cash', style: TextStyle(color: Colors.white)),
            ),
          ],
          rows: sales
              .expand(
                (sale) => sale.sale.map(
                  (item) => DataRow(
                    cells: [
                      DataCell(
                        Text(sale.saleNumber,
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(item['fields']['uniqueNumber'] ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(item['fields']['headline'] ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(item['fields']['rowQty'] ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(item['fields']['rowTotal']?.toString() ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(item['fields']['rowRate']?.toString() ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(sale.storeName,
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(sale.saleTotal.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(sale.saleDiscount.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(sale.saleCard.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Text(sale.saleCash.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
