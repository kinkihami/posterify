// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/provider/logged.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/shared_preference.dart';

import 'package:posterify/view%20model/common_view_model.dart';

import 'package:posterify/view/Nav_pages/home/home.dart';
import 'package:posterify/view/Nav_pages/profile/profile.dart';
import 'package:posterify/view/Nav_pages/projects/projects.dart';
import 'package:posterify/view/Nav_pages/search/search.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Bottomnavigationbar extends StatefulWidget {
  const Bottomnavigationbar({super.key});

  @override
  State<Bottomnavigationbar> createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  int pageno = 0;
  
    CommonViewModel? vm;

  _loadPage() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay
    bool? isLogged = await Sharedstore.getLoggedin();

    if (isLogged != null) {
      Provider.of<Logged>(context, listen: false).setInitialized(isLogged);
      log('======================= ${Provider.of<Logged>(context, listen: false).initialized}');
    }
    return isLogged!;
  }

  @override
  void initState() {
    if (!Provider.of<Logged>(context, listen: false).initialized) {
      log('haiiiii');
      _loadPage();
    }
    vm=Provider.of<CommonViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vm!.fetchUser().then((_) async {
        if (vm!.userList != null) {
          print('user is found');
          
          if(vm!.userList!.premium !=1 ){
            await vm!.fetchExpiry().then((_) async {
            Provider.of<Expiry>(context, listen: false).setExpiry(false);
            if (vm!.expiry!.date <= 10) {
              log('asdhasdsadsad am here you will not find me');
              Provider.of<Expiry>(context, listen: false).setExpiry(true);
              Provider.of<Expiry>(context, listen: false)
                  .setDay(vm!.expiry!.date);
            } else if (vm!.expiry!.date == 0) {
              log('fghvjbknasddddddddasdsdadsaddasd am here');
              await WebService().updatePremium(1);
              Provider.of<Expiry>(context, listen: false).setExpiry(true);
              Provider.of<Expiry>(context, listen: false).setDay(0);
            } else {
              debugPrint("user not logged in=================================");
            }
          });
          }else{
            null;
          }

          await vm!.fetchCategory().then((_) async {
            if (vm!.categoryList.isNotEmpty) {
              for (final category in vm!.categoryList) {
                vm!.fetchTempletes(category.id);
              }
            }
          });
          vm!.fetchProject();
          vm!.fetchDetails();
        } else {
          print('user is not found');
          await vm!.fetchCategory().then((_) async {
            if (vm!.categoryList.isNotEmpty) {
              for (final category in vm!.categoryList) {
                vm!.fetchTempletes(category.id);
              }
            }
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? ThemeData.dark().scaffoldBackgroundColor
        : Theme.of(context).scaffoldBackgroundColor;
    Color primaryColor = Theme.of(context).brightness == Brightness.dark
        ? lightPrimaryColor
        : darkPrimaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 0,
          ),
          SalomonBottomBar(
            backgroundColor: backgroundColor,
            currentIndex: pageno,
            onTap: (i) => setState(() => pageno = i),
            items: [
              /// Home
              SalomonBottomBarItem(
                activeIcon: items[0],
                icon: items[4],
                title: Text("Home"),
                selectedColor: primaryColor,
              ),

              /// Likes
              SalomonBottomBarItem(
                activeIcon: items[1],
                icon: items[5],
                title: Text("Search"),
                selectedColor: primaryColor,
              ),

              /// Search
              SalomonBottomBarItem(
                activeIcon: items[2],
                icon: items[6],
                title: Text("Projects"),
                selectedColor: primaryColor,
              ),

              /// Profile
              SalomonBottomBarItem(
                activeIcon: items[3],
                icon: items[7],
                title: Text("Profile"),
                selectedColor: primaryColor,
              ),
            ],
          ),
        ],
      ),
      body: _pages.elementAt(pageno),
    );
  }

  static const List<Widget> _pages = <Widget>[
    ScreenHome(),
    ScreenSearch(),
    ScreenProjects(),
    ScreenProfile(),
  ];

  var items = [
    SvgPicture.asset('assets/icons/blue_home.svg'),
    SvgPicture.asset('assets/icons/blue_search.svg'),
    SvgPicture.asset('assets/icons/blue_projects.svg'),
    SvgPicture.asset('assets/icons/blue_profile.svg'),
    SvgPicture.asset('assets/icons/black_home.svg'),
    SvgPicture.asset('assets/icons/black_search.svg'),
    SvgPicture.asset('assets/icons/black_projects.svg'),
    SvgPicture.asset('assets/icons/black_profile.svg'),
  ];
}
