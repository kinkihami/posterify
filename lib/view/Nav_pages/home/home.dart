import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/constants/shimmer.dart';
import 'package:posterify/provider/logged.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/view%20model/common_view_model.dart';
import 'package:posterify/view/Nav_pages/profile/premium.dart';
import 'package:posterify/view/authentication/otp.dart';
import 'package:posterify/view/Nav_pages/search/category.dart';
import 'package:posterify/view/Nav_pages/home/edit.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<Expiry>(context, listen: false).expiry == true) {
        checkExpiryStatus();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // CommonViewModel value = Provider.of<CommonViewModel>(context, listen: false);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color primaryColor = isDark ? darkPrimaryColor : lightPrimaryColor;
    Color bgColor = isDark
        ? ThemeData.dark().scaffoldBackgroundColor
        : Theme.of(context).scaffoldBackgroundColor;

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                surfaceTintColor: Colors.transparent,
                backgroundColor: bgColor,
                elevation: 10,
                bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: Divider(
                      height: 0,
                    )),
                title: Text(
                  'Posterify',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                      fontFamily: 'DMSerif'),
                ),
                floating: true,
                expandedHeight: 50,
                snap: true,
              ),
            ];
          },
          body: Consumer<CommonViewModel>(builder: (context, value, child) {
           log("category list in home ==== "+value.categoryList.length.toString());

            return ShimmerLoading(
              isLoading: value.categoryLoading,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.categoryList.length,
                itemBuilder: (context, index) {
                  final data = value.categoryList[index];
                  log('category data========= $data');
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.name,
                                style: headingBlackStyle,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScreenCategory(
                                                  title: data.name,
                                                  catid: data.id,
                                                ))),
                                    child: Text(
                                      'View All',
                                      style: isDark
                                          ? lightTextStyle
                                          : darkTextStyle,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black45,
                                    size: 15,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size2(context),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: value.getTempleteByCategory(data.id).length,
                            itemBuilder: (context, index) {
                              final templete =
                                  value.getTempleteByCategory(data.id)[index];
                              return ShimmerLoading(
                                isLoading: value.templeteLoading,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () => !Provider.of<Logged>(context,
                                                listen: false)
                                            .initialized
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const ScreenOTP()))
                                        : templete.premium == 0 ||
                                                value.userList!.premium != 1
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        ScreenEdit(
                                                          image: templete.image,
                                                        )))
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const ScreenPremium())),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                            width: size3(context),
                                            height: size2(context),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                WebService().imageUrl +
                                                    templete.image,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return ShimmerLoading(
                                                      isLoading: true,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        color: Colors
                                                            .grey, // Placeholder color until image loads
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            )),
                                        !Provider.of<Logged>(context,
                                                        listen: false)
                                                    .initialized ||
                                                value.userList!.premium == 1
                                            ? templete.premium == 1
                                                ? Positioned(
                                                    right: 10,
                                                    bottom: 10,
                                                    child: Image.asset(
                                                      'assets/image/crown.png',
                                                      width: 20,
                                                    ),
                                                  )
                                                : const SizedBox()
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> checkExpiryStatus() async {
    expiryAlert(context, Provider.of<Expiry>(context, listen: false).day!);
  }
}

expiryAlert(context, int days) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: days == 0
              ? const Text(
                  'Your plan has expired',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )
              : Text(
                  'Your plan will expire in $days days!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<Expiry>(context, listen: false).setExpiry(false);
              },
              child: Text(
                'OK',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ],
        );
      });
}
