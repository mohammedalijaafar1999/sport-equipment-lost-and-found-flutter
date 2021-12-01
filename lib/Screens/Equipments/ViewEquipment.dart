import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/EquipmentController.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Equipments/EditEquipment.dart';
import '../../../../Utils/Globals.dart' as globals;
import 'package:qr_flutter/qr_flutter.dart';

class ViewEquipment extends StatefulWidget {
  final String equipmentId;
  ViewEquipment({Key? key, required this.equipmentId}) : super(key: key);

  @override
  _ViewEquipmentState createState() => _ViewEquipmentState();
}

class _ViewEquipmentState extends State<ViewEquipment> {
  Equipment? equipment;
  String? token;
  EquipmentController equipmentController = new EquipmentController();

  @override
  void initState() {
    super.initState();
    getEquipment();
  }

  // get user equipment using the token
  void getEquipment() async {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: "token");
    equipment = await equipmentController
        .getEquipment(widget.equipmentId)
        .catchError((e) {
      print(e.toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FDFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mafqoud"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          ButtonBar(
            children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            EditEquipment(equipmentId: widget.equipmentId)),
                  );
                  //refresh viewPage
                  equipment = null;
                  setState(() {});
                  getEquipment();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        equipment != null
                            ? equipment!.equipment_name!
                            : "Title",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print("Qr Code");
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: QrImage(
                              data:
                                  "${globals.hostname}/api/identifyLostEquipment/${widget.equipmentId}?json=1",
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Show QR",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: equipment != null
                            ? Image.network(
                                (equipment?.equipment_images?.isEmpty == true)
                                    ? globals.hostname + "/img/placeholder.png"
                                    : globals.hostname +
                                        "/api/user/image/" +
                                        equipment!.equipment_images![0]
                                            .equipment_image_id
                                            .toString() +
                                        "?lost=0",
                                headers: {
                                  'Authorization': 'Bearer ' + token!,
                                },
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 160,
                                    color: Theme.of(context).primaryColor,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image Couldn\'t Load!',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  );
                                },
                              )
                            : Image.network(
                                globals.hostname + "/img/placeholder.png",
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 160,
                                    color: Theme.of(context).primaryColor,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image Couldn\'t Load!',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        equipment != null
                            ? equipment!.equipment_description!
                            : "Title",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 20,
                            ),
                      ),
                      SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Status: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text: equipment != null
                                    ? ' ' +
                                        equipment!.equipment_status!
                                            .equipment_status_value!
                                    : "Loading"),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Type: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text: equipment != null
                                    ? ' ' +
                                        equipment!.equipment_type!
                                            .equipment_type_value!
                                    : "Loading"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
