
import 'package:posterify/model/category_model.dart';

class CategoryViewModel{
  final CategoryModel categoryModel;

  CategoryViewModel({required this.categoryModel});
  
  int get id => categoryModel.id;
  String get name => categoryModel.name;

}