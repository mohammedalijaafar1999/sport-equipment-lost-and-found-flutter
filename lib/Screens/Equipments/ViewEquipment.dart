import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import '../../../../Utils/Globals.dart' as globals;

class ViewEquipment extends StatefulWidget {
  final String equipmentId;
  ViewEquipment({Key? key, required this.equipmentId}) : super(key: key);

  @override
  _ViewEquipmentState createState() => _ViewEquipmentState();
}

class _ViewEquipmentState extends State<ViewEquipment> {
  Equipment? equipment;

  @override
  void initState() {
    super.initState();
    getEquipment();
  }

  // get user equipment using the token
  void getEquipment() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");

    final queryParameters = {'id': widget.equipmentId};
    var uri = Uri.http(
        "192.168.8.102", '/api/user/getEquipmentByID', queryParameters);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ' + token!
    };
    var response = await http.get(uri, headers: headers);

    Map<String, dynamic> equipmentMap = jsonDecode(response.body);

    setState(() {
      equipment = Equipment.fromJson(equipmentMap["equipments"][0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9FDFF),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Mafqoud"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      equipment != null ? equipment!.equipment_name! : "Title",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    TextButton(
                      onPressed: () {
                        print("Qr Code");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).primaryColor),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Show QR",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 0), // Shadow position
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.network(
                            "https://www.swapp-tech.com/wp-content/uploads/2020/04/placeholder.png",
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          equipment != null
                              ? equipment!.equipment_description!
                              : "Title",
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 20,
                                  ),
                        ),
                        SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Status: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: equipment != null
                                      ? ' ' +
                                          equipment!.equipment_status!
                                              .equipment_status_value!
                                      : "Loading"),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Type: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: equipment != null
                                      ? ' ' +
                                          equipment!.equipment_type!
                                              .equipment_type_value!
                                      : "Loading"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
