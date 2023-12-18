// ignore: unused_import
import 'dart:developer';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/screens/Login/loginpage.dart';
import 'package:reporting_app/util/my_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabletLoginPage extends StatefulWidget {
  // ignore: use_super_parameters
  const TabletLoginPage({Key? key}) : super(key: key);

  @override
  State<TabletLoginPage> createState() => _TabletLoginPageState();
}

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

class _TabletLoginPageState extends State<TabletLoginPage> {
  // Dynamically show the password to the user
  // ignore: unused_field, prefer_final_fields
  bool _isObscure = true;

  @override
  void initState() {
    setState(() {});
    declareSharedPref();
    super.initState();
  }

  declareSharedPref() async {
    final loginPref = await SharedPreferences.getInstance();
    final String? lpUname = loginPref.getString('username');
    final String? lpPass = loginPref.getString('password');

    if (lpUname != null) {
      username.text = lpUname;
    }

    if (lpPass != null) {
      password.text = lpPass;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: defaultBackgroundColor,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/login_image.jpg'),
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: GoogleFonts.poppins(
                              color: defaultTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 42,
                            ),
                          ),
                          Text(
                            'Sign In to use the Point of Sale System.',
                            style: GoogleFonts.poppins(
                              color: defaultTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              displayDeviceId,
                              style: GoogleFonts.robotoMono(
                                color: defaultTextColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          ),
                          children: [
                            StoreBox(
                              text: 'Shree Venilals',
                              image: const AssetImage(
                                  'assets/images/venilals.png'),
                              press: () async {
                                getUsers('VENI').then((_) {
                                  setState(() {});
                                });
                                // await Future.delayed(
                                //     const Duration(seconds: 1));
                                setState(() {});
                              },
                              // ignore: prefer_const_constructors
                              primaryColor: Color.fromARGB(255, 94, 202, 238),
                              secondaryColor:
                                  const Color.fromARGB(255, 94, 202, 238),
                            ),
                            StoreBox(
                              text: 'Celebrations',
                              image: const AssetImage(
                                  'assets/images/venilals.png'),
                              press: () async {
                                getUsers('CELE').then((_) {
                                  setState(() {});
                                });

                                // await Future.delayed(
                                //     const Duration(seconds: 1));
                                setState(() {});
                              },
                              // ignore: prefer_const_constructors
                              primaryColor: Color.fromARGB(255, 94, 223, 238),
                              secondaryColor:
                                  const Color.fromARGB(255, 94, 223, 238),
                            ),
                            StoreBox(
                              text: 'Festival',
                              image: const AssetImage(
                                  'assets/images/venilals.png'),
                              press: () async {
                                getUsers('FEST').then((_) {
                                  setState(() {});
                                });

                                // await Future.delayed(
                                //     const Duration(seconds: 1));
                                setState(() {});
                              },
                              primaryColor:
                                  const Color.fromARGB(255, 65, 226, 210),
                              secondaryColor:
                                  const Color.fromARGB(255, 122, 251, 238),
                            ),
                            StoreBox(
                              text: 'Heritage',
                              image: const AssetImage(
                                  'assets/images/venilals.png'),
                              press: () async {
                                getUsers('HERI').then((_) {
                                  setState(() {});
                                });

                                // await Future.delayed(
                                //     const Duration(seconds: 1));
                                setState(() {});
                              },
                              primaryColor:
                                  const Color.fromARGB(255, 150, 187, 255),
                              secondaryColor:
                                  const Color.fromARGB(255, 150, 187, 255),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //   Expanded(
          //     child: Container(
          //       color: defaultBackgroundColor,
          //       child: Column(
          //         children: [
          //           Expanded(
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     'Sign In',
          //                     style: GoogleFonts.poppins(
          //                       fontSize: 20,
          //                       fontWeight: FontWeight.w700,
          //                       color: defaultTextColor,
          //                     ),
          //                   ),
          //                   const SizedBox(height: 16),
          //                   TextField(
          //                     controller: username,
          //                     style: GoogleFonts.poppins(
          //                       color: Colors.black,
          //                     ),
          //                     decoration: InputDecoration(
          //                       prefixIcon: const Icon(
          //                         FontAwesomeIcons.user,
          //                         size: 15,
          //                         color: Colors.grey,
          //                       ),
          //                       hintText: 'Username',
          //                       hintStyle: GoogleFonts.poppins(
          //                         color: Colors.grey,
          //                       ),
          //                       filled: true,
          //                       contentPadding:
          //                           const EdgeInsets.symmetric(horizontal: 16),
          //                       fillColor: Colors.white24,
          //                       border: OutlineInputBorder(
          //                         borderSide:
          //                             const BorderSide(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                       enabledBorder: OutlineInputBorder(
          //                         borderSide:
          //                             const BorderSide(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                       focusedBorder: OutlineInputBorder(
          //                         borderSide:
          //                             const BorderSide(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                     ),
          //                   ),
          //                   const SizedBox(height: 8),
          //                   TextField(
          //                     obscureText: _isObscure,
          //                     controller: password,
          //                     style: GoogleFonts.poppins(
          //                       color: Colors.black,
          //                     ),
          //                     decoration: InputDecoration(
          //                       prefixIcon: const Icon(
          //                         FontAwesomeIcons.lock,
          //                         size: 15,
          //                         color: Colors.grey,
          //                       ),
          //                       suffixIcon: IconButton(
          //                         onPressed: () {
          //                           setState(
          //                             () {
          //                               _isObscure = !_isObscure;
          //                             },
          //                           );
          //                         },
          //                         icon: Icon(_isObscure
          //                             ? Icons.visibility
          //                             : Icons.visibility_off),
          //                       ),
          //                       suffixIconColor: Colors.grey,
          //                       hintText: 'Password',
          //                       hintStyle: GoogleFonts.poppins(
          //                         color: Colors.grey,
          //                       ),
          //                       filled: true,
          //                       contentPadding:
          //                           const EdgeInsets.symmetric(horizontal: 16),
          //                       fillColor: Colors.white24,
          //                       border: OutlineInputBorder(
          //                         borderSide:
          //                             const BorderSide(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                       enabledBorder: OutlineInputBorder(
          //                         borderSide:
          //                             const BorderSide(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                       focusedBorder: OutlineInputBorder(
          //                         borderSide:
          //                             const BorderSide(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                     ),
          //                     onSubmitted: (value) => {loginfunction(context)},
          //                   ),
          //                   const SizedBox(height: 16),
          //                   Row(children: [
          //                     const Text("REMEMBER ME"),
          //                     Checkbox(
          //                       value: remember,
          //                       fillColor:
          //                           MaterialStateProperty.resolveWith(getColor),
          //                       onChanged: (value) {
          //                         setState(() {
          //                           remember = value!;
          //                         });
          //                       },
          //                     ),
          //                   ]),
          //                   const SizedBox(height: 16),
          //                   Row(
          //                     children: [
          //                       Expanded(
          //                         child: ElevatedButton(
          //                           style: ElevatedButton.styleFrom(
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(10),
          //                               ),
          //                               padding: const EdgeInsets.all(16),
          //                               primary: defaultAccentColor),
          //                           onPressed: () => {loginfunction(context)},
          //                           child: Text(
          //                             'Login',
          //                             style: GoogleFonts.poppins(
          //                               fontSize: 16,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   const SizedBox(height: 30),
          //                   Text(displayDeviceId),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          Expanded(
            child: Container(
              color: defaultBackgroundColor,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 50,
                    ),
                    child: Text(
                      "Users for this Store",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: userlist.length,
                        itemBuilder: (context, index) {
                          return Material(
                            color: defaultBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 10,
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                leading: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                title: Text(
                                  userlist[index].username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () async {
                                  final ok = await showTextInputDialog(
                                    context: context,
                                    title: "Hi, ${userlist[index].username}",
                                    autoSubmit: true,
                                    textFields: [
                                      const DialogTextField(
                                        hintText: 'Password',
                                        obscureText: true,
                                      ),
                                    ],
                                  );
                                  if (ok != null) {
                                    username.text = userlist[index].username;
                                    password.text = ok[0];
                                    // ignore: use_build_context_synchronously
                                    loginfunction(context);
                                  }
                                },
                                trailing: const Icon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                tileColor: defaultBgAccentColor,
                              ),
                            ),
                          );
                        },
                      ),
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
