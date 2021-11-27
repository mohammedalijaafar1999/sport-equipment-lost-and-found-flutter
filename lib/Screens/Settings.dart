import 'package:flutter/material.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/AuthController.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AuthController authController = new AuthController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: TextButton(
              onPressed: () async {
                bool completed = await authController.logout();
                if (completed) {
                  print("Logged out");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                } else {
                  print("something wrong happened");
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    "Logout",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
