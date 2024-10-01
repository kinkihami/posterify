

import 'package:posterify/model/user_model.dart';

class UserViewModel{
  final UserModel userModel;

  UserViewModel({required this.userModel});

  int get id => userModel.id;
  String get name => userModel.name;
  String get phone => userModel.phone;
  int get premium => userModel.premium;

}


