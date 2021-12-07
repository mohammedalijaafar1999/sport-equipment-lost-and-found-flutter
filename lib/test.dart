import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
  String? token;
  Uint8List? file64;

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
    request.files
        .add(await http.MultipartFile.fromPath("images[]", file!.path));

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
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: "token");
    print(token!);
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
                    "http://192.168.8.102/api/user/image/3",
                    headers: {
                      'Authorization':
                          'Bearer 2|MHqiW4YdI2wW0FAgIohl0ezssGiQ2WR1XhvbHVW9',
                    },
                    width: 200,
                  ),
            TextButton(
              onPressed: () async {
                var res = await http.get(
                  Uri.parse(globals.hostname + "/api/user/profileImage"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':
                        'Bearer 14|zj18hZYs2cm7KhPunyDfgeTHEhDytX4XTEvVTPSw',
                  },
                );
                print(res.body);
                var parts = res.body.split(",");
                file64 = Base64Decoder().convert(parts[1]);
                setState(() {});
              },
              child: Text('asd'),
            ),
            file64 != null ? Image.memory(file64!) : Container()
          ],
        ),
      ),
    );
  }
}
