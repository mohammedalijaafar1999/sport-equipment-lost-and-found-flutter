import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Home.dart';
import 'package:http/http.dart' as http;
import '../../Utils/Globals.dart' as globals;

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  /*
    the loading screen will check for the user token and make sure that he is logged in
  */

  // check token validity
  Future<bool> checkTokenValidity(var token) async {
    //get saved token
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    print(token);

    //use token to check validity of it
    var response = await http.get(
      Uri.parse(globals.hostname + '/api/user/equipments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    //check validity of token
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  //get the saved token on the device
  void getToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    //check if there is saved token before
    var tokenExists = token != null && token != "";

    if (tokenExists) {
      //check if the token is still valid in the api
      bool validToken = await checkTokenValidity(token);
      if (validToken) {
        // take user to the home page
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        // take user to the Login page
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } else {
      // take user to the Login page
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
