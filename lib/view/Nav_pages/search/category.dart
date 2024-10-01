import 'package:flutter/material.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/constants/shimmer.dart';
import 'package:posterify/provider/logged.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/view%20model/common_view_model.dart';

import 'package:posterify/view/Nav_pages/home/edit.dart';
import 'package:posterify/view/Nav_pages/profile/premium.dart';
import 'package:posterify/view/authentication/otp.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ScreenCategory extends StatefulWidget {
  String title;
  int catid;

  ScreenCategory({super.key, required this.title, required this.catid});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory> {
  CommonViewModel? vm;

  @override
  void initState() {
    vm = Provider.of<CommonViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm!.fetchTemplete(widget.catid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          widget.title,
          style: headingBlackStyle,
        ),
        centerTitle: true,
      ),
      body: Consumer<CommonViewModel>(builder: (context, value, child) {
        return ShimmerLoading(
          isLoading: value.categoryLoading,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size40(context),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 0.8,
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(
                        vm!.templeteList.length,
                        (index) => GestureDetector(
                              onTap: () => !Provider.of<Logged>(context,
                                          listen: false)
                                      .initialized
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              const ScreenOTP()))
                                  : vm!.templeteList[index].premium == 0 ||
                                                        vm!.userList!
                                                                .premium != 1
                                      ?Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => ScreenEdit(
                                                    image: vm!
                                                        .templeteList[index]
                                                        .image,
                                                  ))) : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const ScreenPremium()))
                                      ,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        WebService().imageUrl +
                                            vm!.templeteList[index].image,
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
                                    ),
                                  ),
                                  !Provider.of<Logged>(context,
                                                                listen: false)
                                                            .initialized ||
                                                        vm!.userList!
                                                                .premium ==
                                                            1
                                                    ? vm!.templeteList[index].premium == 1
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
                            )),
                  ),
                  SizedBox(
                    height: size40(context),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
