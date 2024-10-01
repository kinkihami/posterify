import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/provider/logged.dart';
import 'package:posterify/shared_preference.dart';
import 'package:posterify/view%20model/common_view_model.dart';
import 'package:posterify/view/authentication/otp.dart';
import 'package:posterify/view/Nav_pages/profile/edit_shop_details.dart';
import 'package:posterify/view/Nav_pages/profile/settings.dart';
import 'package:posterify/view/Nav_pages/profile/premium.dart';
import 'package:provider/provider.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({super.key});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  @override
  Widget build(BuildContext context) {
    CommonViewModel? vm =
        Provider.of<CommonViewModel>(context, listen: false);

    bool isLogged = Provider.of<Logged>(context).initialized;

    log(isLogged.toString());

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color primaryColor = isDark ? darkPrimaryColor : lightPrimaryColor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Text(
            'Profile',
            style: projectStyle,
          ),
        ),
        body: Consumer<CommonViewModel>(builder: (context, value, child) {
          return value.userLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Divider(),
                        SizedBox(
                          height: size20(context),
                        ),
                        !isLogged
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "You're not logged in. Please register to create your account and access your profile.",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: size20(context),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              const ScreenOTP(),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: primaryColor,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: const Text(
                                          'Go To Registration',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'SF',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size20(context),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 35,
                                        child: Text(
                                          vm.userList!.name.substring(0, 1),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: 'SF',
                                              fontWeight: FontWeight.w700,
                                              color: !isDark
                                                  ? Theme.of(context)
                                                      .scaffoldBackgroundColor
                                                  : ThemeData.dark()
                                                      .scaffoldBackgroundColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size20(context),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vm.userList!.name,
                                            style: headingBlackStyle,
                                          ),
                                          Text(
                                            vm.userList!.phone,
                                            style: primaryTextStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size20(context),
                                  ),
                                  const Divider(),
                                  vm.userList!.premium == 1
                                      ? Column(
                                          children: [
                                            Card(
                                              elevation: 5,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: const BorderSide(
                                                    color: Color(0xfffaac18),
                                                  )),
                                              clipBehavior: Clip.hardEdge,
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Get more with Premium',
                                                        style: TextStyle(
                                                            fontFamily: 'SF',
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              size40(context)),
                                                      const Text(
                                                          '\u2022 Access all posters.'),
                                                      const Text(
                                                          '\u2022 Unlock exclusive templates.'),
                                                      const Text(
                                                          '\u2022 Download in high resolution.'),
                                                      const Text(
                                                          '\u2022 Download in multiple formats. '),
                                                      SizedBox(
                                                        height: size40(context),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (ctx) =>
                                                                    const ScreenPremium())),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: const Color(
                                                                      0xfffaac18),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          12),
                                                              child: Center(
                                                                  child: Text(
                                                                'Go Premium',
                                                                style:
                                                                    headingStyle,
                                                              )),
                                                            ),
                                                            Lottie.asset(
                                                              'assets/lottie/go_premium.json',
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                        // ListTile(
                        //   contentPadding:
                        //       const EdgeInsets.symmetric(horizontal: 5),
                        //   title: const Text('Saved Templete'),
                        //   leading: !isDark
                        //       ? SvgPicture.asset(
                        //           'assets/icons/black_heart.svg',
                        //           height: 25,
                        //         )
                        //       : SvgPicture.asset(
                        //           'assets/icons/white_heart.svg',
                        //           height: 25,
                        //         ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        //   onTap: () => Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               const ScreenSavedTemplete())),
                        // ),
                        ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ScreenEditDetails())),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          title: const Text('Edit Details'),
                          leading: const Icon(Icons.edit),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          title: const Text('Settings'),
                          leading: isDark
                              ? SvgPicture.asset(
                                  'assets/icons/white_settings.svg')
                              : SvgPicture.asset(
                                  'assets/icons/black_settings.svg'),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const ScreenSettings())),
                        ),
                        !isLogged
                            ? const SizedBox()
                            : ListTile(
                                onTap: () => logout(context),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                title: const Text('Logout'),
                                leading: isDark
                                    ? SvgPicture.asset(
                                        'assets/icons/white_exit.svg')
                                    : SvgPicture.asset(
                                        'assets/icons/black_exit.svg'),
                              ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }

  logout(context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Are you sure to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark? Colors.white:Colors.black, fontFamily: 'Sora'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Sharedstore.setLoggedin(false);
                  Provider.of<Logged>(context, listen: false)
                      .setInitialized(false);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red, fontFamily: 'Sora'),
                ),
              ),
            ],
          );
        });
  }
}
