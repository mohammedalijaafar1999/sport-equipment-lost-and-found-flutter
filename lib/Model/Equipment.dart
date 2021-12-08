class Equipment {
  static int equipmentsCount = 0;
  static int equipmentsLostCount = 0;
  static int equipmentsDeletedCount = 0;

  // class variables
  // ignore: non_constant_identifier_names
  String? equipment_id;
  // ignore: non_constant_identifier_names
  String? equipment_name;
  // ignore: non_constant_identifier_names
  String? equipment_description;
  // ignore: non_constant_identifier_names
  String? user_id;
  // ignore: non_constant_identifier_names
  EquipmentStatus? equipment_status;
  // ignore: non_constant_identifier_names
  List<EquipmentImage>? equipment_images;
  // ignore: non_constant_identifier_names
  EquipmentType? equipment_type;

  //constructor
  Equipment();

  Equipment.fromJson(Map<String, dynamic> json)
      : equipment_id = json['equipment_id'].toString(),
        equipment_name = json['equipment_name'],
        equipment_description = json['equipment_description'],
        user_id = json['user_id'].toString(),
        equipment_status = EquipmentStatus.fromJson(json['equipment_status']),
        equipment_type = EquipmentType.fromJson(json["equipment_type"]),
        equipment_images = EquipmentImage.getImages(json["equipment_images"]);

  @override
  String toString() {
    var str = (equipment_id! + " - " + equipment_name!);
    return str;
    //return super.toString();
  }
}

class EquipmentStatus {
  // class variables
  // ignore: non_constant_identifier_names
  String? equipment_status_id;
  // ignore: non_constant_identifier_names
  String? equipment_status_value;
  // ignore: non_constant_identifier_names
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;

  //constructor
  EquipmentStatus();

  EquipmentStatus.fromJson(Map<String, dynamic> json)
      : equipment_status_id = json['equipment_status_id'].toString(),
        equipment_status_value = json['equipment_status_value'],
        created_at = json['created_at'].toString(),
        updated_at = json['updated_at'].toString();
}

class EquipmentImage {
  // class variables
  // ignore: non_constant_identifier_names
  String? equipment_image_id;
  // ignore: non_constant_identifier_names
  String? equipment_image_path;
  // ignore: non_constant_identifier_names
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;
  // ignore: non_constant_identifier_names
  String? equipment_id;

  // ignore: non_constant_identifier_names
  static List<EquipmentImage> getImages(equipment_images_json) {
    var list = equipment_images_json as List;
    List<EquipmentImage> imagesList =
        list.map((i) => EquipmentImage.fromJson(i)).toList();
    return imagesList;
  }

  //constructor
  EquipmentImage();

  EquipmentImage.fromJson(Map<String, dynamic> json)
      : equipment_image_id = json["equipment_image_id"].toString(),
        equipment_image_path = json["equipment_image_path"],
        created_at = json["created_at"].toString(),
        updated_at = json["updated_at"].toString(),
        equipment_id = json["equipment_id"].toString();
}

class EquipmentType {
  // class variables
  // ignore: non_constant_identifier_names
  String? equipment_type_id;
  // ignore: non_constant_identifier_names
  String? equipment_type_value;
  // ignore: non_constant_identifier_names
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;

  //constructor
  EquipmentType();

  EquipmentType.fromJson(Map<String, dynamic> json)
      : equipment_type_id = json['equipment_type_id'].toString(),
        equipment_type_value = json['equipment_type_value'],
        created_at = json['created_at'].toString(),
        updated_at = json['updated_at'].toString();
}
