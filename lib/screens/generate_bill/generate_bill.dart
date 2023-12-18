import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/objectbox.g.dart';
import 'package:reporting_app/responsive.dart';
// ignore: unused_import
import 'package:reporting_app/screens/generate_bill/desktop_generate_bill.dart';
import 'package:reporting_app/screens/generate_bill/mobile_generate_bill.dart';
import 'package:reporting_app/screens/generate_bill/tablet_generate_bill.dart';

class GenerateBill extends StatefulWidget {
  // ignore: use_super_parameters
  const GenerateBill({Key? key}) : super(key: key);

  @override
  State<GenerateBill> createState() => _GenerateBillState();
}

updateSaleData() async {
  try {
    log("Updating sales up to server");

    List productDatas = List.empty(growable: true);
    Box<SaleNumberData> recentSalesBox = Box<SaleNumberData>(store);
    Query<SaleNumberData> queryNumbers = recentSalesBox.query().build();
    List<SaleNumberData> numbers = queryNumbers.find();

    Box<SaleData> salesBox = Box<SaleData>(store);

    if (numbers.isEmpty) {
      log("no new sales to update");
      return;
    }

    for (SaleNumberData x in numbers) {
      Query<SaleData> query =
          salesBox.query(SaleData_.saleNumber.equals(x.saleNumber)).build();
      List<SaleData> sale = query.find();
      query.close();
      if (sale.isNotEmpty) {
        productDatas.add(sale[0]);
      }
    }

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://$apiURL/push_sales_data'));
    request.body =
        json.encode({"mac_id": displayDeviceId, "product_data": productDatas});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      queryNumbers.remove();
    } else {
      log(response.reasonPhrase.toString());
    }
  } catch (e) {
    log(e.toString());
  }
}

GlobalKey<ScaffoldState> pageKey = GlobalKey<ScaffoldState>();

class _GenerateBillState extends State<GenerateBill> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const Responsive(
        mobile: MobileGenerateBillPage(),
        tablet: TabletGenerateBillPage(),
        desktop: TabletGenerateBillPage(),
      ),
    );
  }
}
