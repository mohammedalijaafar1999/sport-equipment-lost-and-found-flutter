import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:sports_equipment_lost_and_found_it_project/Controller/EquipmentController.dart';
import '../../../../Utils/Globals.dart' as globals;

class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  EquipmentController equipmentController = new EquipmentController();

  Future<http.Response> identifyLostEquipment(String url) async {
    if (!url.contains(globals.hostname)) {
      throw "Not a valid url";
    }
    return equipmentController.identifyLostEquipment(url);
  }

  Future<http.Response> transferEquipment(String url) async {
    if (!url.contains(globals.hostname)) {
      throw "Not a valid url";
    }
    return equipmentController.transferEquipment(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      await controller.pauseCamera();
      setState(() {});
      //result!.code
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // check wither the scan is for identify or transfering the equipment
              result!.code!.contains("identifyLostEquipment")
                  ? FutureBuilder(
                      future: identifyLostEquipment(result!.code!),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data.body);
                          var jsonBody = jsonDecode((snapshot.data.body));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Contact info",
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              Text("Name: " + jsonBody["user"]["name"]),
                              Text("Email: " + jsonBody["user"]["email"]),
                              Text("Phone Number: " +
                                  jsonBody["user"]["mobile_number"]),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  : FutureBuilder(
                      future: transferEquipment(result!.code!),
                      builder: (BuildContext context,
                          AsyncSnapshot<http.Response> snapshot) {
                        print(result!.code!);
                        if (snapshot.hasData) {
                          print(snapshot.data!.body);
                          if (snapshot.data!.statusCode == 200) {
                            return Text("Transfer Completed");
                          } else {
                            return Text("Transfer Failed");
                          }
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
            ],
          ) /*Text(result?.code ?? 'ads')*/,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      await controller.resumeCamera();
      setState(() {});
    });
  }
}
