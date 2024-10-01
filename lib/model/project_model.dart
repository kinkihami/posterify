class ProjectModel {
  int id;
  String image;

  ProjectModel({required this.id, required this.image});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      image: json['image'],
    );
  }
}