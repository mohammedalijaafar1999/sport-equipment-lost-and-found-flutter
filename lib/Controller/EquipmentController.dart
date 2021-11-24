import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import 'package:sports_equipment_lost_and_found_it_project/Utils/Globals.dart'
    as globals;

class EquipmentController {
  String? errorMessage;

  Future<List<Equipment>> getUserEquipments() async {
    try {
      // get user token
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");

      // get user equipment using the token
      var response = await http.get(
        Uri.parse(globals.hostname + '/api/user/equipments'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token!,
        },
      );

      Map<String, dynamic> equipmentsMap = jsonDecode(response.body);
      // initialize the list to add to it
      List<Equipment> equipments = [];
      for (var equipment in equipmentsMap["equipments"]) {
        var equipmentInstance = Equipment.fromJson(equipment);
        equipments.add(equipmentInstance);
      }
      return Future.value(equipments);
    } catch (e) {
      throw ("Error: " + e.toString());
    }
  }

  Future<Equipment> getEquipment(String equipmentId) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      var response = await http.get(
          Uri.parse(
              globals.hostname + "/api/user/equipmentByID/" + equipmentId),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });

      Map<String, dynamic> equipmentMap = jsonDecode(response.body);

      return Future.value(Equipment.fromJson(equipmentMap["equipments"][0]));
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> addEquipment(String title, String description, String statusId,
      typeId, File imageFile) async {
    try {
      var uri = Uri.parse(globals.hostname + "/api/user/createEquipment");
      var request = new http.MultipartRequest("POST", uri);
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      print(token);
      request.headers["Authorization"] = "Bearer " + token!;
      request.fields['equipment_name'] = title;
      request.fields['equipment_description'] = description;
      request.fields['equipment_status_id'] = statusId;
      request.fields['equipment_type_id'] = typeId;
      request.files
          .add(await http.MultipartFile.fromPath("images[]", imageFile.path));

      var res = await request.send();
      print(request);
      print("------------------------");
      print(res.statusCode);
      print("------------------------");
      res.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      return Future.value(true);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<EquipmentStatus>> getStatuses() async {
    try {
      List<EquipmentStatus> statuses = [];

      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      var response = await http.get(
        Uri.parse(globals.hostname + '/api/equipmentStatuses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token!,
        },
      );

      var jsonMap = jsonDecode(response.body);
      statuses = [];
      for (var statusMap in jsonMap["equipment_statuses"]) {
        statuses.add(EquipmentStatus.fromJson(statusMap));
      }

      return Future.value(statuses);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<EquipmentType>> getTypes() async {
    try {
      List<EquipmentType> types = [];

      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      var response = await http.get(
        Uri.parse(globals.hostname + '/api/equipmentTypes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token!,
        },
      );

      var jsonMap = jsonDecode(response.body);
      for (var statusMap in jsonMap["equipment_types"]) {
        types.add(EquipmentType.fromJson(statusMap));
      }

      return Future.value(types);
    } catch (e) {
      throw (e.toString());
    }
  }
}
