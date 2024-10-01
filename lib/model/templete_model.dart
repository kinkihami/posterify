class TempleteModel {
  int id;
  String image;
  int premium;

  TempleteModel({required this.id, required this.image, required this.premium});

  factory TempleteModel.fromJson(Map<String, dynamic> json) {
    return TempleteModel(
      id: json['id'],
      image: json['image'],
      premium: json['premium'],
    );
  }
}