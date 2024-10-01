
import 'package:posterify/model/templete_model.dart';

class TempleteViewModel {
  final TempleteModel templeteModel;

  TempleteViewModel({required this.templeteModel});

  String get image => templeteModel.image;
  int get premium => templeteModel.premium;
}



