import 'package:flutter/material.dart';
import 'package:reporting_app/constants.dart';
import 'package:reporting_app/screens/take_pic/camera/camera.dart';
import 'package:reporting_app/util/side_menu.dart';

class TakePicPage extends StatelessWidget {
  const TakePicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Take Pic',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF655B87),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      // ignore: prefer_const_constructors
      drawer: SideMenu(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
                print('Icon tapped!');
              },
              child: Icon(
                Icons.camera_alt_outlined,
                size: 300,
                color: Color(0xFF655B87),
              ),
            ),
            SizedBox(width: 200),
            InkWell(
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => Scan()),
              //   );
              //   print('Icon tapped!');
              // },
              child: Icon(
                Icons.barcode_reader,
                size: 300,
                color: Color(0xFF655B87),
              ),
            ), // Adjust the spacing between icons
          ],
        ),
      ),
    );
  }
}
