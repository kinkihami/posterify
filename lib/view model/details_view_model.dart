

import 'package:posterify/model/details_model.dart';

class DetailsViewModel{
  final DetailsModel detailsModel;

  DetailsViewModel({required this.detailsModel});

  String get shop => detailsModel.shop;
  String get email => detailsModel.email;
  String get phone => detailsModel.phone;
  String get logo => detailsModel.logo;

}


