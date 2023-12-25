import 'package:flutter/material.dart';

class TabletScan extends StatelessWidget {
  const TabletScan({super.key});

  @override
  Widget build(BuildContext context) {
    var data;

    var BarcodeWidgetPackage;
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the BarcodeWidget to display the barcode
            BarcodeWidgetPackage.BarcodeWidget(
              barcode: BarcodeWidgetPackage.Barcode.code128() ??
                  BarcodeWidgetPackage.Barcode
                      .qrCode(), // Use a default barcode type if code128() is null
              data: data,
              width: 200,
              height: 100,
              drawText:
                  true, // Set to false if you don't want to display the data as text
            ),
            SizedBox(height: 20),
            Text(data), // Display the data below the barcode
          ],
        ),
      ),
    );
  }
}
