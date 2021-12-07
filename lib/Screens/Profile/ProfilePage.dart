import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/AuthController.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/User.dart';
import '../../../../Utils/Globals.dart' as globals;
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  Uint8List? file64;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getProfileImage();
  }

  void getUserDetails() async {
    AuthController ac = new AuthController();
    user = await ac.getUser();
    print(user?.name ?? "no user returned");
    setState(() {});
  }

  void getProfileImage() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    var res = await http.get(
      Uri.parse(globals.hostname + "/api/user/profileImage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(res.body);
    var parts = res.body.split(",");
    file64 = Base64Decoder().convert(parts[1]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 160.0,
              height: 160.0,
              decoration: file64 == null
                  ? BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 12,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: NetworkImage(
                            "${globals.hostname}/img/placeholder.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    )
                  : BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 12,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: MemoryImage(file64!),
                        fit: BoxFit.none,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              user != null ? user!.name! : "User Name Here",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("${Equipment.equipmentsCount}"),
                          Text(
                            "Total Items",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 25,
                      color: Colors.grey.shade200,
                      width: 2,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("${Equipment.equipmentsLostCount}"),
                          Text(
                            "Lost Items",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 25,
                      color: Colors.grey.shade200,
                      width: 2,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("${Equipment.equipmentsDeletedCount}"),
                          Text(
                            "Deleted Items",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.grey.shade700,
                    ),
                    Text(
                      "  ${user != null ? user!.email! : "Email Here"}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.grey.shade700,
                    ),
                    Text(
                      "  ${user != null ? user!.phone! : "Phone Here"}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Member Since : 2021",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
