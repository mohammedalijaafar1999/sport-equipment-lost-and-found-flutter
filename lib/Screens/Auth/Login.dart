import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Register.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Home.dart';
import '../../Assets/Constants.dart';
import '../../CustomWidgets/CustomTextField.dart';
import '../../Controller/AuthController.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      AuthController ac = new AuthController();
      bool completed =
          await ac.login(emailController.text, passwordController.text);
      if (completed) {
        print("Logged in successfully");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      } else {
        print("Something went wrong");
      }
    } else {
      print("inputs are empty");
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Don\'t leave any inputs empty'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
                      'Mafqoud',
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
                        onPressed: login,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: Heading2.copyWith(color: Colors.white),
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
                              color: Colors.black),
                          child: Center(
                            child: Text(
                              "don't have an account? Register",
                              style: paragraph.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
  }
}
