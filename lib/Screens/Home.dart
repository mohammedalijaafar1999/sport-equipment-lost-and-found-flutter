import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Home'),
              TextButton(
                  onPressed: () {
                    final storage = new FlutterSecureStorage();
                    storage.delete(key: 'token').then((value) => {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()))
                        });
                  },
                  child: Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}
