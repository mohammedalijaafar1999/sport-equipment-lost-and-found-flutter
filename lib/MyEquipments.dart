import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../Utils/Globals.dart' as globals;

class MyEquipments extends StatefulWidget {
  MyEquipments({Key? key}) : super(key: key);

  @override
  _MyEquipmentsState createState() => _MyEquipmentsState();
}

class _MyEquipmentsState extends State<MyEquipments> {
  void getUserEquipments() async {
    // get user token
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");

    // get user equipment using the token
    var response = await http.get(
      Uri.parse(globals.hostname + '/api/user/getEquipments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!,
      },
    );

    print(response.body);
  }

  @override
  void initState() {
    super.initState();
    getUserEquipments();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "My equipments",
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(
                onPressed: () {},
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
