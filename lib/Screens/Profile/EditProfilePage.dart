import 'package:flutter/material.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/AuthController.dart';
import 'package:sports_equipment_lost_and_found_it_project/CustomWidgets/CustomTextField.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/User.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user;

  AuthController ac = new AuthController();
  TextEditingController fullnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    AuthController ac = new AuthController();
    user = await ac.getUser();
    print(user?.name ?? "no user returned");
    phoneController.text = user != null ? user!.phone! : "";
    fullnameController.text = user != null ? user!.name! : "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 15,
            ),
            Center(),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    padding: 0,
                    prefixIcon: Icon(
                      Icons.person_sharp,
                      color: Colors.grey.shade700,
                    ),
                    hintText: "Full Name",
                    controller: fullnameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    padding: 0,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.grey.shade700,
                    ),
                    hintText: "Phone Number",
                    controller: phoneController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (fullnameController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          fullnameController.text.trim() == '' ||
                          phoneController.text.trim() == '') {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Alert'),
                            content:
                                const Text('Don\'t leave any inputs empty'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else if (!isNumeric(phoneController.text)) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Alert'),
                            content: const Text('Phone must be a number'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        var completed = await ac.updateUserContacts(
                            fullnameController.text, phoneController.text);
                        if (completed) {
                          Navigator.pop(context);
                        } else {
                          print("Somehting went wrong");
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      // width: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
