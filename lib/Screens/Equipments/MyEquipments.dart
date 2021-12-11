import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/EquipmentController.dart';
import 'package:sports_equipment_lost_and_found_it_project/CustomWidgets/CustomTextField.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Equipments/ViewEquipment.dart';
import '../../../../Utils/Globals.dart' as globals;

class MyEquipments extends StatefulWidget {
  MyEquipments({Key? key}) : super(key: key);

  @override
  _MyEquipmentsState createState() => _MyEquipmentsState();
}

class _MyEquipmentsState extends State<MyEquipments> {
  //data variables
  List<Equipment>? equipments;
  String? token;
  List<EquipmentStatus>? statuses;
  List<EquipmentType>? types;

  List<Equipment>? filteredEquipments;
  //controllers
  EquipmentController equipmentController = new EquipmentController();

  // inputs variables
  TextEditingController searchController = new TextEditingController();

  var statusDropdownSelectedItem;
  var typeDropdownSelectedItem;

  void getUserEquipments() async {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: "token");
    equipments =
        await equipmentController.getUserEquipments().catchError((err) {
      print(err);
    });

    // assign equipments to the filteredEquipments if not null
    equipments != null
        ? filteredEquipments = equipments
        : filteredEquipments = null;

    statuses = await equipmentController.getStatuses().catchError((e) {
      print(e.toString());
    });

    types = await equipmentController.getTypes().catchError((e) {
      print(e.toString());
    });

    statusDropdownSelectedItem = "1";
    typeDropdownSelectedItem = "1";
    search();
    setState(() {});
  }

  void search() {
    //make sure the list is nor empty
    setState(() {
      //get the search text
      String searchText = searchController.text;
      //make sure the text is not empty
      if (searchText.isNotEmpty) {
        // search through the list for items with that name
        filteredEquipments = equipments!.where((equipment) {
          if (equipment.equipment_name!.contains(searchText)) {
            return true;
          } else {
            return false;
          }
        }).toList();
      } else {
        filteredEquipments = equipments;
      }

      // filter again for status and type selected
      filteredEquipments = filteredEquipments!.where((equipment) {
        if (equipment.equipment_status!.equipment_status_id! ==
                statusDropdownSelectedItem &&
            equipment.equipment_type!.equipment_type_id! ==
                typeDropdownSelectedItem) {
          return true;
        } else {
          return false;
        }
      }).toList();
    });
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
                .copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
            prefixIcon: Icon(Icons.search),
            suffixIcon: GestureDetector(
              onTap: () {
                searchController.clear();
                search();
              },
              child: Icon(
                Icons.clear,
              ),
            ),
            hintText: "Search",
            controller: searchController,
            padding: 0,
            action: (val) {
              search();
            },
          ),
          SizedBox(
            height: 8,
          ),
          //display search options
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              statuses == null && types == null
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: DropdownButton(
                              isExpanded: true,
                              value: statusDropdownSelectedItem,
                              onChanged: (val) {
                                statusDropdownSelectedItem = val;
                                search();
                                setState(() {
                                  print(val);
                                });
                              },
                              items: statuses!.map((status) {
                                return DropdownMenuItem<String>(
                                  value: status.equipment_status_id!.toString(),
                                  child: Text(
                                    status.equipment_status_value!.toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                width: 8,
              ),
              types == null
                  ? Container()
                  : Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: DropdownButton(
                              isExpanded: true,
                              value: typeDropdownSelectedItem,
                              onChanged: (val) {
                                typeDropdownSelectedItem = val;
                                search();
                                setState(() {
                                  print(val);
                                });
                              },
                              items: types!.map((status) {
                                return DropdownMenuItem<String>(
                                  value: status.equipment_type_id!.toString(),
                                  child: Text(
                                    status.equipment_type_value!.toString(),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          //display equipments of user
          filteredEquipments == null
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
      itemCount: filteredEquipments!.length,
      itemBuilder: (BuildContext context, int index) {
        // return Text("hello");

        return equipmentListTileWidget(filteredEquipments![index]);
      },
    );
  }

  Padding equipmentListTileWidget(Equipment equipment) {
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
                                  .toString() +
                              "?lost=0",
                      headers: {
                        'Authorization': 'Bearer ' + token!,
                      },
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 90,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: const Text(
                            'Image Couldn\'t Load!',
                            style: TextStyle(fontSize: 8, color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              // equipment.equipment_name.toString().length > 10
                              //     ? equipment.equipment_name
                              //             .toString()
                              //             .substring(0, 10) +
                              //         "....."
                              //     : equipment.equipment_name.toString(),
                              equipment.equipment_name.toString(),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            // display description until the 15th character
                            equipment.equipment_description.toString().length >
                                    25
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Type: " +
                                equipment.equipment_type!.equipment_type_value!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
