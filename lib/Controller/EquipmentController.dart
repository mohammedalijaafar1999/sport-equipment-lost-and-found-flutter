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
      int counter = 0;
      int lostCounter = 0;
      int deletedCounter = 0;
      List<Equipment> equipments = [];
      for (var equipment in equipmentsMap["equipments"]) {
        var equipmentInstance = Equipment.fromJson(equipment);
        equipments.add(equipmentInstance);
        counter++;
        if (equipmentInstance.equipment_status!.equipment_status_id! == "2") {
          lostCounter++;
        }
        if (equipmentInstance.equipment_status!.equipment_status_id! == "5") {
          deletedCounter++;
        }
      }
      Equipment.equipmentsCount = counter;
      Equipment.equipmentsLostCount = lostCounter;
      Equipment.equipmentsDeletedCount = deletedCounter;
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
      return true;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> editEquipment(String id, String title, String description,
      String statusId, typeId, File? imageFile) async {
    try {
      var uri = Uri.parse(globals.hostname + "/api/user/updateEquipment/$id");
      var request = new http.MultipartRequest("POST", uri);
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      print(token);
      request.headers["Authorization"] = "Bearer " + token!;
      request.fields['equipment_name'] = title;
      request.fields['equipment_description'] = description;
      request.fields['equipment_status_id'] = statusId;
      request.fields['equipment_type_id'] = typeId;
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath("images[]", imageFile.path));
      }

      var res = await request.send();
      print(request);
      print("------------------------");
      print(res.statusCode);
      print("------------------------");
      res.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      return true;
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

  Future<bool> deleteEquipment(String id) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      var uri = Uri.parse(globals.hostname + "/api/user/deleteEquipment/$id");

      var res = await http.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(res.body);

      return true;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<http.Response> identifyLostEquipment(String url) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      var res = await http.get(
        Uri.parse("$url?json=1"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw "Status Code: ${res.statusCode}";
      } else {
        return res;
      }
    } catch (e) {
      throw "${e.toString()}";
    }
  }

  Future<http.Response> getTransferToken(String equipmentId) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      print(globals.hostname + "/api/user/getTransferToken/$equipmentId");
      var res = await http.get(
        Uri.parse(globals.hostname + "/api/user/getTransferToken/$equipmentId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> transferEquipment(String url) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");
      print(url);
      var res = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      return res;
    } catch (e) {
      throw e.toString();
    }
  }
}
