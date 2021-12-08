class User {
  String? imagePath;
  String? name;
  String? email;
  String? phone;
  String? createdAt;

  User(
      {String? imagePath,
      String? name,
      String? email,
      String? phone,
      String? createdAt}) {
    this.imagePath = imagePath;
    this.name = name;
    this.email = email;
    this.phone = phone;
  }

  User.fromJson(Map<String, dynamic> json)
      : this.imagePath = "null",
        this.name = json["name"],
        this.email = json["email"],
        this.phone = json["mobile_number"],
        this.createdAt = json["created_at"];

  DateTime getYearJoined() {
    DateTime joined = DateTime.parse("2012-02-27");
    if (this.createdAt != null) {
      joined = DateTime.parse(this.createdAt!);
    }
    return joined;
  }
}
