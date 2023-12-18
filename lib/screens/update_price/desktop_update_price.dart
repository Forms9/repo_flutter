import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:objectbox/objectbox.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/objectbox.g.dart';
import 'package:reporting_app/screens/generate_bill/mobile_generate_bill.dart';
import 'package:reporting_app/util/side_menu.dart';

var _controller = TextEditingController();

class DesktopUpdatePrice extends StatefulWidget {
  const DesktopUpdatePrice({super.key});

  @override
  State<DesktopUpdatePrice> createState() => _DesktopUpdatePriceState();
}

class _DesktopUpdatePriceState extends State<DesktopUpdatePrice> {
  TextEditingController barcode = TextEditingController();
  TextEditingController price = TextEditingController();
  String getProductName(String barcode) {
    Query<ProductData> query = Box<ProductData>(store)
        .query(ProductData_.uniqueNo.equals(barcode))
        .build();
    List<ProductData> products = query.find();
    query.close();
    if (products.isNotEmpty) {
      return products[0].productName!;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Update Price',
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
        child: Container(
          margin: const EdgeInsets.only(left: 300),
          child: Row(
            children: [
              // Drawer content
              // const SideMenu(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "Update Price",
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: defaultTextColor,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                            right: 10,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Barcodes",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: defaultIconColor,
                                ),
                              ),
                              SizedBox(
                                height: 400,
                                width: 250,
                                child: RawScrollbar(
                                  child: TextField(
                                    controller: barcode,
                                    autofocus: true,
                                    minLines: null,
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    style: GoogleFonts.poppins(
                                      color: kPrimaryLightColor,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      fillColor: Colors.white24,
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: "Enter your Barcode",
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'New Price  ',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: defaultTextColor,
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: _controller,
                                autofocus: true,
                                keyboardType: TextInputType.none,
                                style: GoogleFonts.poppins(
                                  color: kPrimaryLightColor,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.poundSign,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  hintText: "New Price",
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
                            const SizedBox(
                              width: 300,
                              height: 350,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: CustomKeyboardTablet(
                                  key: Key("Key"),
                                  onBackspace: _backspace,
                                  onTextInput: _insertText,
                                ),
                              ),
                            ),
                            // update button
                            const SizedBox(
                              width: 300,
                              height: 10,
                            ),
                            SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_controller.text == "") {
                                    customOKAlertDialog(
                                        context,
                                        'Price Cannot Be Empty',
                                        'Please Enter New Price',
                                        'OK');
                                    return;
                                  }
                                  List<String> barcodeList =
                                      List.empty(growable: true);
                                  barcodeList =
                                      barcode.text.trim().split('\n').toList();
                                  barcodeList = barcodeList.toSet().toList();
                                  List updatedPrices =
                                      List.empty(growable: true);
                                  for (String x in barcodeList) {
                                    if (x == "") barcodeList.remove(x);
                                    updatedPrices.add(UpdatePriceModel(
                                      barcodeNo: x,
                                      productName: getProductName(x),
                                      rate: double.parse(_controller.text),
                                    ));
                                  }
                                  var headers = {
                                    'Content-Type': 'application/json'
                                  };
                                  var request = http.Request(
                                      'POST',
                                      Uri.parse(
                                          'http://$apiURL/save_updated_price'));
                                  request.body = json.encode({
                                    "mac_id": displayDeviceId,
                                    "products": barcodeList
                                  });
                                  request.headers.addAll(headers);

                                  http.StreamedResponse response =
                                      await request.send();

                                  if (response.statusCode == 200) {
                                    log(await response.stream.bytesToString());
                                  } else {
                                    log(response.reasonPhrase.toString());
                                    log(await response.stream.bytesToString());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  primary: defaultAccentColor,
                                ),
                                child: Text(
                                  'UPDATE',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
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
