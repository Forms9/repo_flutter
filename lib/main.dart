import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:objectbox/objectbox.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/screens/Login/responsive_login/desktop_login.dart';
import 'package:reporting_app/screens/generate_bill/generate_bill.dart';
import 'package:window_manager/window_manager.dart';
import 'constants.dart';

late ObjectBox objectBox;
late Store store;
late User cUser;
late String _deviceId;

const String apiURL = "213.123.212.191";
// const String apiURL = "192.168.1.26:5000";
String storeType = "HERI";
String terminal = "1";
// String displayDeviceId = "UNKNOWN";
// String printerName = "Microsoft Print to PDF";
String printerName = "Bill Printer";
String displayDeviceId = "32444335-3432-3835-5639-393834324435";
bool saleMode = false;

int count = 0;

bool connectionStatus = false;

initPlatformState() async {
  String? deviceId;

  // Platform messages may fail, so we use a try/catch PlatformException.
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      deviceId = await FlutterUdid.udid;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
  } else {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
  }

  _deviceId = deviceId!;
  displayDeviceId = _deviceId.trim();
  log("deviceId->$_deviceId" as num);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();
  store = objectBox.store;
  //initPlatformState();
  await Future.delayed(const Duration(seconds: 3));
  if (Platform.isWindows) {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    windowManager.setFullScreen(true);
  }
  Box<POSNumber> posbox = Box<POSNumber>(store);
  Query<POSNumber> query = posbox.query().build();
  List<POSNumber> poslist = query.find();
  if (poslist.isNotEmpty) {
    terminal = poslist[0].posNumber.toString();
  } else {
    terminal = "1";
  }

  Box<SaleMode> saleBox = Box<SaleMode>(store);
  Query<SaleMode> query2 = saleBox.query().build();
  List<SaleMode> saleList = query2.find();
  if (saleList.isNotEmpty) {
    saleMode = saleList[0].mode;
  }

  // Periodic API Calls
  Timer.periodic(
    const Duration(minutes: 15),
    (timer) {
      // ignore: avoid_print
      print('Timer triggered at ${DateTime.now()}');
      try {
        // getProductData();
        updateSaleData();
      } catch (e) {
        log(e.toString() as num);
      }
    },
  );

  runApp(const MyApp());
}

bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  return true;
}

class MyApp extends StatefulWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reporting App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      // ignore: prefer_const_constructors
      home: DesktopLoginPage(),
    );
  }

  @override
  void onWindowFocus() {
    setState(() {});
  }
}
