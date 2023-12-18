// ignore: unused_import
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:reporting_app/objectbox.g.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyBox extends StatelessWidget {
  // ignore: use_super_parameters
  const MyBox({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconSize,
    required this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final double iconSize;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: press,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: tileSecondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        icon,
                        size: iconSize,
                        color: defaultTextColor,
                      ),
                      const SizedBox(height: 10),
                      Text(text, style: drawerTextColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// void quickAccessMenuItem(BuildContext context, int index) {
//   switch (index) {
//     case 0:
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const GenerateBill(),
//         ),
//       );
//       break;
//     case 1:
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const Dashboard(),
//         ),
//       );
//       break;
//     case 2:
//       if (Platform.isAndroid || Platform.isIOS) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => const ScanBarcodePage(),
//           ),
//         );
//       } else {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => const SearchProduct(),
//           ),
//         );
//       }
//       break;
//     case 3:
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const RecentBills(),
//         ),
//       );
//       break;
//   }
// }

// Store Box
class StoreBox extends StatelessWidget {
  // ignore: use_super_parameters
  const StoreBox({
    Key? key,
    required this.text,
    required this.primaryColor,
    required this.secondaryColor,
    required this.image,
    required this.press,
    // required Icon icon,
    // required Row child,
  }) : super(key: key);

  final String text;
  final Color primaryColor;
  final Color secondaryColor;
  final AssetImage image;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: secondaryColor,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: press,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 0),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(188, 255, 255, 255),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        text.substring(0, 1).toUpperCase(),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          color: const Color.fromARGB(255, 61, 61,
                              61), // Change the color to your desired color
                        ),
                      ),
                    ),
                  ),
                  // child: Text(text, style: TextStyle(color: defaultTextColor)),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 23,
                    child: Text(
                      text,
                      style:
                          // ignore: prefer_const_constructors
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Daily Sales Data
late String saleDate;
late double cashSale;
late double cardSale;
late double pointsSale;
late double totalDailySale;
late List<DailySalesData> _dailySalesChartData;
late TooltipBehavior _dailySalesTooltipBehavior;

class DailySaleBox extends StatefulWidget {
  // ignore: use_super_parameters
  const DailySaleBox({
    Key? key,
  }) : super(key: key);

  @override
  State<DailySaleBox> createState() => _DailySaleBoxState();
}

class _DailySaleBoxState extends State<DailySaleBox> {
  bool _isObscure = true;
  var tableHeaders = [
    'Bill Number',
    'Total Value',
    'Discounted Total',
    'Payment Method',
  ];

  @override
  void initState() {
    super.initState();
    Box<DailySaleData> todays = Box<DailySaleData>(store);
    Query<DailySaleData> query = todays.query().build();
    List<DailySaleData> todaysSale = query.find().reversed.toList();

    DateTime now = DateTime.now();
    // ignore: unused_local_variable
    DateTime date = DateTime(now.year, now.month, now.day);

    if (todaysSale.isEmpty) {
      cashSale = 0;
      cardSale = 0;
      pointsSale = 0;
      saleDate = DateFormat("dd/MM/yy").format(now);
    } else {
      cashSale = todaysSale[0].saleCash;
      cardSale = todaysSale[0].saleCard;
      pointsSale = todaysSale[0].salePoints;
      saleDate = DateFormat("dd/MM/yy").format(todaysSale[0].saleCreatedDate);
    }

    totalDailySale = cashSale + cardSale + pointsSale;
    _dailySalesChartData = getDailySalesChartData();
    _dailySalesTooltipBehavior = TooltipBehavior(enable: true);
  }

  Future<void> printSimple() async {
    Box<DailySaleData> todays = Box<DailySaleData>(store);
    Query<DailySaleData> query2 = todays.query().build();
    List<DailySaleData> todaysSale = query2.find().reversed.toList();
    query2.close();
    final doc = pw.Document();
    Box<SaleData> salebox = Box<SaleData>(store);
    Query<SaleData> query = salebox
        .query(SaleData_.saleCreatedDate.greaterThan(
            todaysSale[0].saleCreatedDate.millisecondsSinceEpoch - 1))
        .build();
    List temp = query.find().toList();
    if (temp.isEmpty) {
      return;
    }
    dev.log(temp[0].saleCreatedDate.toString());
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.poppinsRegular(),
            italic: await PdfGoogleFonts.poppinsItalic(),
            bold: await PdfGoogleFonts.poppinsBold(),
          ),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              margin: const pw.EdgeInsets.all(0),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: .5),
              ),
            ),
          ),
          margin: const pw.EdgeInsets.all(20),
        ),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(
                fontSize: 8,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(text: "DAY END - SIMPLE SUMMARY", level: 0),
          pw.Row(
            children: [
              pw.Text('Username : ${cUser.username}'),
              pw.Spacer(),
              pw.Text('POS Terminal : $storeType $terminal'),
              pw.Spacer(),
              pw.Text(
                  'Time : ${DateFormat("dd/MM/yy HH:mm").format(DateTime.now())}'),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Header(text: 'DAILY SALES', level: 1),
          pw.Row(
            children: [
              pw.Text('Cash : £${cashSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Card : £${cardSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Points : £${pointsSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text(
                  'Total : £${(cashSale + cardSale + pointsSale).toStringAsFixed(2)}'),
            ],
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            // ignore: deprecated_member_use
            child: pw.Table.fromTextArray(
              border: null,
              cellAlignment: pw.Alignment.center,
              headerDecoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                color: PdfColors.white,
              ),
              headerHeight: 20,
              cellHeight: 20,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft
              },
              headerStyle: pw.TextStyle(
                color: PdfColors.black,
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(
                color: PdfColors.black,
                fontSize: 8,
              ),
              headerCellDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: .5,
                  ),
                ),
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: .5,
                  ),
                ),
              ),
              headers: List<String>.generate(
                tableHeaders.length,
                (col) => tableHeaders[col],
              ),
              data: List<List<String>>.generate(
                temp.length,
                (row) => List<String>.generate(
                  tableHeaders.length,
                  (col) => temp[row].getIndex(col),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    await Printing.directPrintPdf(
        printer: Printer(
          url: printerName,
        ),
        onLayout: (PdfPageFormat format) async => doc.save());
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

  Future<void> printDetailed() async {
    Box<DailySaleData> todays = Box<DailySaleData>(store);
    Query<DailySaleData> query2 = todays.query().build();
    List<DailySaleData> todaysSale = query2.find().reversed.toList();
    query2.close();
    final doc = pw.Document();
    Box<SaleData> salebox = Box<SaleData>(store);
    Query<SaleData> query = salebox
        .query(SaleData_.saleCreatedDate.greaterThan(
            todaysSale[0].saleCreatedDate.millisecondsSinceEpoch - 1))
        .build();
    List<SaleData> temp = query.find().toList();
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.poppinsRegular(),
            italic: await PdfGoogleFonts.poppinsItalic(),
            bold: await PdfGoogleFonts.poppinsBold(),
          ),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              margin: const pw.EdgeInsets.all(0),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: .5),
              ),
            ),
          ),
        ),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(
                fontSize: 8,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(text: "DAY END - DETAILED SUMMARY", level: 0),
          pw.Row(
            children: [
              pw.Text('Username : ${cUser.username}'),
              pw.Spacer(),
              pw.Text('POS Terminal : $storeType $terminal'),
              pw.Spacer(),
              pw.Text(
                  'Time : ${DateFormat("dd/MM/yy HH:mm").format(DateTime.now())}'),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Header(text: 'DAILY SALES', level: 1),
          pw.Row(
            children: [
              pw.Text('Cash : £${cashSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Card : £${cardSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Points : £${pointsSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text(
                  'Total : £${(cashSale + cardSale + pointsSale).toStringAsFixed(2)}'),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.ListView.builder(
            itemBuilder: (context, index) {
              return pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: .5),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Bill Number : ",
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.Text(
                                  temp[index].saleNumber,
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding:
                                      const pw.EdgeInsets.only(right: 65.0),
                                  child: pw.Text(
                                    "${DateFormat("dd/MM/yy").format(temp[index].saleCreatedDate)}   ${temp[index].saleCreatedDate.hour}:${temp[index].saleCreatedDate.minute}",
                                    style: const pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Divider(
                                height: 10,
                                color: PdfColors.black,
                                thickness: 1,
                                endIndent: 50),
                            pw.Text(
                              textAlign: pw.TextAlign.left,
                              formatBill(temp[index].data.join("---")),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              textAlign: pw.TextAlign.right,
                              "Bill Total : £${double.parse(temp[index].saleTotal).toStringAsFixed(2)}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 10,
                              ),
                            ),
                            pw.Text(
                              textAlign: pw.TextAlign.right,
                              "Disc. Bill Total : £${(double.parse(temp[index].saleTotal) - double.parse(temp[index].saleDiscount)).toStringAsFixed(2)}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 10,
                              ),
                            ),
                            pw.Text(
                              textAlign: pw.TextAlign.right,
                              "Mode : ${temp[index].getIndex(3)}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: temp.length,
          ),
        ],
      ),
    );
    await Printing.directPrintPdf(
      printer: Printer(
        url: printerName,
      ),
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 680,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: tileSecondaryColor,
          border: Border.all(
            color: Colors.grey, //color of border
            width: 1, //width of border
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Daily Sale - ',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: defaultTextColor,
                    ),
                  ),
                  Text(
                    saleDate,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: defaultTextColor,
                    ),
                  ),
                  const Spacer(),
                  SizedBox.fromSize(
                    size: const Size(36, 36),
                    child: ClipOval(
                      child: Material(
                        color: tileSecondaryColor,
                        child: InkWell(
                          splashColor: tilePrimaryColor,
                          onTap: () async {
                            final ok = await showTextAnswerDialog(
                              context: context,
                              autoSubmit: true,
                              title: 'User Authentication',
                              message:
                                  'Please authenticate yourself to access this information.',
                              keyword: '2809',
                              hintText: 'Enter PIN',
                              retryTitle: 'Incorrect PIN',
                              retryMessage: 'Please try again.',
                              builder: (context, child) => Theme(
                                data: ThemeData(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: defaultBackgroundColor,
                                      textStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: defaultAccentColor,
                                    ),
                                  ),
                                ),
                                child: child,
                              ),
                            );
                            if (ok) {
                              setState(
                                () {
                                  _isObscure = !_isObscure;
                                },
                              );
                            }
                          },
                          child: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                height: 10,
                color: defaultTextColor,
                thickness: 1,
              ),
              Stack(children: [
                Column(
                  children: [
                    SfCircularChart(
                      tooltipBehavior: _dailySalesTooltipBehavior,
                      palette: pieChartColorPalette,
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        position: LegendPosition.top,
                      ),
                      series: <CircularSeries>[
                        RadialBarSeries<DailySalesData, String>(
                          useSeriesColor: true,
                          trackOpacity: 0.3,
                          gap: '7%',
                          cornerStyle: CornerStyle.bothCurve,
                          dataSource: _dailySalesChartData,
                          xValueMapper: (DailySalesData data, _) =>
                              data.paymentMethod,
                          yValueMapper: (DailySalesData data, _) =>
                              data.dailySaleAmount,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                          enableTooltip: true,
                          maximumValue:
                              max(pointsSale, max(cashSale, cardSale)) *
                                  (4 / 3),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'CASH',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.moneyBill,
                          size: 10,
                          color: defaultTextColor,
                        ),
                        const Spacer(),
                        Text(
                          '₤${cashSale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'CARD',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.creditCard,
                          size: 10,
                          color: defaultTextColor,
                        ),
                        const Spacer(),
                        Text(
                          '₤${cardSale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'POINTS',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.circleDollarToSlot,
                          size: 10,
                          color: defaultTextColor,
                        ),
                        const Spacer(),
                        Text(
                          '₤${pointsSale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      color: defaultTextColor,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          'TOTAL',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₤${totalDailySale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 119, 221, 119),
                                padding: const EdgeInsets.all(18)),
                            onPressed: () {
                              printSimple();
                            },
                            child: Text(
                              'SIMPLE PRINT',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 119, 221, 218),
                                padding: const EdgeInsets.all(18)),
                            onPressed: () {
                              printDetailed();
                            },
                            child: Text(
                              'DETAILED PRINT',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 221, 119, 119),
                                padding: const EdgeInsets.all(18)),
                            onPressed: () {
                              Box<DailySaleData> dailySaleBox =
                                  Box<DailySaleData>(store);
                              Query<DailySaleData> query2 =
                                  dailySaleBox.query().build();
                              List<DailySaleData> dates =
                                  query2.find().reversed.toList();
                              query2.close();
                              DateTime now;
                              if (dates.isEmpty) {
                                now =
                                    DateTime.now().add(const Duration(days: 1));
                              } else {
                                now = dates[0]
                                    .saleCreatedDate
                                    .add(const Duration(days: 1));
                              }
                              DateTime date =
                                  DateTime(now.year, now.month, now.day);
                              final DailySaleData dailySale = DailySaleData(
                                  saleCard: 0,
                                  saleCash: 0,
                                  salePoints: 0,
                                  saleCreatedDate: date);
                              // ignore: unused_local_variable
                              var id =
                                  store.box<DailySaleData>().put(dailySale);

                              saleDate = DateFormat("dd/MM/yy").format(date);
                              cardSale = 0;
                              cashSale = 0;
                              pointsSale = 0;
                              setState(() {});
                            },
                            child: Text(
                              'CLEAR DAILY',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: _isObscure,
                  child: Container(
                    height: 597,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: tilePrimaryColor,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  List<DailySalesData> getDailySalesChartData() {
    final List<DailySalesData> dailySalesChartData = [
      DailySalesData('CASH', cashSale),
      DailySalesData('CARD', cardSale),
      DailySalesData('POINTS', pointsSale),
    ];
    return dailySalesChartData;
  }
}

class DailySaleTabletBox extends StatefulWidget {
  const DailySaleTabletBox({super.key});

  @override
  State<DailySaleTabletBox> createState() => _DailySaleTabletBoxState();
}

class _DailySaleTabletBoxState extends State<DailySaleTabletBox> {
  bool _isObscure = true;
  var tableHeaders = [
    'Bill Number',
    'Total Value',
    'Discounted Total',
    'Payment Method',
  ];

  @override
  void initState() {
    super.initState();
    Box<DailySaleData> todays = Box<DailySaleData>(store);
    Query<DailySaleData> query = todays.query().build();
    List<DailySaleData> todaysSale = query.find().reversed.toList();

    DateTime now = DateTime.now();
    // ignore: unused_local_variable
    DateTime date = DateTime(now.year, now.month, now.day);

    if (todaysSale.isEmpty) {
      cashSale = 0;
      cardSale = 0;
      pointsSale = 0;
      saleDate = DateFormat("dd/MM/yy").format(now);
    } else {
      cashSale = todaysSale[0].saleCash;
      cardSale = todaysSale[0].saleCard;
      pointsSale = todaysSale[0].salePoints;
      saleDate = DateFormat("dd/MM/yy").format(todaysSale[0].saleCreatedDate);
    }

    totalDailySale = cashSale + cardSale + pointsSale;
    _dailySalesChartData = getDailySalesChartData();
    _dailySalesTooltipBehavior = TooltipBehavior(enable: true);
  }

  Future<void> printSimple() async {
    Box<DailySaleData> todays = Box<DailySaleData>(store);
    Query<DailySaleData> query2 = todays.query().build();
    List<DailySaleData> todaysSale = query2.find().reversed.toList();
    query2.close();
    final doc = pw.Document();
    Box<SaleData> salebox = Box<SaleData>(store);
    Query<SaleData> query = salebox
        .query(SaleData_.saleCreatedDate.greaterThan(
            todaysSale[0].saleCreatedDate.millisecondsSinceEpoch - 1))
        .build();
    List temp = query.find().toList();
    if (temp.isEmpty) {
      return;
    }
    dev.log(temp[0].saleCreatedDate.toString());
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.poppinsRegular(),
            italic: await PdfGoogleFonts.poppinsItalic(),
            bold: await PdfGoogleFonts.poppinsBold(),
          ),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              margin: const pw.EdgeInsets.all(0),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: .5),
              ),
            ),
          ),
          margin: const pw.EdgeInsets.all(20),
        ),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(
                fontSize: 8,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(text: "DAY END - SIMPLE SUMMARY", level: 0),
          pw.Row(
            children: [
              pw.Text('Username : ${cUser.username}'),
              pw.Spacer(),
              pw.Text('POS Terminal : $storeType $terminal'),
              pw.Spacer(),
              pw.Text(
                  'Time : ${DateFormat("dd/MM/yy HH:mm").format(DateTime.now())}'),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Header(text: 'DAILY SALES', level: 1),
          pw.Row(
            children: [
              pw.Text('Cash : £${cashSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Card : £${cardSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Points : £${pointsSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text(
                  'Total : £${(cashSale + cardSale + pointsSale).toStringAsFixed(2)}'),
            ],
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            // ignore: deprecated_member_use
            child: pw.Table.fromTextArray(
              border: null,
              cellAlignment: pw.Alignment.center,
              headerDecoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                color: PdfColors.white,
              ),
              headerHeight: 20,
              cellHeight: 20,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft
              },
              headerStyle: pw.TextStyle(
                color: PdfColors.black,
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(
                color: PdfColors.black,
                fontSize: 8,
              ),
              headerCellDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: .5,
                  ),
                ),
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: .5,
                  ),
                ),
              ),
              headers: List<String>.generate(
                tableHeaders.length,
                (col) => tableHeaders[col],
              ),
              data: List<List<String>>.generate(
                temp.length,
                (row) => List<String>.generate(
                  tableHeaders.length,
                  (col) => temp[row].getIndex(col),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
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

  Future<void> printDetailed() async {
    Box<DailySaleData> todays = Box<DailySaleData>(store);
    Query<DailySaleData> query2 = todays.query().build();
    List<DailySaleData> todaysSale = query2.find().reversed.toList();
    query2.close();
    final doc = pw.Document();
    Box<SaleData> salebox = Box<SaleData>(store);
    Query<SaleData> query = salebox
        .query(SaleData_.saleCreatedDate.greaterThan(
            todaysSale[0].saleCreatedDate.millisecondsSinceEpoch - 1))
        .build();
    List<SaleData> temp = query.find().toList();
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.poppinsRegular(),
            italic: await PdfGoogleFonts.poppinsItalic(),
            bold: await PdfGoogleFonts.poppinsBold(),
          ),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              margin: const pw.EdgeInsets.all(0),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: .5),
              ),
            ),
          ),
        ),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(
                fontSize: 8,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(text: "DAY END - DETAILED SUMMARY", level: 0),
          pw.Row(
            children: [
              pw.Text('Username : ${cUser.username}'),
              pw.Spacer(),
              pw.Text('POS Terminal : $storeType $terminal'),
              pw.Spacer(),
              pw.Text(
                  'Time : ${DateFormat("dd/MM/yy HH:mm").format(DateTime.now())}'),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Header(text: 'DAILY SALES', level: 1),
          pw.Row(
            children: [
              pw.Text('Cash : £${cashSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Card : £${cardSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text('Points : £${pointsSale.toStringAsFixed(2)}'),
              pw.Spacer(),
              pw.Text(
                  'Total : £${(cashSale + cardSale + pointsSale).toStringAsFixed(2)}'),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.ListView.builder(
            itemBuilder: (context, index) {
              return pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: .5),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Bill Number : ",
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.Text(
                                  temp[index].saleNumber,
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding:
                                      const pw.EdgeInsets.only(right: 65.0),
                                  child: pw.Text(
                                    "${DateFormat("dd/MM/yy").format(temp[index].saleCreatedDate)}   ${temp[index].saleCreatedDate.hour}:${temp[index].saleCreatedDate.minute}",
                                    style: const pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Divider(
                                height: 10,
                                color: PdfColors.black,
                                thickness: 1,
                                endIndent: 50),
                            pw.Text(
                              textAlign: pw.TextAlign.left,
                              formatBill(temp[index].data.join("---")),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              textAlign: pw.TextAlign.right,
                              "Bill Total : £${double.parse(temp[index].saleTotal).toStringAsFixed(2)}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 10,
                              ),
                            ),
                            pw.Text(
                              textAlign: pw.TextAlign.right,
                              "Disc. Bill Total : £${(double.parse(temp[index].saleTotal) - double.parse(temp[index].saleDiscount)).toStringAsFixed(2)}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 10,
                              ),
                            ),
                            pw.Text(
                              textAlign: pw.TextAlign.right,
                              "Mode : ${temp[index].getIndex(3)}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: temp.length,
          ),
        ],
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 680,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: tileSecondaryColor,
          border: Border.all(
            color: Colors.grey, //color of border
            width: 1, //width of border
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Daily Sale - ',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: defaultTextColor,
                    ),
                  ),
                  Text(
                    saleDate,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: defaultTextColor,
                    ),
                  ),
                  const Spacer(),
                  SizedBox.fromSize(
                    size: const Size(36, 36),
                    child: ClipOval(
                      child: Material(
                        color: tileSecondaryColor,
                        child: InkWell(
                          splashColor: tilePrimaryColor,
                          onTap: () async {
                            final ok = await showTextAnswerDialog(
                              context: context,
                              autoSubmit: true,
                              title: 'User Authentication',
                              message:
                                  'Please authenticate yourself to access this information.',
                              keyword: '2809',
                              hintText: 'Enter PIN',
                              retryTitle: 'Incorrect PIN',
                              retryMessage: 'Please try again.',
                              builder: (context, child) => Theme(
                                data: ThemeData(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: defaultBackgroundColor,
                                      textStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: defaultAccentColor,
                                    ),
                                  ),
                                ),
                                child: child,
                              ),
                            );
                            if (ok) {
                              setState(
                                () {
                                  _isObscure = !_isObscure;
                                },
                              );
                            }
                          },
                          child: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                height: 10,
                color: defaultTextColor,
                thickness: 1,
              ),
              Stack(children: [
                Column(
                  children: [
                    SfCircularChart(
                      tooltipBehavior: _dailySalesTooltipBehavior,
                      palette: pieChartColorPalette,
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        position: LegendPosition.top,
                      ),
                      series: <CircularSeries>[
                        RadialBarSeries<DailySalesData, String>(
                          useSeriesColor: true,
                          trackOpacity: 0.3,
                          gap: '7%',
                          cornerStyle: CornerStyle.bothCurve,
                          dataSource: _dailySalesChartData,
                          xValueMapper: (DailySalesData data, _) =>
                              data.paymentMethod,
                          yValueMapper: (DailySalesData data, _) =>
                              data.dailySaleAmount,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                          enableTooltip: true,
                          maximumValue:
                              max(pointsSale, max(cashSale, cardSale)) *
                                  (4 / 3),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'CASH',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: defaultTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.moneyBill,
                          size: 10,
                          color: defaultTextColor,
                        ),
                        const Spacer(),
                        Text(
                          '₤${cashSale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'CARD',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: defaultTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.creditCard,
                          size: 10,
                          color: defaultTextColor,
                        ),
                        const Spacer(),
                        Text(
                          '₤${cardSale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'POINTS',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: defaultTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.circleDollarToSlot,
                          size: 10,
                          color: defaultTextColor,
                        ),
                        const Spacer(),
                        Text(
                          '₤${pointsSale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      color: defaultTextColor,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          'TOTAL',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₤${totalDailySale.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 119, 221, 119),
                                padding: const EdgeInsets.all(9)),
                            onPressed: () {
                              printSimple();
                            },
                            child: Text(
                              'SIMPLE PRINT',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 119, 221, 218),
                                padding: const EdgeInsets.all(9)),
                            onPressed: () {
                              printDetailed();
                            },
                            child: Text(
                              'DETAILED PRINT',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 221, 119, 119),
                                padding: const EdgeInsets.all(9)),
                            onPressed: () {
                              Box<DailySaleData> dailySaleBox =
                                  Box<DailySaleData>(store);
                              Query<DailySaleData> query2 =
                                  dailySaleBox.query().build();
                              List<DailySaleData> dates =
                                  query2.find().reversed.toList();
                              query2.close();
                              DateTime now;
                              if (dates.isEmpty) {
                                now =
                                    DateTime.now().add(const Duration(days: 1));
                              } else {
                                now = dates[0]
                                    .saleCreatedDate
                                    .add(const Duration(days: 1));
                              }
                              DateTime date =
                                  DateTime(now.year, now.month, now.day);
                              final DailySaleData dailySale = DailySaleData(
                                  saleCard: 0,
                                  saleCash: 0,
                                  salePoints: 0,
                                  saleCreatedDate: date);
                              // ignore: unused_local_variable
                              var id =
                                  store.box<DailySaleData>().put(dailySale);

                              saleDate = DateFormat("dd/MM/yy").format(date);
                              cardSale = 0;
                              cashSale = 0;
                              pointsSale = 0;
                              setState(() {});
                            },
                            child: Text(
                              'CLEAR DAILY',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: _isObscure,
                  child: Container(
                    height: 600,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: tilePrimaryColor,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  List<DailySalesData> getDailySalesChartData() {
    final List<DailySalesData> dailySalesChartData = [
      DailySalesData('CASH', cashSale),
      DailySalesData('CARD', cardSale),
      DailySalesData('POINTS', pointsSale),
    ];
    return dailySalesChartData;
  }
}

class DailySalesData {
  DailySalesData(this.paymentMethod, this.dailySaleAmount);
  String paymentMethod;
  double dailySaleAmount;
}
