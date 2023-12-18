import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/main.dart';
import 'package:reporting_app/screens/Login/loginpage.dart';
import 'package:reporting_app/util/my_box.dart';

class MobileLoginPage extends StatefulWidget {
  // ignore: use_super_parameters
  const MobileLoginPage({Key? key}) : super(key: key);

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
  // Dynamically show the password to the user
  // ignore: unused_field, prefer_final_fields
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Welcome',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      'Forms9 - Point of Sale System',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Sign In',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      displayDeviceId,
                      style:
                          // ignore: prefer_const_constructors
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),

                    SizedBox(
                      height: 350,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
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

                    // const SizedBox(height: 16),
                    // TextField(
                    //   style: GoogleFonts.poppins(
                    //     color: Colors.black,
                    //   ),
                    //   controller: username,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(
                    //       FontAwesomeIcons.user,
                    //       size: 15,
                    //       color: Colors.grey,
                    //     ),
                    //     hintText: 'Username',
                    //     hintStyle: GoogleFonts.poppins(
                    //       color: Colors.grey,
                    //     ),
                    //     filled: true,
                    //     contentPadding:
                    //         const EdgeInsets.symmetric(horizontal: 16),
                    //     fillColor: Colors.white24,
                    //     border: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // TextField(
                    //   obscureText: _isObscure,
                    //   style: GoogleFonts.poppins(
                    //     color: Colors.black,
                    //   ),
                    //   controller: password,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(
                    //       FontAwesomeIcons.lock,
                    //       size: 15,
                    //       color: Colors.grey,
                    //     ),
                    //     suffixIcon: IconButton(
                    //       onPressed: () {
                    //         setState(
                    //           () {
                    //             _isObscure = !_isObscure;
                    //           },
                    //         );
                    //       },
                    //       icon: Icon(_isObscure
                    //           ? Icons.visibility
                    //           : Icons.visibility_off),
                    //     ),
                    //     suffixIconColor: Colors.grey,
                    //     hintText: 'Password',
                    //     hintStyle: GoogleFonts.poppins(
                    //       color: Colors.grey,
                    //     ),
                    //     filled: true,
                    //     contentPadding:
                    //         const EdgeInsets.symmetric(horizontal: 16),
                    //     fillColor: Colors.white24,
                    //     border: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             padding: const EdgeInsets.all(16)),
                    //         onPressed: () => {loginfunction(context)},
                    //         child: Text(
                    //           'Login',
                    //           style: GoogleFonts.poppins(
                    //             fontSize: 16,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 30),
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          // const Padding(
                          //   padding: EdgeInsets.only(
                          //     top: 10,
                          //   ),
                          //   child: Text(
                          //     "Users for this Store",
                          //     style: TextStyle(
                          //       fontSize: 24,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                          SingleChildScrollView(
                            child: ListView.builder(
                              controller: ScrollController(),
                              shrinkWrap: true,
                              itemCount: userlist.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  color: Colors.transparent,
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
                                          title:
                                              "Hi, ${userlist[index].username}",
                                          autoSubmit: true,
                                          textFields: [
                                            const DialogTextField(
                                              hintText: 'Password',
                                              obscureText: true,
                                            ),
                                          ],
                                        );
                                        if (ok != null) {
                                          username.text =
                                              userlist[index].username;
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
