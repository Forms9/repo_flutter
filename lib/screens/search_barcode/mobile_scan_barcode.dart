import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/util/side_menu.dart';
import 'package:stringr/stringr.dart';

class MobileScanBarcodePage extends StatefulWidget {
  // ignore: use_super_parameters
  const MobileScanBarcodePage({Key? key}) : super(key: key);

  @override
  State<MobileScanBarcodePage> createState() => _MobileScanBarcodePageState();
}

class _MobileScanBarcodePageState extends State<MobileScanBarcodePage> {
  String barcode = 'Aim at barcode to scan';
  final search = TextEditingController();
  bool notFound = false;

  String productName = "";
  String supplierName = "";
  String quantity = "";
  String price = "";
  String calculation = "";
  String cost = "";
  String dateIn = "";

  Future<void> getDataByBarcode() async {
    if (search.text.isEmpty || search.text == "") {
      return;
    }
    notFound = false;
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('http://$apiURL/fetch_by_barcode'));
    request.body = json.encode(
        {"mac_id": displayDeviceId, "barcode": search.text.toUpperCase()});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if (data.toString().contains("Not Found") ||
          data.toString().contains("403")) {
        notFound = true;
        productName = "";
        supplierName = "";
        quantity = "";
        price = "";
        calculation = "";
        cost = "";
        dateIn = "";
        setState(() {});
        return;
      }
      var jsonData = json.decode(data);
      var productData = json.decode(jsonData["Product_Data"]);
      productName = productData[0]["Product_name"];
      supplierName = productData[0]["supplier"];
      quantity = productData[0]["packed_quantity"].toString();
      price = productData[0]["Cipher"].toString();
      calculation = productData[0]["Calculation"].toString();
      cost = productData[0]["Rate"].toString();
      dateIn = DateFormat('dd/MM/yyyy')
          .format(DateTime.parse(productData[0]["created_date"].toString()));
      setState(() {});
    } else {
      log(response.reasonPhrase!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          'Scan Barcode',
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // ignore: prefer_const_constructors
        backgroundColor: Color(0xFF655B87),
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      // ignore: prefer_const_constructors
      drawer: SideMenu(),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 175,
                    child: MobileScanner(
                      fit: BoxFit.cover,
                      onDetect: (barcode) {
                        MobileScannerArguments(
                          size: Size.fromWidth(
                            MediaQuery.of(context).size.width,
                          ),
                          hasTorch: false,
                        );
                        HapticFeedback.vibrate();
                        log(
                          barcode.toString(),
                        );
                        String value = barcode.toString();
                        if (value.isNotEmpty &&
                            value.length == 8 &&
                            value.countWhere(
                                    (character) => character.isAlphabet()) ==
                                2) {
                          if (search.text != value) {
                            search.text = value;
                            getDataByBarcode();
                          }
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 95,
                    color: defaultBgAccentColor,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: search,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 15,
                            color: Colors.grey,
                          ),
                          hintText: 'Enter Barcode Number',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSubmitted: (value) => {getDataByBarcode()},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              left: 5,
                              right: 5,
                            ),
                            // ignore: deprecated_member_use
                            primary: defaultAccentColor),
                        onPressed: () => {getDataByBarcode()},
                        child: const FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromARGB(110, 244, 67, 54),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Barcode Not Found",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Product Name : ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      Text(
                        productName,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Supplier Name : ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      Text(
                        supplierName,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Quantity : ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      Text(
                        quantity,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Cipher : ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Calculation : ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      Text(
                        calculation,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Cost : ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      Text(
                        cost,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !notFound,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Date In : ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      Text(
                        dateIn,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
