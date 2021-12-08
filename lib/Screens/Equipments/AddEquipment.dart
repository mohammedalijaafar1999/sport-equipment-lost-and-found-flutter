import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/EquipmentController.dart';
import 'package:sports_equipment_lost_and_found_it_project/CustomWidgets/CustomTextField.dart';
import 'package:sports_equipment_lost_and_found_it_project/Model/Equipment.dart';
import '../../Utils/Globals.dart' as globals;

class AddEquipment extends StatefulWidget {
  AddEquipment({Key? key}) : super(key: key);

  @override
  _AddEquipmentState createState() => _AddEquipmentState();
}

class _AddEquipmentState extends State<AddEquipment> {
  List<EquipmentStatus>? statuses;
  List<EquipmentType>? types;
  String? token;

  File? imageFile;
  EquipmentController equipmentController = new EquipmentController();

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
    setState(() {
      statusDropdownSelectedItem =
          statuses?[0].equipment_status_id?.toString() ?? "1";
      typeDropdownSelectedItem = types?[0].equipment_type_id?.toString() ?? "1";
    });
  }

  void showImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });
  }

  void addEquipment() async {
    var title = titleController.text;
    var description = descriptionController.text;

    //make sure that there is no empty fields
    if (title.isEmpty ||
        description.isEmpty ||
        title.trim() == "" ||
        description.trim() == "" ||
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
    } else {
      //check that there is an image selected
      if (imageFile == null) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Alert'),
            content: const Text('Please select an image'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // take all the data and send it to the server
        var completed = await equipmentController
            .addEquipment(title, description, statusDropdownSelectedItem,
                typeDropdownSelectedItem, imageFile!)
            .catchError((e) {});
        if (completed) {
          Navigator.pop(context);
        }
      }
    }
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
              onTap: () {
                print("Created");
                addEquipment();
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
                      "Create",
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
                child: CustomTextField(
                  controller: titleController,
                  hintText: "Equipment Name",
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
                              child: imageFile != null
                                  ? Image.file(imageFile!)
                                  : Image.network(
                                      globals.hostname + "/img/placeholder.png",
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
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
                        style: Theme.of(context).textTheme.headline3,
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
