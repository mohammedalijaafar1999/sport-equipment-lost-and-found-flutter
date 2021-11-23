import 'dart:convert';
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
}
