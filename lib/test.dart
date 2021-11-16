import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Utils/Globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  File? file;
  var imageProvider = Image.asset("image.jpg"); //as ImageProvider<Object>;

  void send() async {
    var uri = Uri.parse(globals.hostname + "/api/user/createEquipment");
    var request = new http.MultipartRequest("POST", uri);
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    print(token);
    request.headers["Authorization"] = "Bearer " + token!;
    request.fields['equipment_name'] = 'bla';
    request.fields['equipment_description'] = 'bla';
    request.fields['equipment_status_id'] = '1';
    request.fields['equipment_type_id'] = '1';

    var res = await request.send();
    print(request);
    print("------------------------");
    print(res.statusCode);
    print("------------------------");
    res.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  void showImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: send,
              child: Text("Click Me"),
            ),
            TextButton(
              onPressed: showImage,
              child: Text("Show Image"),
            ),
            file != null
                ? Image.file(
                    file!,
                    width: 200,
                  )
                : Image.network(
                    "https://www.swapp-tech.com/wp-content/uploads/2020/04/placeholder.png",
                    width: 200,
                  )
          ],
        ),
      ),
    );
  }
}
