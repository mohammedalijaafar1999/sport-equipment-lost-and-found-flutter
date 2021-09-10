import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';
import '../Utils/Globals.dart' as globals;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void logout() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");

    await http.post(
      Uri.parse("http://" + globals.hostname + '/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    storage.delete(key: 'token').then((value) => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Home'),
              TextButton(onPressed: logout, child: Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}
