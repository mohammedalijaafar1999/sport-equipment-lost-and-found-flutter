import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Home.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    var loggedIn = token != null && token != "";
    if (loggedIn) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
    print(token);
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(
                'loading',
              )
            ],
          ),
        ),
      ),
    );
  }
}
