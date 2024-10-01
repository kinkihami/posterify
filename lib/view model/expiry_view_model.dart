

import 'package:posterify/model/expiry_model.dart';

class ExpiryViewModel{
  final ExpiryModel expiryModel;

  ExpiryViewModel({required this.expiryModel});
  
  int get date => expiryModel.expiryDate;

}
 
