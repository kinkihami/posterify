class UserModel {
  int id;
  String name;
  String phone;
  int premium;

  UserModel({required this.id, required this.name, required this.phone, required this.premium});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'].toString(),
      premium: json['premium'],
    );
  }
}
