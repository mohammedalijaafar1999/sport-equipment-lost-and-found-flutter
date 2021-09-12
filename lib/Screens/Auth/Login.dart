import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Register.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Home.dart';
import 'dart:convert';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Assets/Constants.dart';
import '../../CustomWidgets/CustomTextField.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    var response = await http.post(
      Uri.parse("http://" + globals.hostname + '/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    var data = jsonDecode(response.body);

    print(response.statusCode);
    print(data);

    if (response.statusCode == 201) {
      print(data["token"]);
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'token', value: data["token"]);
      print(await storage.read(key: "token"));
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      print(data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Welcome',
                      style: Heading1,
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Login',
                      style: Heading1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: CustomTextField(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: CustomTextField(
                        hintText: 'Password',
                        obsecureText: true,
                        controller: passwordController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      child: TextButton(
                        onPressed: () {},
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red.shade400,
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFF2D3243),
                          ),
                          child: Center(
                            child: Text(
                              "don't have an account? Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: SafeArea(
    //     child: Center(
    //       child: SingleChildScrollView(
    //         child: Container(
    //           width: 350,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "Login",
    //                 style: TextStyle(
    //                   color: Colors.grey.shade600,
    //                   fontSize: 42,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: TextField(
    //                   controller: emailController,
    //                   decoration: InputDecoration(
    //                     hintText: "Email",
    //                     hintStyle: TextStyle(
    //                         fontSize: 20.0, color: Colors.grey.shade400),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: TextField(
    //                   obscureText: true,
    //                   controller: passwordController,
    //                   decoration: InputDecoration(
    //                     hintText: "Password",
    //                     hintStyle: TextStyle(
    //                         fontSize: 20.0, color: Colors.grey.shade400),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               GestureDetector(
    //                 onTap: login,
    //                 child: Container(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(12.0),
    //                     child: Text(
    //                       "Login",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 24,
    //                       ),
    //                     ),
    //                   ),
    //                   decoration: BoxDecoration(
    //                       color: Colors.blue,
    //                       borderRadius: BorderRadius.circular(15)),
    //                 ),
    //               ),
    //               TextButton(
    //                 onPressed: () {
    //                   Navigator.pushReplacement(
    //                     context,
    //                     MaterialPageRoute(builder: (context) => Register()),
    //                   );
    //                 },
    //                 child: Text('don\'t have an account? Register'),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
