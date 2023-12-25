import 'package:flutter/material.dart';

class DesktopScanner extends StatefulWidget {
  // void resultCallback (String result) {
  //   debugtext
  // }

  @override
  _DesktopScannerState createState() => _DesktopScannerState();
}

class _DesktopScannerState extends State<DesktopScanner> {
  String _debugText = 'debug';

  get _scannerController => null;

  @override
  void initState() {
    super.initState();

    // _scannerController = ScannerController(scannerResult: (result) {
    //   resultCallback(result);
    // }, scannerViewCreated: () {
    //   final TargetPlatform platform = Theme.of(context).platform;
    //   if (TargetPlatform.iOS == platform) {
    //     Future.delayed(const Duration(seconds: 2), () {
    //       _scannerController
    //         ..startCamera()
    //         ..startCameraPreview();
    //     });
    //   } else {
    //     _scannerController
    //       ..startCamera()
    //       ..startCameraPreview();
    //   }
    // });
  }

  resultCallback(String r) {
    print(r);
    setState(() {
      _debugText = r;
    });
  }

  _body() {
    return Column(
      children: [
        Text(_debugText),
        TextButton(
          child: Text('Start camera'),
          onPressed: () {
            _scannerController.startCamera();
          },
        ),
        TextButton(
          child: Text('Start preview'),
          onPressed: () {
            _scannerController.startCameraPreview();
          },
        ),
        TextButton(
          child: Text('Stop camera'),
          onPressed: () {
            _scannerController.stopCamera();
          },
        ),
        TextButton(
          child: Text('Stop preview'),
          onPressed: () {
            _scannerController.stopCameraPreview();
          },
        ),
        PlatformAiBarcodeScannerWidget(
            platformScannerController: _scannerController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  PlatformAiBarcodeScannerWidget({required platformScannerController}) {}

  ScannerController({required Function(dynamic r) scannerResult}) {}
}

class ScannerController {}
