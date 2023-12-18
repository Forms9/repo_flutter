//==========================================================================
// DEPRICATED PLS CHECK BEFORE USE
//==========================================================================

import 'dart:convert';
import 'dart:developer';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/objectbox.g.dart';
import 'package:reporting_app/screens/generate_bill/generate_bill.dart';
import 'package:reporting_app/util/side_menu.dart';
import 'package:tabbed_view/tabbed_view.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../database.dart';
import 'package:http/http.dart' as http;

var _controller = TextEditingController();
String controllerName = "";
int tabindex = 0;
bool isNormal = true;

// final pageKey = GlobalKey();
class TabWidgetKey {
  // ignore: prefer_const_declarations
  static final tabwidgetkey = const Key('__TABWIDGETKEY__');
}

class UpdatePriceModel {
  String? barcodeNo;
  String? productName;
  double? rate;

  UpdatePriceModel({
    this.barcodeNo,
    this.productName,
    this.rate,
  });

  @override
  String toString() {
    return "$barcodeNo,$productName,$rate";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['uniqueNumber'] = barcodeNo;
    data['headline'] = productName;
    data['updatedPrice'] = rate?.toStringAsFixed(2);

    return data;
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return barcodeNo == "" ? " " : barcodeNo!;
      case 1:
        return productName == "" ? " " : productName!;
      case 2:
        return " ";
      case 3:
        return "£$rate";
      case 4:
        return " ";
    }
    return " ";
  }
}

class BillItemModel {
  int? indexNo;
  String? barcodeNo;
  String? productName;
  int? quantity;
  double? rate;
  double? itemTotal;

  BillItemModel({
    this.indexNo,
    this.barcodeNo,
    this.productName,
    this.quantity,
    this.rate,
    this.itemTotal,
  });

  @override
  String toString() {
    return "$barcodeNo,$productName,$quantity,${rate!.toStringAsFixed(2)},${itemTotal!.toStringAsFixed(2)}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['IndexNo'] = indexNo;
    data['BarcodeNo'] = barcodeNo;
    data['ProductName'] = productName;
    data['Quantity'] = quantity;
    data['Rate'] = rate;
    data['ItemTotal'] = itemTotal;

    return data;
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return barcodeNo == "" ? " " : barcodeNo!;
      case 1:
        return productName == "" ? " " : productName!;
      case 2:
        return quantity.toString();
      case 3:
        if (rate! >= 0) {
          return "£${rate!.toStringAsFixed(2)}";
        } else {
          return "-£${(rate! * -1).toStringAsFixed(2)}";
        }
      case 4:
        if (itemTotal! >= 0) {
          return "£${itemTotal!.toStringAsFixed(2)}";
        } else {
          return "-£${(itemTotal! * -1).toStringAsFixed(2)}";
        }
    }
    return " ";
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// class NullRateValueFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: newValue.3text,
//       selection: newValue.selection,
//     );
//   }
// }
bool isNumeric(String string) {
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  return numericRegex.hasMatch(string);
}

class NegativeRateValueFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return oldValue.text.contains("-") && isNumeric(oldValue.text)
        ? TextEditingValue(
            text: newValue.text,
            selection: newValue.selection,
          )
        : TextEditingValue(
            text: '-${newValue.text}',
            selection: newValue.selection,
          );
  }
}

class PositiveRateValueFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text,
      selection: newValue.selection,
    );
  }
}

class DesktopGenerateBillPage extends StatefulWidget {
  // ignore: use_super_parameters
  const DesktopGenerateBillPage({Key? key}) : super(key: key);

  @override
  State<DesktopGenerateBillPage> createState() =>
      _DesktopGenerateBillPageState();
}

class _DesktopGenerateBillPageState extends State<DesktopGenerateBillPage> {
  String action = "";

  @override
  void initState() {
    super.initState();
    // const TabBarView(key: ValueKey(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          'Generate Bills',
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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: TabBarView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var hasData = {};

class TabBarView extends StatefulWidget {
  // ignore: use_super_parameters
  const TabBarView({Key? key}) : super(key: key);

  @override
  State<TabBarView> createState() => _TabBarViewState();
}

TabbedViewController tabController = TabbedViewController([]);

class _TabBarViewState extends State<TabBarView> {
  @override
  // void initState() {
  //   super.initState();
  //   if (tabController.tabs.isEmpty) {
  //     count += 1;
  //     tabController.addTab(
  //       TabData(
  //         text: 'BILL $count',
  //         content: const BillPage(),
  //         keepAlive: true,
  //       ),
  //     );
  //   }
  //   hasData['BILL $count'] = false;
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    _tabCloseInterceptor(int tabIndex) {
      TabData currentTab = tabController.getTabByIndex(tabIndex);
      if (!hasData[currentTab.text]) {
        return true;
      } else {
        return false;
      }
    }

    TabbedViewThemeData themeData =
        TabbedViewThemeData.mobile(accentColor: defaultAccentColor)
          ..tab.textStyle = TextStyle(
            fontSize: 18,
            color: defaultTextColor,
            fontFamily: GoogleFonts.poppins().fontFamily,
          )
          ..tab.padding = const EdgeInsets.only(
            top: 0.0,
            bottom: 0.0,
            left: 30.0,
            right: 30.0,
          );
    themeData.tabsArea.border = Border(
        top: BorderSide(color: defaultTextColor),
        right: BorderSide(color: defaultTextColor),
        left: BorderSide(color: defaultTextColor),
        bottom: BorderSide(color: defaultTextColor));

    TabbedViewTheme theme = TabbedViewTheme(
      data: themeData,
      child: TabbedView(
        controller: tabController,
        onTabClose: (index, tabData) {
          log('From close listner $index: ${tabData.text} ${tabData.value}');
        },
        onTabSelection: (newTabIndex) {
          if (newTabIndex != null) {
            tabindex = newTabIndex;
          } else {
            tabindex = 0;
          }
        },
        tabCloseInterceptor: _tabCloseInterceptor,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(
            TabButton(
              icon: IconProvider.data(
                Icons.add,
              ),
              iconSize: 40,
              onPressed: () {
                count += 1;
                tabController.addTab(
                  TabData(
                    text: 'BILL $count',
                    content: const BillPage(),
                    keepAlive: true,
                  ),
                );
                hasData['BILL $count'] = false;
              },
            ),
          );
          return buttons;
        },
      ),
    );

    return theme;
  }
}

class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max) : assert(min < max);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var value = int.parse(newValue.text);
    if (value < min) {
      return TextEditingValue(text: min.toString());
    } else if (value > max) {
      return TextEditingValue(text: max.toString());
    }
    return newValue;
  }
}

class BillPage extends StatefulWidget {
  // ignore: use_super_parameters
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  List<BillItemModel> data = List.empty(growable: true);

  final cashController = TextEditingController();
  final cardController = TextEditingController();
  final pointsController = TextEditingController();
  final discountController = TextEditingController();
  final billItemScrollController = ScrollController();

  bool cardPayment = false, cashPayment = false, pointsPayment = false;

