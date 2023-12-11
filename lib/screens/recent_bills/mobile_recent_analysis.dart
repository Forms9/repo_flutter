import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/objectbox.g.dart';
import 'package:reporting_app/util/side_menu.dart';

class MobileRecentBillsPage extends StatefulWidget {
  const MobileRecentBillsPage({Key? key}) : super(key: key);

  @override
  State<MobileRecentBillsPage> createState() => _MobileRecentBillsPageState();
}

class _MobileRecentBillsPageState extends State<MobileRecentBillsPage> {
  late List<SaleData> recentSales;

  TextEditingController saleNumber = TextEditingController();
  TextEditingController productNumber = TextEditingController();
  @override
  void initState() {
    super.initState();
    Box<SaleData> salebox = Box<SaleData>(store);
    Query<SaleData> query = salebox.query().build();
    recentSales = query.find().reversed.toList();
    query.close();
  }

  void query() {
    Box<SaleData> salebox = Box<SaleData>(store);
    if (saleNumber.text.isEmpty) {
      Query<SaleData> query = salebox.query().build();
      recentSales = query.find().toList();
      List<SaleData> finalSales = List.empty(growable: true);
      for (SaleData s in recentSales) {
        for (String g in s.data) {
          if (g.contains(productNumber.text.toUpperCase())) {
            finalSales.add(s);
            break;
          }
        }
      }
      recentSales = finalSales;
    } else if (productNumber.text.isEmpty) {
      Query<SaleData> query = salebox
          .query(SaleData_.saleNumber.contains(saleNumber.text.toUpperCase()))
          .build();
      recentSales = query.find().toList();
    } else {
      Query<SaleData> query = salebox
          .query(SaleData_.saleNumber.contains(saleNumber.text.toUpperCase()))
          .build();
      recentSales = query.find().toList();
      List<SaleData> finalSales = List.empty(growable: true);
      for (SaleData s in recentSales) {
        for (String g in s.data) {
          if (g.contains(productNumber.text.toUpperCase())) {
            finalSales.add(s);
            break;
          }
        }
      }
      recentSales = finalSales;
    }

    setState(() {});
  }

  Future<bool> disableBackPressed() async {
    return false;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Recent Bills',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: defaultTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: TextField(
                            controller: saleNumber,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: 15,
                                color: Colors.grey,
                              ),
                              hintText: 'Enter Bill Number',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onSubmitted: (value) => {query()},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: TextField(
                            controller: productNumber,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: 15,
                                color: Colors.grey,
                              ),
                              hintText: 'Enter Product Number',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onSubmitted: (value) => {query()},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(18),
                                primary: defaultAccentColor),
                            onPressed: () => {query()},
                            label: const Text("SEARCH"),
                            icon: const FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //color: Colors.white,
                    child: Expanded(
                      child: ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: recentSales.length,
                        itemBuilder: (context, index) {
                          return RecentBillsTile(
                            title: recentSales[index].saleNumber,
                            subtitle:
                                formatBill(recentSales[index].data.join("---")),
                            billdate:
                                "${DateFormat("dd/MM/yy").format(recentSales[index].saleCreatedDate)} ${recentSales[index].saleCreatedDate.hour}:${recentSales[index].saleCreatedDate.minute}",
                            billtotal: double.parse(
                                        recentSales[index].saleTotal) <
                                    0
                                ? "-£${(double.parse(recentSales[index].saleTotal) * -1).toStringAsFixed(2)}"
                                : "£${double.parse(recentSales[index].saleTotal).toStringAsFixed(2)}",
                            billdistotal: (double.parse(
                                            recentSales[index].saleTotal) -
                                        double.parse(
                                            recentSales[index].saleDiscount)) >=
                                    0
                                ? "£${(double.parse(recentSales[index].saleTotal) - double.parse(recentSales[index].saleDiscount)).toStringAsFixed(2)}"
                                : "-£${((double.parse(recentSales[index].saleTotal) - double.parse(recentSales[index].saleDiscount)) * -1).toStringAsFixed(2)}",
                            press: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatBill(String data) {
  String formattedData = "";
  List<String> split = data.split("---");
  for (String x in split) {
    String s = "";
    List<String> split = x.split(",");
    s += split[0];
    s += "         ";
    s += split[1];
    for (int i = 0; i < 20 - split[1].length; i++) {
      s += " ";
    }
    s += "QTY : ${split[2]}";
    s += "         ";
    if (double.parse(split[3]) >= 0) {
      s += "RATE : £${split[3]}";
    } else {
      s += "RATE : -£${(double.parse(split[3]) * -1).toStringAsFixed(2)}";
    }
    s += "         ";
    if (double.parse(split[4]) >= 0) {
      s += "TOTAL : £${split[4]}";
    } else {
      s += "TOTAL : -£${(double.parse(split[4]) * -1).toStringAsFixed(2)}";
    }

    s += "\n";
    formattedData += s;
  }
  return formattedData;
}

class RecentBillsTile extends StatelessWidget {
  const RecentBillsTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.billdate,
    required this.billtotal,
    required this.billdistotal,
    required this.press,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String billdate;
  final String billtotal;
  final String billdistotal;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding,
      child: Material(
        child: ListTile(
          tileColor: Colors.grey[100],
          hoverColor: defaultBgAccentColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.grey, width: 1)),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Bill Number : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Text(
                        billdate,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10,
                  color: defaultTextColor,
                  thickness: 1,
                  endIndent: 10,
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: TextStyle(fontSize: 12)),
                Row(
                  children: [
                    Text(
                      "Bill Total : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      billtotal,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Discounted Bill Total : ",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      billdistotal,
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: press,
        ),
      ),
    );
  }
}
