import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/AuthController.dart';
import 'package:sports_equipment_lost_and_found_it_project/CustomWidgets/CustomTextField.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/User.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currPassController = new TextEditingController();
  TextEditingController newPassController = new TextEditingController();

  User? user;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    AuthController ac = new AuthController();
    user = await ac.getUser();
    print(user?.name ?? "no user returned");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mafqoud"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextField(
              hintText: "Current Password",
              controller: currPassController,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: "New Password",
              controller: newPassController,
            ),
            // cgange button
            TextButton(
              onPressed: () async {
                if (currPassController.text.isEmpty ||
                    currPassController.text.trim() == "" ||
                    newPassController.text.isEmpty ||
                    newPassController.text.trim() == "") {
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
                } else {
                  if (user != null) {
                    //update user password
                    Widget content = Text("");
                    AuthController ac = new AuthController();
                    var res = await ac.changePassword(user!.name!, user!.phone!,
                        currPassController.text, newPassController.text);
                    if (res != null) {
                      print(res.statusCode);
                      if (res.statusCode == 200) {
                        print(res.body);
                      } else {
                        print(res.body);
                      }
                    }
                  } else {
                    print("user data not fetched");
                  }
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Change Password",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
