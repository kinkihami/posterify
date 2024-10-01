// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:posterify/model/category_model.dart';
import 'package:posterify/model/details_model.dart';
import 'package:posterify/model/expiry_model.dart';
import 'package:posterify/model/premium_model.dart';
import 'package:posterify/model/project_model.dart';
import 'package:posterify/model/templete_model.dart';
import 'package:posterify/model/user_model.dart';
import 'package:posterify/provider/logged.dart';
import 'package:posterify/shared_preference.dart';
import 'package:posterify/view/Nav_pages/bottomnavigationbar.dart';
import 'package:posterify/view/authentication/shop_details.dart';
import 'package:provider/provider.dart';

class WebService {
  
  // final baseurl = 'https://posterify.cyralearnings.com';
  final baseurl = 'http://localhost/posterify/api/';

  String get imageUrl => '$baseurl/templetes/';
  String get projectUrl => '$baseurl/projects/';

  Future<void> register(String phone, String name, String email, String shop,
      File? image, BuildContext context) async {
    try {
      final String? phonenumber = await Sharedstore.getphone();

      FormData formData;

      if (image != null) {
        String fileName = image.path.split('/').last;

        formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path, filename: fileName),
          'shop': shop,
          'phone': phone,
          'user_phone': phonenumber,
          'email': email,
          'name': name,
        });
      } else {
        formData = FormData.fromMap({
          'shop': shop,
          'phone': phone,
          'user_phone': phonenumber,
          'email': email,
          'name': name,
        });
      }

      final response =
          await Dio().post('$baseurl/api/details.php',
              data: formData,
              options: Options(
                contentType: 'application/json; charset=UTF-8',
                responseType: ResponseType.plain,
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjQxNTU5MzYzLCJqdGkiOiJlOTBiZjIyYjI5YTg0YmRhYWNlZmIxZTY0Y2M2OTk1YyIsInVzZXJfaWQiOjF9.aDQzoYRawmXUCLxzEW8mb4e9OcR4L8YhcyjQIaBFUxk'
                },
              ));

      log('Response received: ${response.data}');

      if (response.statusCode == 200) {
        log('status code 200');
        try {
          final Map<String, dynamic> response1 = jsonDecode(response.data);

          if (response1['msg'] == 'Success') {
            Sharedstore.setLoggedin(true);
            Provider.of<Logged>(context, listen: false).setInitialized(true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => const Bottomnavigationbar()),
            );
          } else {
            log('Signup failed: ${response1['msg']}');
          }
        } catch (e) {
          log('error $e');
        }
      } else {
        log('Error: Status code not 200, received: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<List<CategoryModel>?> fetchCategoryList() async {
    log('inside');

    final response =
        await Dio().get('$baseurl/api/categories.php');
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      log('asdasdasdas ${data.toString()}');
      return data
          .map<CategoryModel>((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<UserModel?> fetchUser() async {
    log('inside');

    // Await the result of Sharedstore.getphone()
    final String? phone = await Sharedstore.getphone();

    if (phone == null) {
      log('Phone number is null');
      return null;
    }

    final Map<String, dynamic> data = {
      'phone': phone,
    };

    try {
      // Use `queryParameters` instead of `data` for GET requests
      final response = await Dio().get(
        '$baseurl/api/user_details.php',
        queryParameters: data, // This should be queryParameters, not data
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Response data: ${response.data.toString()}');
        final Map<String, dynamic> data = response.data;
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<List<TempleteModel>?> fetchtemplete(catid) async {
    log('inside');

    final Map<String, dynamic> data = {
      'catid': catid,
    };

    try {
      // Use `queryParameters` instead of `data` for GET requests
      final response = await Dio().get(
        '$baseurl/api/category_posters.php',
        queryParameters: data, // This should be queryParameters, not data
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('status code: 200');

        final List<dynamic> data = response.data;
        log('Response data: ${data.toString()}');
        return data
            .map<TempleteModel>((json) => TempleteModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<List<ProjectModel>?> fetchproject() async {
    final String? phone = await Sharedstore.getphone();
    log('inside');

    final Map<String, dynamic> data = {
      'phone': phone,
    };

    try {
      final response = await Dio().get(
        '$baseurl/api/projects.php',
        queryParameters: data,
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        log('Response data: ${data.toString()}');
        return data
            .map<ProjectModel>((json) => ProjectModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<void> checkUser(BuildContext context) async {
    log('Checking user...');

    final String? phone = await Sharedstore.getphone();

    if (phone == null) {
      log('Phone number is null');
      return;
    }

    final Map<String, dynamic> data = {
      'phone': phone,
    };

    try {
      final response = await Dio().get(
        '$baseurl/api/checking.php',
        queryParameters: data,
      );

      log('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> response1 = response.data;

        if (response1['exists'] == true) {
          Sharedstore.setLoggedin(true);
          Provider.of<Logged>(context, listen: false).setInitialized(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (ctx) => const Bottomnavigationbar()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (ctx) => const ScreenDetails()));
        }
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<ExpiryModel?> fetchExpiry() async {
    log('inside');

    // Await the result of Sharedstore.getphone()
    final String? phone = await Sharedstore.getphone();

    if (phone == null) {
      log('Phone number is null');
      return null;
    }

    final Map<String, dynamic> data = {
      'phone': phone,
    };

    try {
      final response = await Dio().get(
        '$baseurl/api/planexpiry.php',
        queryParameters: data,
      );

      log('fasasfafasf ${response.statusCode.toString()}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        log('Response data: ${data.toString()}');
        return ExpiryModel.fromJson(data);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<DetailsModel?> fetchDetails() async {
    log('inside');

    // Await the result of Sharedstore.getphone()
    final String? phone = await Sharedstore.getphone();

    if (phone == null) {
      log('Phone number is null');
      return null;
    }

    final Map<String, dynamic> data = {
      'phone': phone,
    };

    try {
      // Use `queryParameters` instead of `data` for GET requests
      final response = await Dio().get(
        '$baseurl/api/shop_details.php',
        queryParameters: data, // This should be queryParameters, not data
      );

      log('fasasfafasf ${response.statusCode.toString()}');

      if (response.statusCode == 200) {

        log('Response data ggggggggggggggggggggggggggg: ${response.data.toString()}');
        final Map<String, dynamic> data = response.data;
        return DetailsModel.fromJson(data);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<List<PremiumModel>?> fetchPremiumList() async {
    final response =
        await Dio().get('$baseurl/api/premium.php');
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      log('asdasdasdas ${data.toString()}');
      return data
          .map<PremiumModel>((json) => PremiumModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> updateDetailsImage(String phone, String email, String shop,
      File image, BuildContext context) async {
    try {
      final isSavedNotifier = ValueNotifier<bool>(false);
      showLoadingDialog(context, isSavedNotifier);
      final String? phonenumber = await Sharedstore.getphone();
      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'shop': shop,
        'phone': phone,
        'user_phone': phonenumber,
        'email': email,
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      final response = await Dio().post(
        '$baseurl/api/update_shop_details_image.php',
        data: formData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> response1 = response.data;

        if (response1['msg'] == 'Success') {
          log('success');
          isSavedNotifier.value = true;
          await Future.delayed(
            const Duration(seconds: 2),
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          log('Signup failed: ${response1['msg']}');
        }
      } else {
        log('Error: Status code not 200, received: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> updateDetails(
      String phone, String email, String shop, BuildContext context) async {
    try {
      final isSavedNotifier = ValueNotifier<bool>(false);
      showLoadingDialog(context, isSavedNotifier);
      final String? phonenumber = await Sharedstore.getphone();

      FormData formData = FormData.fromMap({
        'shop': shop,
        'phone': phone,
        'user_phone': phonenumber,
        'email': email,
      });
      final response = await Dio().post(
        '$baseurl/api/update_shop_details.php',
        data: formData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> response1 = response.data;

        if (response1['msg'] == 'Success') {
          log('success');
          isSavedNotifier.value = true;
          await Future.delayed(
            const Duration(seconds: 2),
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          log('Signup failed: ${response1['msg']}');
        }
      } else {
        log('Error: Status code not 200, received: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  void showLoadingDialog(
      BuildContext context, ValueNotifier<bool> isSavedNotifier) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<bool>(
          valueListenable: isSavedNotifier,
          builder: (context, isSaved, child) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSaved
                      ? LottieBuilder.asset(
                          'assets/lottie/tick.json',
                          repeat: false,
                          height: 100,
                        )
                      : LottieBuilder.asset(
                          'assets/lottie/loading.json',
                          height: 100,
                        ),
                  isSaved
                      ? const Text(
                          "Updated Successfully",
                          style: TextStyle(fontFamily: 'Sora', fontSize: 20),
                        )
                      : const Text("Loading...",
                          style: TextStyle(fontFamily: 'Sora', fontSize: 20)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> uploadProject(File image) async {
    try {
      final String? phonenumber = await Sharedstore.getphone();

      if (phonenumber == null || phonenumber.isEmpty) {
        debugPrint('Phone number not found');
        return;
      }

      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
        "phone": phonenumber, // Send the phone number
      });

      final response = await Dio().post(
        '$baseurl/api/save_project.php ',
        data: formData,
      );

      if (response.statusCode == 200) {
        debugPrint('Image and phone number uploaded successfully');
      } else {
        debugPrint('Failed to upload');
      }
    } catch (e) {
      log('Error aa: $e');
    }
  }

  Future<void> premiumRecharge(int id, int amt, String transactionId) async {
    final String? phone = await Sharedstore.getphone();
    int? months;

    if (id == 1) {
      months = 12;
    } else if (id == 2) {
      months = 6;
    } else {
      months = 1;
    }

    final joinDate = DateTime.now();
    var formattedJoinDate =
        "${joinDate.year}-${joinDate.month}-${joinDate.day}";
    log(formattedJoinDate);

    final expiryDate = DateTime(
        joinDate.year + ((joinDate.month + months) ~/ 12),
        (joinDate.month + months) % 12 == 0
            ? 12
            : (joinDate.month + months) % 12,
        joinDate.day);
    var formattedExpiryDate =
        "${expiryDate.year}-${expiryDate.month}-${expiryDate.day}";
    log(formattedExpiryDate);

    final Map<String, dynamic> detailsdata = {
      'premium': id,
      'phone': phone,
      'joindate': formattedJoinDate,
      'expirydate': formattedExpiryDate,
      'amount': amt,
      'transactionid': transactionId,
    };

    try {
      final response = await Dio().post(
        '$baseurl/api/premium_recharge.php',
        data: detailsdata,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> response1 = response.data;

        if (response1['msg'] == 'Success') {
          log('success-------------');
        } else {
          log('Signup failed: ${response1['msg']}');
        }
      } else {
        log('Error: Status code not 200, received: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> updatePremium(int premium) async {
    debugPrint('updatePremium called $premium');

    final String? phone = await Sharedstore.getphone();

    FormData formData = FormData.fromMap({
      'premium': premium,
      'phone': phone,
    });

    log("aaaaa----" + formData.toString());

    try {
      final response = await Dio()
          .post('$baseurl/api/update_premium.php',
              data: formData,
              options: Options(
                contentType: 'application/json; charset=UTF-8',
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjQxNTU5MzYzLCJqdGkiOiJlOTBiZjIyYjI5YTg0YmRhYWNlZmIxZTY0Y2M2OTk1YyIsInVzZXJfaWQiOjF9.aDQzoYRawmXUCLxzEW8mb4e9OcR4L8YhcyjQIaBFUxk'
                },
              ));

      if (response.statusCode == 200) {
        debugPrint('response======== ${response.data}');
        final Map<String, dynamic> response1 = response.data;

        if (response1['msg'] == 'Success') {
          log('success-------------');
        } else {
          log('Signup failed: ${response1['msg']}');
        }
      } else {
        log('Error: Status code not 200, received: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
