import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/EquipmentController.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Equipments/ViewEquipment.dart';
import '../../../../Utils/Globals.dart' as globals;

class MyEquipments extends StatefulWidget {
  MyEquipments({Key? key}) : super(key: key);

  @override
  _MyEquipmentsState createState() => _MyEquipmentsState();
}

class _MyEquipmentsState extends State<MyEquipments> {
  List<Equipment>? equipments;
  String? token;
  EquipmentController equipmentController = new EquipmentController();

  void getUserEquipments() async {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: "token");
    equipments =
        await equipmentController.getUserEquipments().catchError((err) {
      print(err);
    });
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
              : Expanded(child: equipmentsListMethod()),
        ],
      ),
    );
  }

  ListView equipmentsListMethod() {
    return ListView.builder(
      cacheExtent: 9999,
      itemCount: equipments!.length,
      itemBuilder: (BuildContext context, int index) {
        // return Text("hello");
        return EquipmentListTileWidget(equipments![index]);
      },
    );
  }

  Padding EquipmentListTileWidget(Equipment equipment) {
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
                      (equipment.equipment_images?.isEmpty == true)
                          ? globals.hostname + "/img/placeholder.png"
                          : globals.hostname +
                              "/api/user/image/" +
                              equipment.equipment_images![0].equipment_image_id!
                                  .toString(),
                      headers: {
                        'Authorization': 'Bearer ' + token!,
                      },
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
                          equipment.equipment_name.toString().length > 15
                              ? equipment.equipment_name
                                      .toString()
                                      .substring(0, 15) +
                                  "....."
                              : equipment.equipment_name.toString(),
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
        onTap: () async {
          // take the user to the equipment page and pass the id
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  ViewEquipment(equipmentId: equipment.equipment_id.toString()),
            ),
          );
          // refresh page
          equipments = null;
          setState(() {});
          getUserEquipments();
        },
      ),
    );
  }
}
