class Equipment {
  // class variables
  String? equipment_id;
  String? equipment_name;
  String? equipment_description;
  String? user_id;
  EquipmentStatus? equipment_status;
  List<EquipmentImage>? equipment_images;
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
  String? equipment_status_id;
  String? equipment_status_value;
  String? created_at;
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
  String? equipment_image_id;
  String? equipment_image_path;
  String? created_at;
  String? updated_at;
  String? equipment_id;

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
  String? equipment_type_id;
  String? equipment_type_value;
  String? created_at;
  String? updated_at;

  //constructor
  EquipmentType();

  EquipmentType.fromJson(Map<String, dynamic> json)
      : equipment_type_id = json['equipment_type_id'].toString(),
        equipment_type_value = json['equipment_type_value'],
        created_at = json['created_at'].toString(),
        updated_at = json['updated_at'].toString();
}
