
import 'package:flutter/material.dart';

class Logged with ChangeNotifier{
  bool initialized = false;

  bool get initialize => initialized;
  
  void setInitialized(bool value){
    initialized = value;
    notifyListeners();
  }
}

class Expiry with ChangeNotifier{
  bool expiry = false;
  int? day;

  bool get expire => expiry;
  int? get expireDay => day;
  
  void setExpiry(bool value){
    expiry = value;
    notifyListeners();
  }

  void setDay(int value){
    day = value;
    notifyListeners();
  }

}