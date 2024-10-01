

import 'package:posterify/model/project_model.dart';

class ProjectViewModel {
  final ProjectModel projectModel;

  ProjectViewModel({required this.projectModel});

  String get image => projectModel.image;
}




