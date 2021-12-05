class User {
  String? imagePath;
  String? name;
  String? email;
  String? phone;

  User({String? imagePath, String? name, String? email, String? phone}) {
    this.imagePath = imagePath;
    this.name = name;
    this.email = email;
    this.phone = phone;
  }

  User.fromJson(Map<String, dynamic> json)
      : this.imagePath = "null",
        this.name = json["name"],
        this.email = json["email"],
        this.phone = json["mobile_number"];
}