  static List<Widget> discounts = <Widget>[
    // Text('0%', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Icon(
      FontAwesomeIcons.xmark,
      size: 15,
      color: appBarColor,
    ),
    // Text('5%', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Icon(
      FontAwesomeIcons.personWalking,
      size: 15,
      color: appBarColor,
    ),
    // Text('10%', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Icon(
      FontAwesomeIcons.bicycle,
      size: 15,
      color: appBarColor,
    ),
    // Text('20%', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Icon(
      FontAwesomeIcons.carSide,
      size: 15,
      color: appBarColor,
    ),
    // Text('25%', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Icon(
      FontAwesomeIcons.plane,
      size: 15,
      color: appBarColor,
    ),
    // Text('Other',
    //     style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Icon(
      FontAwesomeIcons.question,
      size: 15,
      color: appBarColor,
    ),
  ];

  static List<Widget> paymentMethods = <Widget>[
    Text('CARD',
        style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Text('CASH',
        style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Text('POINTS',
        style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
  ];

  final List<bool> _selectedDiscount = <bool>[
    true,
    false,
    false,
    false,
    false,
    false
  ];

  final List<bool> _selectedPayments = <bool>[false, false, false];

  int n = 1;
  double cartTotal = 0, discountTotal = 0;
  int qtyTotal = 0;
  double cash = 0, card = 0, points = 0, balance = 0;
  bool isNoExch = false;
  final List<FocusNode> _focusNodes = [];

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return defaultTextColor;
    }
    return defaultTextColor;
  }

  _addRow(i) {
    setState(() {
      data.add(BillItemModel(
          barcodeNo: "", productName: "", itemTotal: 0, quantity: 0, rate: 0));
      if (billItemScrollController.hasClients) {
        final position = billItemScrollController.position.maxScrollExtent;
        billItemScrollController.jumpTo(position);
      }
      calculateCartTotal();
      calculateDiscount();
      calculatePaymentMethodBalance();
    });
  }

  _delRow(i) {
    setState(() {
      data.removeAt(i);
      //data.removeWhere((item) => item.indexNo == data[i].indexNo);
      calculateCartTotal();
      calculateDiscount();
      calculatePaymentMethodBalance();
    });
  }

  calculateCartTotal() {
    setState(() {
      cartTotal = 0;
      for (var x = 0; x < data.length; x++) {
        cartTotal += data[x].itemTotal!;
      }
      discountTotal = cartTotal;
      if (_selectedPayments[0]) {
        cardController.text = discountTotal.toStringAsFixed(2);
      }
      if (_selectedPayments[1]) {
        cashController.text = discountTotal.toStringAsFixed(2);
      }
      qtyTotal = 0;
      for (var x = 0; x < data.length; x++) {
        qtyTotal += data[x].quantity!;
      }
    });
    calculateDiscount();
  }

  calculateDiscount() {
    setState(() {
      if (_selectedDiscount[0]) {
        discountTotal = cartTotal * 1;
      } else if (_selectedDiscount[1]) {
        discountTotal = cartTotal * 0.95;
      } else if (_selectedDiscount[2]) {
        discountTotal = cartTotal * 0.9;
      } else if (_selectedDiscount[3]) {
        discountTotal = cartTotal * 0.8;
      } else if (_selectedDiscount[4]) {
        discountTotal = cartTotal * 0.75;
      } else if (_selectedDiscount[5]) {
        if (discountController.text.isNotEmpty) {
          if (double.parse(discountController.text) >= 0 &&
              double.parse(discountController.text) <= cartTotal) {
            discountTotal = cartTotal - double.parse(discountController.text);
          }
        } else {
          discountTotal = cartTotal;
        }
      }
      // if (discountTotal % 0.5 != 0) {
      //   discountTotal = discountTotal + (0.5 - (discountTotal % 0.5));
      // }
      if (_selectedPayments[0]) {
        cardController.text = discountTotal.toStringAsFixed(2);
      }
      if (_selectedPayments[1]) {
        cashController.text = discountTotal.toStringAsFixed(2);
      }
    });
  }

  calculatePaymentMethodBalance() {
    // Include provision for fetching points somehow
    setState(() {
      balance = discountTotal;
      double cash = 0, card = 0, points = 0;

      if (cashController.text.isNotEmpty) {
        cash = double.parse(cashController.text);
        cashPayment = true;
        log('Cash Flag: $cashPayment');
      }
      if (cardController.text.isNotEmpty) {
        card = double.parse(cardController.text);
        cardPayment = true;
        log('Card Flag: $cardPayment');
      }
      if (pointsController.text.isNotEmpty) {
        points = double.parse(pointsController.text);
        pointsPayment = true;
        log('Points Flag: $pointsPayment');
      }

      // Default value fallback
      if (cashController.text.isEmpty) {
        cashPayment = false;
        log('Cash Flag: $cashPayment');
      }
      if (cardController.text.isEmpty) {
        cardPayment = false;
        log('Card Flag: $cardPayment');
      }
      if (pointsController.text.isEmpty) {
        pointsPayment = false;
        log('Points Flag: $pointsPayment');
      }

      balance -= (cash + card + points);
      log(balance.toString());
    });
  }

  saveBillState() async {
    try {
      log("Saving new bill");
      if (data.length == 1) {
        if (data[0].barcodeNo == "") {
          log("Empty page");
          return;
        }
      }

      Box<DailySaleData> dailySaleBox1 = Box<DailySaleData>(store);
      Query<DailySaleData> query3 = dailySaleBox1.query().build();
      List<DailySaleData> latest = query3.find().reversed.toList();
      query3.close();

      List updatedPrices = List.empty(growable: true);
      List<BillItemModel> temp = List.empty(growable: true);
      String saleNumber = "";

      DateTime saleCreatedDate;
      DateTime now = DateTime.now();
      DateTime currentDate = DateTime(now.year, now.month, now.day);
      if (latest.isEmpty) {
        saleCreatedDate = DateTime.now();
      } else if (currentDate != latest[0].saleCreatedDate) {
        saleCreatedDate = latest[0].saleCreatedDate;
      } else {
        saleCreatedDate = DateTime.now();
      }

      String saleTotal = cartTotal.toString();
      String saleDiscount = "0";
      String saleCard = cardController.text;
      String saleCash = cashController.text;
      String salePoints = pointsController.text;
      String saleBalance = balance.toString();
      List<String> saleData = List.empty(growable: true);

      // if (_selectedDiscount[0]) {
      //   saleDiscount = "0";
      // } else if (_selectedDiscount[1]) {
      //   saleDiscount = (0.05 * cartTotal);
      // } else if (_selectedDiscount[2]) {
      //   saleDiscount = 0.10 * cartTotal;
      // } else if (_selectedDiscount[3]) {
      //   saleDiscount = 0.20 * cartTotal;
      // } else if (_selectedDiscount[4]) {
      //   saleDiscount = 0.25 * cartTotal;
      // } else if (_selectedDiscount[5]) {
      //   if (discountController.text.isNotEmpty) {
      //     saleDiscount = discountController.text;
      //   } else {
      //     saleDiscount = "0";
      //   }
      // }

      saleDiscount = (cartTotal - discountTotal).toStringAsFixed(2);

      Box<SaleData> saleBox = Box<SaleData>(store);
      Query<SaleData> query = saleBox.query().build();
      List<String> sales = query.property(SaleData_.saleNumber).find();
      query.close();

      if (sales.isEmpty) {
        saleNumber =
            '${'${cUser.store[0]}-${cUser.username.substring(0, 3).toUpperCase()}-$terminal'}-${DateFormat('MMyy').format(DateTime.now())}0001';
      } else {
        String x = sales[sales.length - 1];
        int number = int.parse(x.substring(x.length - 4)) + 1;
        String finalNum = number.toString();
        for (int i = 0; i < 4 - number.toString().length; i++) {
          finalNum = "0$finalNum";
        }
        saleNumber =
            '${'${cUser.store[0]}-${cUser.username.substring(0, 3).toUpperCase()}-$terminal'}-${DateFormat('MMyy').format(DateTime.now())}$finalNum';
      }

      Box<ProductData> productbox = Box<ProductData>(store);

      // for (BillItemModel item in data) {
      //   if (item.barcodeNo == "") {
      //     continue;
      //   }
      //   if (item.quantity.toString() == "") {
      //     item.quantity = 1;
      //   }
      //   if (item.quantity.toString() == "0") {
      //     continue;
      //   }
      //   if (items.containsKey(item.barcodeNo)) {
      //     BillItemModel existing = items[item.barcodeNo]!;
      //     existing.quantity = existing.quantity! + item.quantity!;
      //     existing.itemTotal = existing.itemTotal! + item.itemTotal!;
      //   } else {
      //     items.addAll({
      //       item.barcodeNo!: BillItemModel(
      //         indexNo: item.indexNo,
      //         barcodeNo: item.barcodeNo,
      //         itemTotal: item.itemTotal,
      //         productName: item.productName,
      //         quantity: item.quantity,
      //         rate: item.rate,
      //       )
      //     });
      //   }
      // }

      for (BillItemModel item in data) {
        if (item.barcodeNo == "") {
          continue;
        }
        if (item.quantity.toString() == "") {
          item.quantity = 1;
        }
        if (item.quantity.toString() == "0") {
          continue;
        }
        if (item.rate.toString() == "") {
          Query<ProductData> query = productbox
              .query(ProductData_.uniqueNo.equals(item.barcodeNo!))
              .build();
          List<ProductData> products = query.find();
          query.close();
          if (products.isNotEmpty) {
            item.rate = double.parse(products[0].cipher!);
            item.itemTotal = item.rate! * item.quantity!;
          }
        }
        saleData.add(item.toString());
        temp.add(item);
        Query<ProductData> query = productbox
            .query(ProductData_.uniqueNo.equals(item.barcodeNo!))
            .build();
        List<ProductData> products = query.find();
        query.close();
        if (products.isNotEmpty) {
          if (products[0].packedQuantity != null) {
            products[0].packedQuantity =
                products[0].packedQuantity! - item.quantity!;
          } else {
            products[0].packedQuantity = (0 - item.quantity!) as double?;
          }
          if (double.tryParse(products[0].cipher!)! < item.rate!) {
            updatedPrices.add(UpdatePriceModel(
              barcodeNo: item.barcodeNo,
              productName: item.productName,
              rate: item.rate,
            ));
          }
          store.box<ProductData>().put(products[0]);
        }
      }

      final SaleData sale = SaleData(
        data: saleData,
        saleCard: saleCard,
        saleCash: saleCash,
        salePoints: salePoints,
        saleNumber: saleNumber,
        saleBalance: saleBalance,
        saleCreatedDate: saleCreatedDate,
        saleDiscount: saleDiscount,
        saleTotal: saleTotal,
        isNoExch: isNoExch,
      );
      var id = store.box<SaleData>().put(sale);
      log("$id Added to bills");
      tabController.removeTab(tabController.selectedIndex!);

      final SaleNumberData saleNumberData = SaleNumberData(
          saleNumber: saleNumber, saleCreatedDate: saleCreatedDate);

      // ignore: unused_local_variable
      var saleNumberId = store.box<SaleNumberData>().put(saleNumberData);

      Box<DailySaleData> dailySaleBox = Box<DailySaleData>(store);
      Query<DailySaleData> query2 = dailySaleBox.query().build();
      List<DailySaleData> dates = query2.find().reversed.toList();
      query2.close();

      DateTime date = DateTime(now.year, now.month, now.day);

      if (dates.isEmpty) {
        final DailySaleData dailySale = DailySaleData(
            saleCard: saleCard.isEmpty ? 0 : double.parse(saleCard),
            saleCash: saleCash.isEmpty ? 0 : double.parse(saleCash),
            salePoints: salePoints.isEmpty ? 0 : double.parse(salePoints),
            saleCreatedDate: date);
        // ignore: unused_local_variable
        var id = store.box<DailySaleData>().put(dailySale);
      } else {
        dates[0].saleCard += saleCard.isEmpty ? 0 : double.parse(saleCard);
        dates[0].saleCash +=
            saleCash.isEmpty ? 0 : double.parse(saleCash) + balance;
        dates[0].salePoints +=
            salePoints.isEmpty ? 0 : double.parse(salePoints);
        store.box<DailySaleData>().put(dates[0]);
      }

      ElegantNotification.success(
        width: 490,
        notificationPosition: NotificationPosition.bottomRight,
        animation: AnimationType.fromRight,
        title: Text(
          'Bill Saved - Success',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: defaultTextColor,
          ),
        ),
        description: Text(
          'Bill successfully saved as $saleNumber',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: defaultTextColor,
          ),
        ),
        toastDuration: const Duration(seconds: 6),
      ).show(context);

      count += 1;
      tabController.addTab(
        TabData(
          text: 'BILL $count',
          content: const BillPage(),
          keepAlive: true,
        ),
      );
      hasData['BILL $count'] = false;

      //update prices to server
      if (updatedPrices.isNotEmpty) {
        var headers = {'Content-Type': 'application/json'};
        var request = http.Request(
            'POST', Uri.parse('http://$apiURL/save_updated_price'));
        request.body =
            json.encode({"mac_id": displayDeviceId, "products": updatedPrices});
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          log(await response.stream.bytesToString());
        } else {
          log(response.reasonPhrase.toString());
          log(await response.stream.bytesToString());
        }
      }

      final doc = pw.Document();

      const tableHeaders = [
        'Barcode',
        'Item',
        'QTY',
        'Price',
        'Total',
      ];

      // ignore: unused_local_variable
      int pages = (temp.length / 7).ceil();
      var lists = [];
      int chunkSize = 10;
      for (var i = 0; i < temp.length; i += chunkSize) {
        lists.add(temp.sublist(
            i, i + chunkSize > temp.length ? temp.length : i + chunkSize));
      }
      for (List temp1 in lists) {
        doc.addPage(
          pw.Page(
            pageTheme: pw.PageTheme(
              pageFormat: PdfPageFormat.a5,
              theme: pw.ThemeData.withFont(
                base: await PdfGoogleFonts.poppinsRegular(),
                italic: await PdfGoogleFonts.poppinsItalic(),
                bold: await PdfGoogleFonts.poppinsBold(),
              ),
              buildBackground: (context) => pw.FullPage(
                ignoreMargins: true,
                child: pw.Container(
                  margin: const pw.EdgeInsets.all(0),
                ),
              ),
            ),
            build: (pw.Context context) {
              return pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Column(
                  children: [
                    // pw.Text('Shri Venilals',
                    //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    // pw.Text('115/117 Ealing Road, Wembley, HA0 4BP',
                    //     style: const pw.TextStyle(fontSize: 12)),
                    // pw.Text('Telephone : +44 20 8903 3144',
                    //     style: const pw.TextStyle(fontSize: 10)),
                    // pw.Divider(),
                    // pw.Text(" CASH RECEIPT"),
                    // pw.Divider(),
                    // pw.Column(
                    //   crossAxisAlignment: pw.CrossAxisAlignment.end,
                    //   children: [
                    //     // pw.Text("Invoice Number : $saleNumber"),
                    //     pw.Text(
                    //         "Date : ${DateFormat("dd/MM/yy HH:mm").format(DateTime.now())}",
                    //         style: const pw.TextStyle(fontSize: 8)),
                    //   ],
                    // ),
                    pw.SizedBox(height: 135),
                    pw.Row(children: [
                      pw.Spacer(),
                      pw.Text(
                        DateFormat("dd/MM/yyyy").format(DateTime.now()),
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 7,
                        ),
                      )
                    ]),
                    // ignore: deprecated_member_use
                    pw.Table.fromTextArray(
                      border: null,
                      cellAlignment: pw.Alignment.centerLeft,
                      headerDecoration: const pw.BoxDecoration(
                        borderRadius:
                            pw.BorderRadius.all(pw.Radius.circular(2)),
                        color: PdfColors.white,
                      ),
                      headerHeight: 20,
                      cellHeight: 8,
                      cellAlignments: {
                        0: pw.Alignment.centerLeft,
                        1: pw.Alignment.centerLeft,
                        2: pw.Alignment.centerRight,
                        3: pw.Alignment.center,
                        4: pw.Alignment.centerRight,
                      },
                      headerStyle: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      cellStyle: const pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 7,
                      ),
                      headerCellDecoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(
                            color: PdfColors.black,
                            width: .5,
                          ),
                        ),
                      ),
                      // rowDecoration: const pw.BoxDecoration(
                      //   border: pw.Border(
                      //     bottom: pw.BorderSide(
                      //       color: PdfColors.black,
                      //       width: .5,
                      //     ),
                      //   ),
                      // ),

                      headers: List<String>.generate(
                        tableHeaders.length,
                        (col) => tableHeaders[col],
                      ),
                      data: List<List<String>>.generate(
                        temp1.length,
                        (row) => List<String>.generate(
                          tableHeaders.length,
                          (col) => temp1[row].getIndex(col),
                        ),
                      ),
                    ),
                    if (context.pageNumber != context.pagesCount)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 4),
                            child: pw.Text(
                              'Page ${context.pageNumber} of ${context.pagesCount}',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontStyle: pw.FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),

                    //totals
                    if (context.pageNumber == context.pagesCount)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 4),
                            child: pw.Text(
                              'Page ${context.pageNumber} of ${context.pagesCount}',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontStyle: pw.FontStyle.italic,
                              ),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 4),
                            child: pw.Text(
                                double.parse(saleTotal) >= 0
                                    ? 'Total QTY: $qtyTotal             SUBTOTAL : £${double.parse(saleTotal).toStringAsFixed(2)}'
                                    : 'Total QTY: $qtyTotal             SUBTOTAL : -£${(double.parse(saleTotal) * -1).toStringAsFixed(2)}',
                                // 'Total QTY: $qtyTotal             SUBTOTAL : £${double.parse(saleTotal).toStringAsFixed(2)}',
                                style: const pw.TextStyle(fontSize: 8)),
                          ),
                        ],
                      ),

                    if (context.pageNumber == context.pagesCount)
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            if (isNoExch)
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.only(top: 4),
                                      child: pw.Text(
                                          '* NO EXCHANGE / NO REFUND *',
                                          style: pw.TextStyle(
                                              fontSize: 8,
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                  ]),
                            pw.Spacer(),
                            if ((cartTotal - discountTotal) != 0)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 4),
                                child: pw.Text(
                                    'SPECIAL OFFER : - £${(cartTotal - discountTotal).toStringAsFixed(2)}',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                          ]),
                    if (context.pageNumber == context.pagesCount)
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            if (cardPayment == true &&
                                cashPayment == true &&
                                pointsPayment == true)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 0),
                                child: pw.Text(
                                    'PAYMENT METHOD : CASH, CARD, POINTS',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                            if (cardPayment == true &&
                                cashPayment == true &&
                                pointsPayment == false)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 0),
                                child: pw.Text('PAYMENT METHOD : CASH, CARD',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                            if (cardPayment == false &&
                                cashPayment == true &&
                                pointsPayment == true)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 0),
                                child: pw.Text('PAYMENT METHOD : CASH, POINTS',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                            if (cardPayment == true &&
                                cashPayment == false &&
                                pointsPayment == true)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 0),
                                child: pw.Text('PAYMENT METHOD : CARD, POINTS',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                            if (cardPayment == false &&
                                cashPayment == true &&
                                pointsPayment == false)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 0),
                                child: pw.Text('PAYMENT METHOD : CASH',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                            if (cardPayment == true &&
                                cashPayment == false &&
                                pointsPayment == false)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 0),
                                child: pw.Text('PAYMENT METHOD : CARD',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                            if (cardPayment == false &&
                                cashPayment == false &&
                                pointsPayment == true)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 0),
                                child: pw.Text('PAYMENT METHOD : POINTS',
                                    style: const pw.TextStyle(fontSize: 8)),
                              ),
                            pw.Spacer(),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 4),
                              child: pw.Text(
                                  discountTotal >= 0
                                      ? 'GRAND TOTAL : £${discountTotal.toStringAsFixed(2)}'
                                      : 'GRAND TOTAL : -£${(discountTotal * -1).toStringAsFixed(2)}',
                                  // 'GRAND TOTAL : £${discountTotal.toStringAsFixed(2)}',
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                  )),
                            )
                          ]),
                    /*
                // pw.Divider(),
                // pw.Row(
                //     mainAxisAlignment: pw.MainAxisAlignment.start,
                //     children: [
                //       pw.Padding(
                //         padding: const pw.EdgeInsets.only(top: 0),
                //         child: pw.Text('Served By : ',
                //             style: const pw.TextStyle(
                //               fontSize: 7,
                //             )),
                //       )
                //     ]),

                // pw.Divider(height: 2),

                // if (isNoExch) pw.Divider(height: 2),

                // pw.Row(
                //     mainAxisAlignment: pw.MainAxisAlignment.start,
                //     children: [
                //       if (cardPayment == true &&
                //           cashPayment == true &&
                //           pointsPayment == true)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 0),
                //           child: pw.Text('PAYMENT METHOD : CASH, CARD, POINTS',
                //               style: const pw.TextStyle(fontSize: 8)),
                //         ),
                //       if (cardPayment == true &&
                //           cashPayment == true &&
                //           pointsPayment == false)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 0),
                //           child: pw.Text('PAYMENT METHOD : CASH, CARD',
                //               style: const pw.TextStyle(fontSize: 8)),
                //         ),
                //       if (cardPayment == false &&
                //           cashPayment == true &&
                //           pointsPayment == true)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 0),
                //           child: pw.Text('PAYMENT METHOD : CASH, POINTS',
                //               style: const pw.TextStyle(fontSize: 8)),
                //         ),
                //       if (cardPayment == true &&
                //           cashPayment == false &&
                //           pointsPayment == true)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 0),
                //           child: pw.Text('PAYMENT METHOD : CARD, POINTS',
                //               style: const pw.TextStyle(fontSize: 8)),
                //         ),
                //       if (cardPayment == false &&
                //           cashPayment == true &&
                //           pointsPayment == false)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 0),
                //           child: pw.Text('PAYMENT METHOD : CASH',
                //               style: const pw.TextStyle(fontSize: 8)),
                //         ),
                //       if (cardPayment == true &&
                //           cashPayment == false &&
                //           pointsPayment == false)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 0),
                //           child: pw.Text('PAYMENT METHOD : CARD',
                //               style: const pw.TextStyle(fontSize: 8)),
                //         ),
                //       if (cardPayment == false &&
                //           cashPayment == false &&
                //           pointsPayment == true)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 0),
                //           child: pw.Text('PAYMENT METHOD : POINTS',
                //               style: const pw.TextStyle(fontSize: 8)),
                //         ),
                //     ]),

                // pw.Row(
                //     mainAxisAlignment: pw.MainAxisAlignment.start,
                //     children: [
                //       if (cashPayment == true && balance < 0)
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.only(top: 5),
                //           child: pw.Text('CHANGE : £${balance.abs()}',
                //               style: const pw.TextStyle(fontSize: 7)),
                //         )
                //     ]),

                // pw.Divider(),

                // //terms and conditions

                // pw.Padding(
                //   padding: const pw.EdgeInsets.only(top: 5),
                //   child: pw.Row(
                //       mainAxisAlignment: pw.MainAxisAlignment.start,
                //       children: [
                //         pw.Text('NO EXCHANGE IF LABELS ARE REMOVED FROM GOODS',
                //             style: pw.TextStyle(
                //                 fontSize: 7,
                //                 fontStyle: pw.FontStyle.italic,
                //                 fontWeight: pw.FontWeight.bold)),
                //       ]),
                // ),
                // pw.Padding(
                //   padding: const pw.EdgeInsets.only(top: 5),
                //   child: pw.Row(
                //       mainAxisAlignment: pw.MainAxisAlignment.start,
                //       children: [
                //         pw.Text(
                //             'All Goods sold as seen. All items Dry Clean only.',
                //             style: const pw.TextStyle(fontSize: 7)),
                //       ]),
                // ),
                // pw.Padding(
                //   padding: const pw.EdgeInsets.only(top: 5),
                //   child: pw.Row(
                //       mainAxisAlignment: pw.MainAxisAlignment.start,
                //       children: [
                //         pw.Text('Goods can be exchanged within 14 days ,',
                //             style: const pw.TextStyle(fontSize: 7)),
                //         pw.Text(' NO RETURNS.',
                //             style: pw.TextStyle(
                //               fontSize: 8,
                //               fontWeight: pw.FontWeight.bold,
                //             )),
                //       ]),
                // ),
                // pw.Padding(
                //   padding: const pw.EdgeInsets.only(top: 5),
                //   child: pw.Row(
                //       mainAxisAlignment: pw.MainAxisAlignment.start,
                //       children: [
                //         pw.Text('Altered goods cannot be exchanged.',
                //             style: const pw.TextStyle(fontSize: 7)),
                //       ]),
                // ),
                // pw.Padding(
                //   padding: const pw.EdgeInsets.only(top: 5),
                //   child: pw.Row(
                //       mainAxisAlignment: pw.MainAxisAlignment.start,
                //       children: [
                //         pw.Text('No Guarantee on Jari, Colour and Fabric.',
                //             style: const pw.TextStyle(fontSize: 7)),
                //       ]),
                // ),
                // pw.Divider(),

                // pw.Text(
                //   'THANK YOU! VISIT AGAIN. ',
                //   style: pw.TextStyle(
                //       fontSize: 8,
                //       fontStyle: pw.FontStyle.italic,
                //       fontWeight: pw.FontWeight.bold),
                // ),*/
                  ],
                ),
              ); // Center
            },
          ),
        );
      }
      updateSaleData();
      await Printing.directPrintPdf(
          printer: Printer(
            url: printerName,
          ),
          onLayout: (PdfPageFormat format) async => doc.save());
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: unused_element
  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    data.add(BillItemModel(
        barcodeNo: "", productName: "", itemTotal: 0, quantity: 0, rate: 0));
    if (billItemScrollController.hasClients) {
      final position = billItemScrollController.position.maxScrollExtent;
      billItemScrollController.jumpTo(position);
    }

    cardController.addListener(
      () {
        calculatePaymentMethodBalance();
      },
    );
    cashController.addListener(
      () {
        calculatePaymentMethodBalance();
      },
    );
    pointsController.addListener(
      () {
        calculatePaymentMethodBalance();
      },
    );
    discountController.text = "0";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: defaultBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 0),
                        child: Text(
                          'Bill Items',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              data.add(BillItemModel(
                                  barcodeNo: "",
                                  productName: "",
                                  itemTotal: 0,
                                  quantity: 0,
                                  rate: 0));
                            });
                            if (billItemScrollController.hasClients) {
                              final position = billItemScrollController
                                  .position.maxScrollExtent;
                              billItemScrollController.jumpTo(position);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(16),
                              // ignore: deprecated_member_use
                              primary: defaultAccentColor),
                          child: const FaIcon(FontAwesomeIcons.plus),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                      left: 16.0,
                      right: 12.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 16, bottom: 0),
                            child: Text(
                              '  ',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 16, right: 16, bottom: 0),
                            child: Text(
                              'Barcode',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 16, right: 16, bottom: 0),
                            child: Text(
                              'Item',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 16, right: 16, bottom: 0),
                            child: Text(
                              'Qty',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 16, right: 16, bottom: 0),
                            child: Text(
                              'Rate',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 125,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 16, right: 16, bottom: 0),
                            child: Text(
                              'Total',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 55,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 16, right: 0, bottom: 0),
                            child: Text(
                              '   ',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: billItemScrollController,
                      itemBuilder: (context, index) {
                        _focusNodes.add(FocusNode());
                        return BillItem(
                          key: ValueKey(data[index]),
                          i: index,
                          updateCounter: _addRow,
                          barcodeFocusNode: _focusNodes,
                          deleteCounter: _delRow,
                          updateTotal: calculateCartTotal,
                          data: data,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 10,
                        color: defaultTextColor,
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                      ),
                      itemCount: data.length,
                    ),
                  ),
                  // ----- ROW 2 CONTENT -----
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 8),
                        child: Text(
                          'Add Item Without Label : ',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              data.add(BillItemModel(
                                  barcodeNo: "TMBRCODE",
                                  productName: "TEMPLE",
                                  itemTotal: 0,
                                  quantity: 1,
                                  rate: 0));
                            });
                            if (billItemScrollController.hasClients) {
                              final position = billItemScrollController
                                  .position.maxScrollExtent;
                              billItemScrollController.jumpTo(position);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              // ignore: deprecated_member_use
                              primary: defaultAccentColor),
                          child: Text(
                            'TEMPLE',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              data.add(BillItemModel(
                                  barcodeNo: "IDBRCODE",
                                  productName: "IDOL",
                                  itemTotal: 0,
                                  quantity: 1,
                                  rate: 0));
                            });
                            if (billItemScrollController.hasClients) {
                              final position = billItemScrollController
                                  .position.maxScrollExtent;
                              billItemScrollController.jumpTo(position);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              // ignore: deprecated_member_use
                              primary: defaultAccentColor),
                          child: Text(
                            'IDOL',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              data.add(BillItemModel(
                                  barcodeNo: "HDBRCODE",
                                  productName: "HOME DECOR",
                                  itemTotal: 0,
                                  quantity: 1,
                                  rate: 0));
                            });
                            if (billItemScrollController.hasClients) {
                              final position = billItemScrollController
                                  .position.maxScrollExtent;
                              billItemScrollController.jumpTo(position);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              // ignore: deprecated_member_use
                              primary: defaultAccentColor),
                          child: Text(
                            'HOME DECOR',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              data.add(BillItemModel(
                                  barcodeNo: "MISCCODE",
                                  productName: "MISC",
                                  itemTotal: 0,
                                  quantity: 1,
                                  rate: 0));
                            });
                            if (billItemScrollController.hasClients) {
                              final position = billItemScrollController
                                  .position.maxScrollExtent;
                              billItemScrollController.jumpTo(position);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              // ignore: deprecated_member_use
                              primary: defaultAccentColor),
                          child: Text(
                            'MISC',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 8),
                        child: Text(
                          'Total Qty',
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 8),
                        child: Text(
                          qtyTotal.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: defaultTextColor,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 8),
                        child: Text(
                          'Subtotal',
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 8),
                        child: Text(
                          cartTotal >= 0
                              ? '£${cartTotal.toStringAsFixed(2)}'
                              : '-£${(cartTotal * -1).toStringAsFixed(2)}',
                          // "₤${cartTotal.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            color: defaultTextColor,
            thickness: 1,
          ),
          Expanded(
            child: Container(
              color: Colors.white10,
              child: ListView(
                controller: ScrollController(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 0),
                    child: Text(
                      'Payment Options',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: defaultTextColor,
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 8),
                    child: Row(
                      children: [
                        // Expanded(
                        //   child: Text(
                        //     'DISCOUNT',
                        //     style: TextStyle(
                        //       fontSize: 22,
                        //       fontFamily: GoogleFonts.poppins().fontFamily,
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          flex: 3,
                          child: ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                // The button that is tapped is set to true, and the others to false.
                                for (int i = 0;
                                    i < _selectedDiscount.length;
                                    i++) {
                                  _selectedDiscount[i] = i == index;
                                }
                                calculateDiscount();
                                calculatePaymentMethodBalance();
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            selectedBorderColor: defaultTextColor,
                            selectedColor: defaultTextColor,
                            fillColor: defaultBgAccentColor,
                            borderColor: defaultTextColor,
                            hoverColor: const Color.fromARGB(64, 158, 158, 158),
                            color: defaultTextColor,
                            constraints: BoxConstraints.expand(
                              width:
                                  MediaQuery.of(context).size.width / 6 / 3.5,
                              height: 40,
                            ),
                            isSelected: _selectedDiscount,
                            children: discounts,
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _selectedDiscount[5],
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Focus(
                              onFocusChange: ((hasFocus) {
                                if (!hasFocus) {
                                  calculateDiscount();
                                }
                              }),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                ],
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                                controller: discountController,
                                onTap: () {
                                  _controller = discountController;
                                  log("discountController input hit");
                                },
                                onChanged: (value) {
                                  calculateDiscount();
                                  calculatePaymentMethodBalance();
                                },
                                onEditingComplete: () {
                                  calculateDiscount();
                                  calculatePaymentMethodBalance();
                                },
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    FontAwesomeIcons.sterlingSign,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Enter Discount Percent',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 25,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Text(
                          'Grand Total',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Text(
                          discountTotal >= 0
                              ? '£${discountTotal.toStringAsFixed(2)}'
                              : '-£${(discountTotal * -1).toStringAsFixed(2)}',
                          // "₤${discountTotal.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 8),
                    child: ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          _selectedPayments[index] = !_selectedPayments[index];
                          if (_selectedPayments[index] == false) {
                            if (index == 0) {
                              cashController.text = cardController.text;
                              cardController.clear();
                            } else if (index == 1) {
                              cardController.text = cashController.text;
                              cashController.clear();
                            } else {
                              pointsController.clear();
                            }
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: defaultTextColor,
                      selectedColor: defaultTextColor,
                      fillColor: defaultBgAccentColor,
                      borderColor: defaultTextColor,
                      constraints: BoxConstraints.expand(
                        width: MediaQuery.of(context).size.width / 3 / 3.5,
                        height: 40,
                      ),
                      isSelected: _selectedPayments,
                      children: paymentMethods,
                    ),
                  ),
                  Visibility(
                    visible: _selectedPayments[0],
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 16, bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'CARD',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: FocusTraversalOrder(
                              order: const NumericFocusOrder(1),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                ],
                                controller: cardController,
                                autofocus: _selectedPayments[0],
                                onTap: () {
                                  _controller = cardController;
                                  log("card input hit");
                                },
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.sterlingSign,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Enter Card Value',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _selectedPayments[1],
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 16, bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'CASH',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: FocusTraversalOrder(
                              order: const NumericFocusOrder(2),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                ],
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                                controller: cashController,
                                onTap: () {
                                  _controller = cashController;
                                  log("cash input hit");
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.sterlingSign,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Enter Cash Value',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _selectedPayments[2],
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 16, bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'POINTS',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: FocusTraversalOrder(
                              order: const NumericFocusOrder(3),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                ],
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                                controller: pointsController,
                                onTap: () {
                                  _controller = pointsController;
                                  log("points input hit");
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.sterlingSign,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Enter Points Value',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 25,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Text(
                          'Balance',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Text(
                          balance >= 0
                              ? '£${balance.toStringAsFixed(2)}'
                              : '-£${(balance * -1).toStringAsFixed(2)}',
                          // "₤${balance.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 5,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4, left: 16, right: 16, bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          'No Exchange / No refund',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: defaultTextColor,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 16, right: 16, bottom: 0),
                          child: Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              value: isNoExch,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              onChanged: (value) {
                                setState(() {
                                  isNoExch = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: defaultTextColor,
                    thickness: 1,
                    indent: 15,
                    endIndent: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(170, 119, 221, 119),
                              padding: const EdgeInsets.all(18),
                            ),
                            onPressed: () {
                              cardController.text =
                                  discountTotal.toStringAsFixed(2);
                              cashController.text = "";
                              pointsController.text = "";
                              saveBillState();
                            },
                            child: Text(
                              'CARD BILL',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(170, 119, 221, 119),
                                padding: const EdgeInsets.all(18)),
                            onPressed: () {
                              cashController.text =
                                  discountTotal.toStringAsFixed(2);
                              cardController.text = "";
                              pointsController.text = "";
                              saveBillState();
                            },
                            child: Text(
                              'CASH BILL',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(18),
                                // ignore: deprecated_member_use
                                primary: tilePrimaryColor),
                            onPressed: () {
                              tabController.removeTab(tabindex);
                              if (tabController.tabs.isEmpty) {
                                count += 1;
                                tabController.addTab(
                                  TabData(
                                    text: 'BILL $count',
                                    content: const BillPage(),
                                    keepAlive: true,
                                  ),
                                );
                                hasData['BILL $count'] = false;
                              }
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(18),
                                // ignore: deprecated_member_use
                                primary: defaultAccentColor),
                            onPressed: () => {
                              saveBillState(),
                            },
                            child: Text(
                              'FINALIZE',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 16, bottom: 0, right: 13, left: 13),
                    child: CustomKeyboard(
                      key: Key("Key"),
                      onBackspace: _backspace,
                      onTextInput: _insertText,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 65,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 3,
                              bottom: 0,
                              right: 13,
                              left: 16,
                            ),
                            child: Material(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (controllerName == "rate") {
                                    //FocusScope.of(context).nextFocus();
                                    _addRow(data.length + 1);
                                  }
                                  if (controllerName == "qty") {
                                    _addRow(data.length + 1);
                                    //FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  // ignore: deprecated_member_use
                                  primary: defaultAccentColor,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "ENTER",
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: 26,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BillItem extends StatefulWidget {
  final int i;
  final dynamic updateCounter;
  final dynamic deleteCounter;
  final dynamic updateTotal;
  final List<FocusNode> barcodeFocusNode;
  final List<BillItemModel> data;

  // ignore: use_super_parameters
  const BillItem({
    Key? key,
    required this.i,
    required this.updateCounter,
    required this.deleteCounter,
    required this.updateTotal,
    required this.barcodeFocusNode,
    required this.data,
  }) : super(key: key);

  @override
  State<BillItem> createState() => _BillItemState();
}

class _BillItemState extends State<BillItem> {
  var barcodeController = TextEditingController();
  var qtyController = TextEditingController();
  var rateController = TextEditingController();
  FocusNode qtyFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();

  String headline = "";
  String rate = "";
  String total = "";
  bool isNormalRow = true;

  Future<void> query() async {
    rate = "0.0";
    if (headline == "MISC" ||
        headline == "TEMPLE" ||
        headline == "IDOL" ||
        headline == "HOME DECOR") {
      widget.data[widget.i].barcodeNo = barcodeController.text;
      return;
    }

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('http://$apiURL/get_updated_price'));
    request.body = json.encode({
      "mac_id": displayDeviceId,
      "trigger": "1",
      "uniqueNumber": barcodeController.text
    });
    request.headers.addAll(headers);

    try {
      Duration timeLimit = const Duration(seconds: 1);
      http.StreamedResponse response = await request.send().timeout(timeLimit);
      if (response.statusCode == 200) {
        String data = await response.stream.bytesToString();
        var jsonData = json.decode(data);
        List productData = json.decode(jsonData["Product_Data"]);
        if (productData.isNotEmpty) {
          if (isNormalRow) {
            rate = productData[0]["updatedPrice"];
          } else {
            rate = (double.tryParse(productData[0]["updatedPrice"])! * -1)
                .toStringAsFixed(2);
          }
          rateController.text = rate.toString();
        }
      } else {
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log(e.toString());
    }

    Box<ProductData> productbox = Box<ProductData>(store);
    Query<ProductData> query = productbox
        .query(ProductData_.uniqueNo.equals(barcodeController.text))
        .build();
    List<ProductData> products = query.find();

    if (products.isNotEmpty) {
      headline = products[0].headline!;
      if (rate == "0.0" || rate == "") {
        if (isNormalRow) {
          rate = products[0].cipher!;
        } else {
          rate =
              (-1 * double.tryParse(products[0].cipher!)!).toStringAsFixed(2);
        }
        rateController.text = rate.toString();
      }

      if (qtyController.text.isEmpty || qtyController.text == "0") {
        qtyController.text = "1";
      }

      widget.data[widget.i].indexNo = widget.i;
      widget.data[widget.i].barcodeNo = barcodeController.text;
      widget.data[widget.i].productName = headline;
      widget.data[widget.i].rate = double.parse(rate);
      widget.data[widget.i].quantity = int.parse(qtyController.text);
      widget.data[widget.i].itemTotal =
          int.parse(qtyController.text) * double.parse(rate);

      calculateItemTotal();
      //qtyFocusNode.requestFocus();
      _controller = qtyController;
      controllerName = "qty";
      widget.updateCounter(widget.i);
    } else {
      headline = "Not Found";
      rate = "";
      rateController.text = rate.toString();
      total = "";
      qtyFocusNode.requestFocus();
    }
    query.close;
    setState(() {});
  }

  void calculateItemTotal() {
    if (rateController.text == "") {
      rate = "0.0";
    } else {
      rate = rateController.text;
    }
    if (headline == "MISC" ||
        headline == "TEMPLE" ||
        headline == "IDOL" ||
        headline == "HOME DECOR") {
      widget.data[widget.i].rate = double.parse(rate);
    }

    if (rate == "-" || !isNumeric(rate)) {
      total = "";
      setState(() {});
      return;
    }
    if (qtyController.text.isNotEmpty && rate.isNotEmpty) {
      total =
          (double.parse(qtyController.text) * double.parse(rate)).toString();
      widget.data[widget.i].quantity = int.parse(qtyController.text);
      widget.data[widget.i].itemTotal =
          int.parse(qtyController.text) * double.parse(rate);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //qtyController.addListener(calculateItemTotal);
    rateController.addListener(calculateItemTotal);
    widget.barcodeFocusNode[widget.i].requestFocus();
    _controller = barcodeController;
    controllerName = "barcode";
    barcodeController.text = widget.data[widget.i].barcodeNo!;
    headline = widget.data[widget.i].productName!;
    qtyController.text = widget.data[widget.i].quantity!.toString();
    rate = widget.data[widget.i].rate!.toString();
    rateController.text = rate;
    total = widget.data[widget.i].itemTotal!.toString();
    isNormalRow = isNormal;
    if (headline == "MISC" ||
        headline == "TEMPLE" ||
        headline == "IDOL" ||
        headline == "HOME DECOR") {
      rateFocusNode.requestFocus();
      if (rate == "0.0") {
        rateController.text = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      child: Container(
        height: 50,
        decoration: isNormalRow
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(136, 244, 67, 54),
              ),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 16, right: 0, bottom: 0),
                child: Text(
                  (widget.i + 1).toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: defaultTextColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 150,
              child: FocusTraversalOrder(
                order: NumericFocusOrder((widget.i + 1) * 3 - 2),
                child: TextField(
                  autofocus: true,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onTap: () {
                    _controller = barcodeController;
                    controllerName = "barcode";
                  },
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                  onSubmitted: (value) {
                    widget.barcodeFocusNode[widget.i].requestFocus();
                    if (barcodeController.text.length > 7) {
                      query();
                    } else {
                      if (barcodeController.text == "RETURN") {
                        isNormal = !isNormal;
                        isNormalRow = isNormal;
                        barcodeController.text = "";
                        super.setState(() {});
                      }
                    }
                  },
                  onChanged: (value) {
                    widget.barcodeFocusNode[widget.i].requestFocus();
                    if (barcodeController.text.length > 7) {
                      query();
                    } else {
                      if (barcodeController.text == "RETURN") {
                        isNormal = !isNormal;
                        isNormalRow = isNormal;
                        barcodeController.text = "";
                        super.setState(() {});
                      }
                    }
                  },
                  controller: barcodeController,
                  focusNode: widget.barcodeFocusNode[widget.i],
                  decoration: InputDecoration(
                    hintText: 'Barcode',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    filled: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    fillColor: tileSecondaryColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: tilePrimaryColor!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: tilePrimaryColor!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: tilePrimaryColor!),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 16, right: 16, bottom: 0),
                child: Text(
                  headline,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: defaultTextColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              child: Focus(
                onFocusChange: ((hasFocus) {
                  if (!hasFocus) {
                    calculateItemTotal();
                    widget.updateTotal();
                  }
                }),
                child: FocusTraversalOrder(
                  order: NumericFocusOrder((widget.i + 1) * 3 - 1),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                    ),
                    controller: qtyController,
                    focusNode: qtyFocusNode,
                    onTap: () {
                      _controller = qtyController;
                      controllerName = "qty";
                    },
                    onChanged: (value) {
                      if (barcodeController.text.isNotEmpty) {
                        calculateItemTotal();
                        widget.updateTotal();
                      }
                    },
                    onSubmitted: (value) {
                      if (barcodeController.text.isNotEmpty) {
                        calculateItemTotal();
                        widget.updateTotal();
                        //widget.updateCounter(widget.i);
                        rateFocusNode.requestFocus();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Qty',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      fillColor: tileSecondaryColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: tilePrimaryColor!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: tilePrimaryColor!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: tilePrimaryColor!),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              child: Focus(
                onFocusChange: ((hasFocus) {
                  if (!hasFocus) {
                    rate = rateController.text;
                    if (rate.isNotEmpty && rate != "-") {
                      widget.data[widget.i].rate = double.parse(rate);
                    }
                    if (!isNormalRow) {
                      if (!rate.contains("-")) {
                        rate = "-$rate";
                        rateController.text = rate;
                      }
                    }
                    calculateItemTotal();
                    widget.updateTotal();
                  } else {
                    _controller = rateController;
                    controllerName = "rate";
                  }
                }),
                child: FocusTraversalOrder(
                  order: NumericFocusOrder((widget.i + 1) * 3 - 0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    // inputFormatters: [
                    //   // FilteringTextInputFormatter.allow(
                    //   //     RegExp('([-]?)([0-9]+)([.]?)([0-9]+)')),
                    //   isNormalRow == true
                    //       ? PositiveRateValueFormatter()
                    //       : NegativeRateValueFormatter(),
                    // ],
                    focusNode: rateFocusNode,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                    ),
                    controller: rateController,
                    onTap: () {
                      _controller = rateController;
                      controllerName = "rate";
                    },
                    onChanged: (value) {
                      if (barcodeController.text.isNotEmpty) {
                        rate = rateController.text;
                        if (rate.isNotEmpty &&
                            value != "-" &&
                            isNumeric(value) &&
                            rate != "-") {
                          widget.data[widget.i].rate = double.parse(rate);
                        }
                        if (!isNormalRow) {
                          if (!rate.contains("-")) {
                            rate = "-$rate";
                            rateController.text = rate;
                          }
                        }
                        rateController.selection = TextSelection.collapsed(
                            offset: rateController.text.length);
                        calculateItemTotal();
                        widget.updateTotal();
                      }
                    },
                    onSubmitted: (value) {
                      if (barcodeController.text.isNotEmpty) {
                        rate = rateController.text;
                        if (!isNormalRow) {
                          if (!rate.contains("-")) {
                            rate = "-$rate";
                            rateController.text = rate;
                          }
                        }
                        if (rate.isNotEmpty) {
                          widget.data[widget.i].rate = double.parse(rate);
                        }
                        calculateItemTotal();
                        widget.updateTotal();
                        widget.updateCounter(widget.i);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Rate',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      fillColor: tileSecondaryColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: tilePrimaryColor!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: tilePrimaryColor!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: tilePrimaryColor!),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 16, right: 16, bottom: 0),
                child: Text(
                  // "₤$total",
                  total == ""
                      ? "₤"
                      : double.parse(total) < 0
                          ? "-₤${(double.parse(total) * -1).toStringAsFixed(2)}"
                          : "₤${double.parse(total).toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: defaultTextColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 56, 44),
                      borderRadius: const BorderRadius.all(Radius.circular(17)),
                      border: Border.all(
                          color: const Color.fromARGB(255, 224, 56, 44)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        widget.deleteCounter(widget.i);
                      },
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        size: 15,
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

void _backspace() {
  final text = _controller.text;
  if (text == "-") return;
  final textSelection = _controller.selection;
  final selectionLength = textSelection.end - textSelection.start;
  // There is a selection.
  if (selectionLength > 0) {
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start,
      extentOffset: textSelection.start,
    );
    return;
  }
  // The cursor is at the beginning.
  if (textSelection.start == 0) {
    return;
  }
  // Delete the previous character
  final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
  final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
  final newStart = textSelection.start - offset;
  final newEnd = textSelection.start;
  final newText = text.replaceRange(
    newStart,
    newEnd,
    '',
  );
  _controller.text = newText;
  _controller.selection = textSelection.copyWith(
    baseOffset: newStart,
    extentOffset: newStart,
  );
}

bool _isUtf16Surrogate(int value) {
  return value & 0xF800 == 0xD800;
}

void _insertText(String myText) {
  final text = _controller.text;
  if (text.contains(".") && myText == ".") {
    return;
  }

  final textSelection = _controller.selection;

  if (textSelection.start == -1 || textSelection.end == -1) {
    _controller.text += myText;
    return;
  }
  final newText = text.replaceRange(
    textSelection.start,
    textSelection.end,
    myText,
  );

  final myTextLength = myText.length;
  _controller.text = newText;
  _controller.selection = textSelection.copyWith(
    baseOffset: textSelection.start + myTextLength,
    extentOffset: textSelection.start + myTextLength,
  );
}
