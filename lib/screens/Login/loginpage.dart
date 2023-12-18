import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/controllers/MenuAppController.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/objectbox.g.dart';
import 'package:reporting_app/screens/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

final username = TextEditingController();
final password = TextEditingController();
bool remember = true;
List<User> userlist = List.empty(growable: true);

void _usernameListener() {}
void _passwordListener() {}

loginfunction(BuildContext context) async {
  Box<User> userbox = Box<User>(store);
  Query<User> query =
      userbox.query(User_.username.equals(username.text)).build();
  List<User> users = query.find();
  log("reached login");
  if (users.isNotEmpty) {
    if (users[0].password == password.text) {
      cUser = users[0];

      final loginPref = await SharedPreferences.getInstance();

      if (remember) {
        await loginPref.setString('username', cUser.username);
        await loginPref.setString('password', cUser.password);
      } else {
        await loginPref.remove('username');
        await loginPref.remove('password');
      }

      //getProductData();
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => MenuAppController(),
              ),
              // Add other providers if needed
            ],
            child: DashboardScreen(),
          ),
        ),
      );
    } else {
      {
        customOKAlertDialog(context, 'Error',
            'Wrong username/password. Please try again.', 'OK');
        log("BAD PASSWORD");
      }
    }
  } else {
    customOKAlertDialog(
        context, 'Error', 'Wrong username/password. Please try again.', 'OK');
    log("BAD USERNAME");
  }
  username.text = "";
  password.text = "";
  query.close();
}

Future<void> getUsers(String storename) async {
  try {
    log("Getting Users for this Store --------");
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('http://$apiURL/get_user_byStore'));
    request.body = json.encode({
      "mac_id": displayDeviceId,
      "applier_username": "Superuser",
      "applier_password": "Export@99",
      "store": storename
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Box<User> userbox = Box<User>(store);
      Query<User> query = userbox.query().build();
      query.remove();
      userlist = List.empty(growable: true);

      String data = await response.stream.bytesToString();
      var jsonData = json.decode(data);
      if (jsonData.toString().contains("403") ||
          jsonData
              .toString()
              .contains("You donot have the necessary permissions")) {
        Box<User> userbox = Box<User>(store);
        Query<User> query = userbox.query(User_.type.equals('ADMIN')).build();
        List<User> admins = query.find();
        query.close();
        if (admins.isEmpty) {
          final user = User(
              username: "Superuser",
              password: "Export@99",
              type: "ADMIN",
              store: storename);
          var id = store.box<User>().put(user);
          log(id.toString());
          log("New default admin generated --------");
        }
      } else {
        final user = User(
            username: "Superuser",
            password: "Export@99",
            type: "ADMIN",
            store: storename);
        var id = store.box<User>().put(user);
        log(id.toString());
        log("New default admin generated --------");
        var userData = json.decode(jsonData["user_data"]);
        for (var user in userData) {
          final User newUser = User(
              username: user['username'],
              password: user['password'],
              type: user['user_type'],
              store: user['store'].toString());
          // ignore: unused_local_variable
          var id = store.box<User>().put(newUser);
          log("Added ${user['username']}");
          userlist.add(newUser);
        }
        storeType = storename;
      }
    } else {
      log(response.reasonPhrase.toString());
    }
  } catch (e) {
    log(e.toString());
  }
}

class LoginPage extends StatefulWidget {
  // ignore: use_super_parameters
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  initState() {
    super.initState();
    username.addListener(_usernameListener);
    password.addListener(_passwordListener);
    // Box<User> userbox = Box<User>(store);
    // Query<User> query = userbox.query(User_.type.equals('ADMIN')).build();
    // List<User> admins = query.find();
    // query.close();

    // // Fetch users using Django API if the condition is satisfied.
    // if (admins.isEmpty) {
    //   final user = User(
    //       username: "Superuser",
    //       password: "Export@99",
    //       type: "ADMIN",
    //       store: "CELE");
    //   var id = store.box<User>().put(user);
    //   log(id.toString());
    //   log("New default admin generated --------");
    //}
    // try {
    //   getUsers();
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
          // Add other providers if needed
        ],
        child: DashboardScreen(),
      ),
    );
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }
}
