import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';
import 'dart:convert';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Home.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void register() async {
    var resposone = await http.post(
      Uri.parse("http://" + globals.hostname + '/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': nameController.text,
        'email': emailController.text,
        'mobile_number': phoneController.text,
        'password': passwordController.text,
      }),
    );
    var data = jsonDecode(resposone.body);

    print(data["token"]);
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'token', value: data["token"]);
    print(await storage.read(key: "token"));
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  void getToken() async {
    final storage = new FlutterSecureStorage();
    print(await storage.read(key: "token"));
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 42,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        hintStyle: TextStyle(
                            fontSize: 20.0, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontSize: 20.0, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: "Phone",
                        hintStyle: TextStyle(
                            fontSize: 20.0, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontSize: 20.0, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: register,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text('have an account already? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
