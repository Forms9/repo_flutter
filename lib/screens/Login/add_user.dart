import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/database.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/screens/Login/responsive_login/desktop_login.dart';

final username = TextEditingController();
final password = TextEditingController();
final confirmpassword = TextEditingController();

createUser(BuildContext context, List<bool> selectedTypes) async {
  try {
    if (username.text.isEmpty) {
      customOKAlertDialog(
          context, 'Error', 'Passwords do not match. Please try again.', 'OK');
      log("BAD PASSWORD");
      return;
    }
    if (password.text != confirmpassword.text || password.text.isEmpty) {
      customOKAlertDialog(
          context, 'Error', 'Passwords do not match. Please try again.', 'OK');
      log("BAD PASSWORD");
      return;
    }
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://$apiURL/create_new_user'));
    request.body = json.encode({
      "mac_id": displayDeviceId,
      "applier_username": cUser.username,
      "applier_password": cUser.password,
      "username": username.text,
      "password": password.text,
      "store": cUser.store,
      "user_type": selectedTypes[0] ? "ADMIN" : "USER",
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseData = response.stream.bytesToString().toString();
      if (responseData.contains("Exist")) {
        // ignore: use_build_context_synchronously
        customOKAlertDialog(
            context, 'Error', 'User Already Exist. Please try again.', 'OK');
      } else {
        final User user = User(
            username: username.text,
            password: password.text,
            type: selectedTypes[0] ? "ADMIN" : "USER",
            store: cUser.store);
        // ignore: unused_local_variable
        var id = store.box<User>().put(user);
        // ignore: use_build_context_synchronously
        customOKAlertDialog(context, 'User Created - Success',
            'User "${username.text}" has been created successfully.', 'OK');
      }
    } else {
      log(response.reasonPhrase.toString());
    }
  } on Exception catch (e) {
    log(e.toString());
  }
}

delUser(String username) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('DELETE', Uri.parse('http://$apiURL/delete_user'));
    request.body = json.encode({
      "mac_id": displayDeviceId,
      "applier_username": cUser.username,
      "applier_password": cUser.password,
      "username": username,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
    } else {}
  } catch (e) {
    log(e.toString());
  }
}

class AddUser extends StatefulWidget {
  // ignore: use_super_parameters
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      // ignore: prefer_const_constructors
      home: DesktopLoginPage(),
    );
  }
}
