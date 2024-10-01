

import 'package:posterify/model/premium_model.dart';

class PremiumViewModel{
  final PremiumModel premiumModel;

  PremiumViewModel({required this.premiumModel});

  String get duration => premiumModel.duration;
  String get price => premiumModel.price;
  int get id => premiumModel.id;

}


