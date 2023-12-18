// ignore: unused_import
import 'dart:convert';
import 'dart:developer';
// ignore: unused_import
import 'package:elegant_notification/elegant_notification.dart';
// ignore: unused_import
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: duplicate_import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/objectbox.g.dart';
import 'package:reporting_app/util/side_menu.dart';
import 'package:tabbed_view/tabbed_view.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;
// ignore: unused_import
import 'package:printing/printing.dart';
import '../../database.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

// ignore: unused_element
var _controller = TextEditingController();
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
    return "$barcodeNo,$productName,$quantity,$rate,$itemTotal";
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

class MobileGenerateBillPage extends StatefulWidget {
  // ignore: use_super_parameters
  const MobileGenerateBillPage({Key? key}) : super(key: key);

  @override
  State<MobileGenerateBillPage> createState() => _MobileGenerateBillPageState();
}

class _MobileGenerateBillPageState extends State<MobileGenerateBillPage> {
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
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
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
            fontSize: 16,
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
        tabCloseInterceptor: _tabCloseInterceptor,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(
            TabButton(
              icon: IconProvider.data(
                Icons.add,
              ),
              iconSize: 25,
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

  static List<Widget> discounts = <Widget>[
    Text('0', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Text('5', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Text('10', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Text('15', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Text('20', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
    Text('OTH', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
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
      calculateCartTotal();
      calculateDiscount();
      calculatePaymentMethodBalance();
    });
  }

  _delRow(i) {
    setState(() {
      // data.removeAt(i);
      data.removeWhere((item) => item.indexNo == data[i].indexNo);
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
    });
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
        discountTotal = cartTotal * 0.85;
      } else if (_selectedDiscount[4]) {
        discountTotal = cartTotal * 0.8;
      } else if (_selectedDiscount[5]) {
        if (discountController.text.isNotEmpty) {
          if (double.parse(discountController.text) >= 0 &&
              double.parse(discountController.text) <= 100) {
            discountTotal =
                cartTotal * (100 - double.parse(discountController.text)) / 100;
          }
        } else {
          discountTotal = cartTotal * 1;
        }
      }
      discountTotal = discountTotal.ceil() / 1.0;
    });
  }

  calculatePaymentMethodBalance() {
    // Include provision for fetching points somehow
    setState(() {
      balance = discountTotal;
      double cash = 0, card = 0, points = 0;

      if (cashController.text.isNotEmpty) {
        cash = double.parse(cashController.text);
      }
      if (cardController.text.isNotEmpty) {
        card = double.parse(cardController.text);
      }
      if (pointsController.text.isNotEmpty) {
        points = double.parse(pointsController.text);
      }

      balance -= (cash + card + points);
      log(balance.toString());
    });
  }

  saveBillState() {
    log("Saving new bill");

    String saleNumber = "";
    DateTime saleCreatedDate = DateTime.now();
    String saleTotal = cartTotal.toString();
    String saleDiscount = "0";
    String saleCard = cardController.text;
    String saleCash = cashController.text;
    String salePoints = pointsController.text;
    String saleBalance = balance.toString();
    List<String> saleData = List.empty(growable: true);

    if (_selectedDiscount[0]) {
      saleDiscount = "0";
    } else if (_selectedDiscount[1]) {
      saleDiscount = "5";
    } else if (_selectedDiscount[2]) {
      saleDiscount = "10";
    } else if (_selectedDiscount[3]) {
      saleDiscount = "15";
    } else if (_selectedDiscount[4]) {
      saleDiscount = "20";
    } else if (_selectedDiscount[5]) {
      if (discountController.text.isNotEmpty) {
        saleDiscount = discountController.text;
      } else {
        saleDiscount = "0";
      }
    }

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
    Map<String, BillItemModel> items = {};

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
      if (items.containsKey(item.barcodeNo)) {
        BillItemModel existing = items[item.barcodeNo]!;
        existing.quantity = existing.quantity! + item.quantity!;
        existing.itemTotal = existing.itemTotal! + item.itemTotal!;
      } else {
        items.addAll({
          item.barcodeNo!: BillItemModel(
            indexNo: item.indexNo,
            barcodeNo: item.barcodeNo,
            itemTotal: item.itemTotal,
            productName: item.productName,
            quantity: item.quantity,
            rate: item.rate,
          )
        });
      }
    }

    for (BillItemModel item in items.values) {
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
    log("$id Added to biils");
    tabController.removeTab(tabController.selectedIndex!);

    Box<DailySaleData> dailySaleBox = Box<DailySaleData>(store);
    Query<DailySaleData> query2 = dailySaleBox.query().build();
    List<DailySaleData> dates = query2.find().reversed.toList();
    query2.close();

    DateTime now = DateTime.now();
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
      dates[0].salePoints += salePoints.isEmpty ? 0 : double.parse(salePoints);
      store.box<DailySaleData>().put(dates[0]);
    }
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text(
          "Bill Saved - Success",
          style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Bill successfully saved as $saleNumber",
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(alertContext),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(defaultAccentColor),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    data.add(BillItemModel(
        barcodeNo: "", productName: "", itemTotal: 0, quantity: 0, rate: 0));

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
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: defaultBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 16, right: 8, bottom: 0),
                        child: Text(
                          'Bill Items',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
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
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(2),
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
                      top: 0,
                      bottom: 0,
                      left: 16.0,
                      right: 12.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 8, bottom: 0),
                            child: Text(
                              '  ',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 8, right: 8, bottom: 0),
                            child: Text(
                              'Barcode',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 8, right: 8, bottom: 0),
                            child: Text(
                              'Headline',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 8, right: 8, bottom: 0),
                            child: Text(
                              'Qty',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 8, right: 8, bottom: 0),
                            child: Text(
                              'Rate',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 8, right: 8, bottom: 0),
                            child: Text(
                              'Total',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 8, right: 0, bottom: 0),
                            child: Text(
                              '   ',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 650,
                        child: ListView.separated(
                          controller: ScrollController(),
                          scrollDirection: Axis.vertical,
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
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Text(
                          'Bill Total',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
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
                          "₤$cartTotal",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
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
                    endIndent: 15,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white10,
              child: ListView(
                // controller: ScrollController(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 16, right: 16, bottom: 0),
                        child: Text(
                          'Payment Options',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
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
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            'DIS %',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ),
                        Expanded(
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
                                  MediaQuery.of(context).size.width / 6 / 1.6,
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
                          top: 8, left: 16, right: 16, bottom: 8),
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
                                    FontAwesomeIcons.percent,
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
                    endIndent: 15,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Text(
                          'Grand Total',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
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
                          "₤${discountTotal.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
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
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 16),
                    child: ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          _selectedPayments[index] = !_selectedPayments[index];
                          if (_selectedPayments[index] == false) {
                            if (index == 0) {
                              cardController.clear();
                            } else if (index == 1) {
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
                        width: MediaQuery.of(context).size.width / 3 / 1.25,
                        height: 30,
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
                                fontSize: 16,
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
                                fontSize: 16,
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
                                fontSize: 14,
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
                    endIndent: 15,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Text(
                          'Balance',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
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
                          "₤${balance.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
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
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          '* NO EXCHANGE / NO REFUND *',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: defaultTextColor,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 16, right: 16, bottom: 0),
                          child: Transform.scale(
                            scale: 1.5,
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
                    endIndent: 15,
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
                            onPressed: () => {},
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                fontSize: 18,
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
                              'SAVE',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

  String headline = "";
  String rate = "";
  String total = "";

  void query() {
    Box<ProductData> productbox = Box<ProductData>(store);
    Query<ProductData> query = productbox
        .query(ProductData_.uniqueNo.equals(barcodeController.text))
        .build();
    List<ProductData> products = query.find();

    if (products.isNotEmpty) {
      headline = products[0].headline!;
      rate = products[0].cipher!;
      rateController.text = rate.toString();

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
      widget.updateCounter(widget.i);
    } else {
      headline = "Not Found";
      rate = "";
      rateController.text = rate.toString();
      total = "";
    }
    query.close;
    setState(() {});
  }

  void calculateItemTotal() {
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
    qtyController.addListener(calculateItemTotal);
    rateController.addListener(calculateItemTotal);
    widget.barcodeFocusNode[widget.i].requestFocus();
    _controller = barcodeController;
    barcodeController.text = widget.data[widget.i].barcodeNo!;
    headline = widget.data[widget.i].productName!;
    qtyController.text = widget.data[widget.i].quantity!.toString();
    rate = widget.data[widget.i].rate!.toString();
    rateController.text = rate;
    total = widget.data[widget.i].itemTotal!.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.transparent),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, left: 8, right: 0, bottom: 0),
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
            SizedBox(
              width: 100,
              child: FocusTraversalOrder(
                order: NumericFocusOrder((widget.i + 1) * 3 - 3),
                child: TextField(
                  autofocus: true,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onTap: () {
                    _controller = barcodeController;
                  },
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    if (barcodeController.text.length > 7) {
                      query();
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
                    isDense: true,
                    // ignore: prefer_const_constructors
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
            SizedBox(
              width: 175,
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
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 16, right: 16, bottom: 0),
                child: Focus(
                  onFocusChange: ((hasFocus) {
                    if (!hasFocus) {
                      calculateItemTotal();
                      widget.updateTotal();
                    }
                  }),
                  child: FocusTraversalOrder(
                    order: NumericFocusOrder((widget.i + 1) * 3 - 2),
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
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Qty',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        filled: true,
                        isDense: true,
                        // ignore: prefer_const_constructors
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
            ),
            SizedBox(
              width: 80,
              child: Focus(
                onFocusChange: ((hasFocus) {
                  if (!hasFocus) {
                    rate = rateController.text;
                    if (rate.isNotEmpty) {
                      widget.data[widget.i].rate = double.parse(rate);
                    }
                    calculateItemTotal();
                    widget.updateTotal();
                  } else {
                    _controller = rateController;
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
                    controller: rateController,
                    onTap: () {
                      _controller = rateController;
                    },
                    onChanged: (value) {
                      if (barcodeController.text.isNotEmpty) {
                        rate = rateController.text;
                        if (rate.isNotEmpty) {
                          widget.data[widget.i].rate = double.parse(rate);
                        }

                        calculateItemTotal();
                        widget.updateTotal();
                      }
                    },
                    onSubmitted: (value) {
                      if (barcodeController.text.isNotEmpty) {
                        rate = rateController.text;
                        if (rate.isNotEmpty) {
                          widget.data[widget.i].rate = double.parse(rate);
                        }
                        calculateItemTotal();
                        widget.updateTotal();
                        //widget.updateCounter(widget.i);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Rate',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      filled: true,
                      isDense: true,
                      // ignore: prefer_const_constructors
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 16, right: 16, bottom: 0),
                child: Text(
                  "₤$total",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: defaultTextColor,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.all(0),
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
