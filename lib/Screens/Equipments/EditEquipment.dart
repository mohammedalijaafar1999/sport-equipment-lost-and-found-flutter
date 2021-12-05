import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/EquipmentController.dart';
import 'package:sports_equipment_lost_and_found_it_project/CustomWidgets/CustomTextField.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import '../../Utils/Globals.dart' as globals;

class EditEquipment extends StatefulWidget {
  final String equipmentId;
  EditEquipment({Key? key, required this.equipmentId}) : super(key: key);

  @override
  _AddEquipmentState createState() => _AddEquipmentState();
}

class _AddEquipmentState extends State<EditEquipment> {
  List<EquipmentStatus>? statuses;
  List<EquipmentType>? types;
  String? token;

  File? imageFile;
  EquipmentController equipmentController = new EquipmentController();
  Equipment? equipment;

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var statusDropdownSelectedItem;
  var typeDropdownSelectedItem;

  @override
  void initState() {
    super.initState();
    populatePage();
  }

  void populatePage() async {
    statuses = await equipmentController.getStatuses().catchError((e) {
      print(e.toString());
    });

    types = await equipmentController.getTypes().catchError((e) {
      print(e.toString());
    });

    final storage = new FlutterSecureStorage();
    token = await storage.read(key: "token");
    equipment = await equipmentController
        .getEquipment(widget.equipmentId)
        .catchError((e) {
      print(e.toString());
    });

    statusDropdownSelectedItem =
        equipment?.equipment_status?.equipment_status_id?.toString() ?? "1";
    typeDropdownSelectedItem =
        equipment?.equipment_type?.equipment_type_id?.toString() ?? "1";

    titleController.text =
        equipment?.equipment_name?.toString() ?? "Something went wrong";
    descriptionController.text =
        equipment?.equipment_description?.toString() ?? "Something went wrong";

    setState(() {});
  }

  void showImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });
  }

  Future<bool> updateEquipment() async {
    var title = titleController.text;
    var description = descriptionController.text;

    //make sure that there is no empty fields
    if (title.isEmpty ||
        description.isEmpty ||
        statusDropdownSelectedItem == null ||
        typeDropdownSelectedItem == null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Don\'t leave any inputs empty'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    } else {
      // take all the data and send it to the server
      bool completed = await equipmentController
          .editEquipment(
              equipment?.equipment_id ?? "null",
              title,
              description,
              statusDropdownSelectedItem,
              typeDropdownSelectedItem,
              imageFile ?? null)
          .catchError((e) {});
      return completed;
    }
    // equipmentController.editEquipment(title, description, statusId, typeId, imageFile);
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: GestureDetector(
              onTap: () async {
                await updateEquipment();
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Update",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: titleController,
                        hintText: "Equipment Name",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          bool delete = await showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Alert'),
                              content: const Text(
                                  'Are you sure you want to delete the equipment?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          );
                          if (delete) {
                            await equipmentController
                                .deleteEquipment(widget.equipmentId);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      GestureDetector(
                        onTap: () {
                          print("pick an image");
                          showImage();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: imageFile ==
                                        null // check if selected image is null and if go to network
                                    ? equipment !=
                                            null // check if there is equipment and then try to display original image from network
                                        ? Image.network(
                                            (equipment?.equipment_images
                                                        ?.isEmpty ==
                                                    true) // make sure that the image path has loaded then display, otherwise load placeholder
                                                ? globals.hostname +
                                                    "/img/placeholder.png"
                                                : globals.hostname +
                                                    "/api/user/image/" +
                                                    equipment!
                                                        .equipment_images![0]
                                                        .equipment_image_id
                                                        .toString() +
                                                    "?lost=0",
                                            headers: {
                                              'Authorization':
                                                  'Bearer ' + token!,
                                            },
                                            width: double.infinity,
                                            height: 160,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 160,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Image Couldn\'t Load!',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white),
                                                ),
                                              );
                                            },
                                          )
                                        : Image.network(
                                            globals.hostname +
                                                "/img/placeholder.png",
                                            width: double.infinity,
                                            height: 160,
                                            fit: BoxFit.cover,
                                          )
                                    : Image.file(
                                        imageFile!,
                                        width: double.infinity,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ) // if an image is selected than load that one for update to send
                                ),
                            Icon(
                              Icons.upload,
                              color: Colors.grey.shade700,
                              size: 42,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Describe your product breifly\n\n"),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Status: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //check if the statuses have returned then display them in a dropdown
                          statuses == null
                              ? CircularProgressIndicator()
                              : DropdownButton(
                                  value: statusDropdownSelectedItem,
                                  onChanged: (val) {
                                    statusDropdownSelectedItem = val;
                                    setState(() {
                                      print(val);
                                    });
                                  },
                                  items: statuses!.map((status) {
                                    return DropdownMenuItem<String>(
                                      value: status.equipment_status_id!
                                          .toString(),
                                      child: Text(
                                        status.equipment_status_value!
                                            .toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          statuses == null
                              ? CircularProgressIndicator()
                              : DropdownButton(
                                  value: typeDropdownSelectedItem,
                                  onChanged: (val) {
                                    typeDropdownSelectedItem = val;
                                    setState(() {
                                      print(val);
                                    });
                                  },
                                  items: types!.map((status) {
                                    return DropdownMenuItem<String>(
                                      value:
                                          status.equipment_type_id!.toString(),
                                      child: Text(
                                        status.equipment_type_value!.toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ],
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
