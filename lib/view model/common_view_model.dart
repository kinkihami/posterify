import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/view%20model/category_view_model.dart';
import 'package:posterify/view%20model/details_view_model.dart';
import 'package:posterify/view%20model/expiry_view_model.dart';
import 'package:posterify/view%20model/premium_view_model.dart';
import 'package:posterify/view%20model/projects_view_model.dart';
import 'package:posterify/view%20model/templete_view_model.dart';
import 'package:posterify/view%20model/user_view_model.dart';

class CommonViewModel extends ChangeNotifier{
   bool _categoryLoad = false; 

  bool get categoryLoading => _categoryLoad; 

  // set categoryLoading(bool value) { 
  //   categoryLoad = value;
  //   notifyListeners();
  // }

  List<CategoryViewModel> categoryList = [];

  Future<List<CategoryViewModel>> fetchCategory() async {
    _categoryLoad = true;
    final result = await WebService().fetchCategoryList();
    
    if (result != null) {
      categoryList = result.map((category) => CategoryViewModel(categoryModel: category)).toList();
    }
    log('category list ========== ${categoryList.length}');
    log('Category Loading Completed');
    _categoryLoad = false;
    notifyListeners();
    return categoryList;
  } 

bool detailsLoad = false; 

  bool get detailsLoading => detailsLoad; 

  set detailsLoading(bool value) { 
    detailsLoad = value;
    notifyListeners();
  }

  DetailsViewModel? detailsList;

  Future<void> fetchDetails() async {
    detailsLoading = true;
    final result = await WebService().fetchDetails();
    if (result != null) {
      detailsList = DetailsViewModel(detailsModel: result);
    }
    log('Details Loading completed');
    notifyListeners();
    detailsLoading = false;
  }


bool expiryLoad = false; 


  bool get expiryLoading => expiryLoad; 

  set expiryLoading(bool value) { 
    expiryLoad = value;
    notifyListeners();
  }

   ExpiryViewModel? expiry;

  Future<void> fetchExpiry() async {
    expiryLoading = true;
    final result = await WebService().fetchExpiry();
    log('expiryyyyyyyy resulttttttt ========= ${result!.expiryDate}');
    if (result != null) {
      expiry = ExpiryViewModel(expiryModel: result);
      
    }
    log('Expiry Loading completed');
    notifyListeners();
    expiryLoading = false;
  }

 bool premiumLoad = false; 

  bool get premiumLoading => premiumLoad; 

  set premiumLoading(bool value) { 
    premiumLoad = value;
    notifyListeners();
  }

  List<PremiumViewModel> premiumList = [];

  Future<void> fetchPremium() async {
    premiumLoading = true;
    final result = await WebService().fetchPremiumList();
    if (result != null) {
      premiumList = result.map((plan) => PremiumViewModel(premiumModel: plan)).toList();
    }
    log('Premium Loading completed');
    notifyListeners();
    premiumLoading = false;
  }


   bool projectLoad = false;

  bool get projectLoading => projectLoad;

  set projectLoading(bool value) {
    projectLoad = value;
    notifyListeners();
  }

    List <ProjectViewModel> projectList = [];

  Future<void> fetchProject() async {
    projectLoading = true;
    final result = await WebService().fetchproject();
    if (result != null) {
      projectList = result.map((project) => ProjectViewModel(projectModel: project)).toList();
    }
    log('Projects Loading completed');
    notifyListeners();
    projectLoading = false;
  }


bool templeteLoad = false;

  bool get templeteLoading => templeteLoad;

  set templeteLoading(bool value) {
    templeteLoad = value;
    notifyListeners();
  }

  final Map<int, List<TempleteViewModel>> _templetesByCategory = {};

  // Method to retrieve templates for a specific category
  List<TempleteViewModel> getTempleteByCategory(int categoryId) {
    return _templetesByCategory[categoryId] ?? [];
  }

  Future<void> fetchTempletes(int id) async {
    templeteLoading = true;
    final result = await WebService().fetchtemplete(id);
    if (result != null) {
      _templetesByCategory[id] = result
          .map((templete) => TempleteViewModel(templeteModel: templete))
          .toList();
    }
    log('Completed fetching templates for category $id');
    templeteLoading = false;
    notifyListeners();
  }

    List <TempleteViewModel> templeteList = [];

  Future<void> fetchTemplete(id) async {
    templeteLoading = true;
    final result = await WebService().fetchtemplete(id);
    if (result != null) {
      templeteList = result.map((templete) => TempleteViewModel(templeteModel: templete)).toList();
    }
    log('Templete Loading completed');
    notifyListeners();
    templeteLoading = false;
  }

  bool userLoad = false; 

  bool get userLoading => userLoad; 

  set userLoading(bool value) { 
    userLoad = value;
    notifyListeners();
  }

  UserViewModel? userList;

  Future<void> fetchUser() async {
    userLoading = true;
    final result = await WebService().fetchUser();
    if (result != null) {
      userList = UserViewModel(userModel: result);
    }
    log('User Loading completed');
    notifyListeners();
    userLoading = false;
  }

}