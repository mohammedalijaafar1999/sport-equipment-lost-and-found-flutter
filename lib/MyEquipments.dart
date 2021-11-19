import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import '../../Utils/Globals.dart' as globals;

class MyEquipments extends StatefulWidget {
  MyEquipments({Key? key}) : super(key: key);

  @override
  _MyEquipmentsState createState() => _MyEquipmentsState();
}

class _MyEquipmentsState extends State<MyEquipments> {
  List<Equipment>? equipments;

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

    //print(response.body);
    Map<String, dynamic> equipmentsMap = jsonDecode(response.body);
    // initialize the list to add to it
    equipments = [];
    for (var equipment in equipmentsMap["equipments"]) {
      //print(equipment);
      var equipmentInstance = Equipment.fromJson(equipment);
      equipments!.add(equipmentInstance);
      print(equipmentInstance.toString());
      print("-----------------");
      print(
          equipmentInstance.equipment_images![0].equipment_image_id.toString() +
              " - " +
              equipmentInstance.equipment_images![0].equipment_image_path!);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserEquipments();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "My equipments",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          equipments == null
              ? SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: EquipmentsListWidget(
                    equipments: equipments!,
                  ),
                ),
        ],
      ),
    );
  }
}

class EquipmentListTile extends StatelessWidget {
  final Equipment equipment;
  const EquipmentListTile({Key? key, required this.equipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 0), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.network(
                      "https://www.swapp-tech.com/wp-content/uploads/2020/04/placeholder.png",
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          equipment.equipment_name.toString(),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          // display description until the 15th character
                          equipment.equipment_description.toString().length > 25
                              ? equipment.equipment_description
                                      .toString()
                                      .substring(0, 25) +
                                  "....."
                              : equipment.equipment_description.toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          "Status: " +
                              equipment
                                  .equipment_status!.equipment_status_value!,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          "Type: " +
                              equipment.equipment_type!.equipment_type_value!,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
        onTap: () {
          print(equipment.equipment_id);
        },
      ),
    );
  }
}

class EquipmentsListWidget extends StatelessWidget {
  final List<Equipment> equipments;
  const EquipmentsListWidget({Key? key, required this.equipments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: equipments.length,
      itemBuilder: (BuildContext context, int index) {
        // return Text("hello");
        return EquipmentListTile(
          equipment: equipments[index],
        );
      },
    );
  }
}