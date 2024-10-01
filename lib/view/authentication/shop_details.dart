import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/service/web_service.dart';

class ScreenDetails extends StatefulWidget {
  const ScreenDetails({super.key});

  @override
  State<ScreenDetails> createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  File? image1;
  String? image;

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool areFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_checkFields);
    nameController.addListener(_checkFields);
    shopController.addListener(_checkFields);
    emailController.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      areFieldsFilled = phoneController.text.length == 10 &&
          nameController.text.isNotEmpty &&
          shopController.text.isNotEmpty &&
          emailController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    shopController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = isDark ? darkPrimaryColor : lightPrimaryColor;
    Color borderColor = isDark ? white : black;
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Divider(
              height: 0,
            )),
        surfaceTintColor: Colors.transparent,
        backgroundColor: !isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : ThemeData.dark().scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          'Shop Details',
          style: headingBlackStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 20,
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50.5,
                    backgroundColor: borderColor,
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      backgroundImage:
                          image1 != null ? FileImage(image1!) : null,
                      radius: 50,
                      child: image1 != null ? null : const Text('Logo'),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: IconButton(
                            onPressed: () {
                              fromGallery();
                            },
                            icon: const Icon(Icons.camera_alt_outlined)),
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 20,
              ),
              TextFormField(
                controller: nameController,
                cursorColor: black,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    child: !isDark
                        ? SvgPicture.asset(
                            'assets/icons/black_profile.svg',
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/icons/white_profile.svg',
                            height: 20,
                          ),
                  ),
                  hintText: 'Full Name',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5, color: borderColor),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 40,
              ),
              TextFormField(
                controller: shopController,
                cursorColor: black,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    child: !isDark
                        ? SvgPicture.asset(
                            'assets/icons/black_shop.svg',
                            height: 25,
                          )
                        : SvgPicture.asset(
                            'assets/icons/white_shop.svg',
                            height: 25,
                          ),
                  ),
                  hintText: 'Shop Name',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5, color: borderColor),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 40,
              ),
              TextFormField(
                controller: phoneController,
                cursorColor: black,
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                decoration: InputDecoration(
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    child: !isDark
                        ? SvgPicture.asset(
                            'assets/icons/black_phone.svg',
                            height: 25,
                          )
                        : SvgPicture.asset(
                            'assets/icons/white_phone.svg',
                            height: 25,
                          ),
                  ),
                  hintText: 'Shop Phone',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5, color: borderColor),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 40,
              ),
              TextFormField(
                controller: emailController,
                cursorColor: black,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    child: !isDark
                        ? SvgPicture.asset(
                            'assets/icons/black_email.svg',
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/icons/white_email.svg',
                            height: 20,
                          ),
                  ),
                  hintText: 'Shop Email',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1.5, color: borderColor),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 40,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 20,
              ),
              GestureDetector(
                onTap: () {
                  if (areFieldsFilled &&
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailController.text)) {
                    if (image1 != null) {
                      WebService().register(
                          phoneController.text,
                          nameController.text,
                          emailController.text,
                          shopController.text,
                          image1,
                          context);
                    } else {
                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  'Are you sure to continue without Logo?',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    WebService().register(
                                        phoneController.text,
                                        nameController.text,
                                        emailController.text,
                                        shopController.text,
                                        image1,
                                        context);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          });
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: areFieldsFilled &&
                            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(emailController.text)
                        ? primaryColor
                        : primaryColor.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: areFieldsFilled &&
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(emailController.text)
                            ? Colors.white
                            : Colors.white54,
                        fontFamily: 'DMSerif',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fromGallery() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          image1 = File(img.path);
          image = image1!.path;
        });
      }
    } catch (e) {
      debugPrint(e.toString()); // Handle the error properly in a real app
    }
  }
}
