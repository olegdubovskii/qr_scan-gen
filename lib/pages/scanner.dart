import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:regexed_validator/regexed_validator.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Visibility(
            visible: result != null ? true : false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      child: Container(
                          height: 150,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "Decoded data",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => result = null),
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: result != null
                                        ? Text(
                                            "${result!.code}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          )
                                        : const Text("Non data"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white),
                                  child: const Text(
                                    "Open in browser",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: result != null &&
                                          validator.url(result!.code.toString())
                                      ? () {
                                          _launchURL(result!.code.toString());
                                          setState(() => result = null);
                                        }
                                      : null),
                              const SizedBox(height: 10)
                            ],
                          )),
                      onLongPress: () async {
                        await Clipboard.setData(
                            ClipboardData(text: "${result!.code}"));
                        //_launchURL(result!.code.toString());
                        setState(() => result = null);
                      }),
                  const SizedBox(height: 56)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}