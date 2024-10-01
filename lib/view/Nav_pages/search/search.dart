import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/view%20model/common_view_model.dart';
import 'package:posterify/view/Nav_pages/search/category.dart';
import 'package:provider/provider.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  List filteredItems = [];
  bool notFound = false;

  @override
  Widget build(BuildContext context) {
    CommonViewModel vm =
        Provider.of<CommonViewModel>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void search(String query) {
      setState(() {
        filteredItems = vm.categoryList
            .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        if (filteredItems.isEmpty) {
          notFound = true;
        } else {
          notFound = false;
        }
      });
      log('filtered List ==> $filteredItems');
    }

    return SafeArea(
      child: Scaffold(
        body: Consumer<CommonViewModel>(builder: (context, value, child) {
          return value.categoryLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                              onChanged: (value) {
                                search(value);
                              },
                              cursorColor: black,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: black)),
                                  isDense: true,
                                  hintText: 'Search',
                                  prefixIcon: Align(
                                      widthFactor: 1.0,
                                      child: isDark
                                          ? SvgPicture.asset(
                                              'assets/icons/white_search.svg',
                                              height: 25,
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/black_search.svg',
                                              height: 25,
                                            )),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  )))),
                        )),
                    Expanded(
                      child: filteredItems.isEmpty && notFound
                          ? const Center(
                              child: Text('No Data Found'),
                            )
                          : ListView.builder(
                              itemCount: filteredItems.isEmpty
                                  ? vm.categoryList.length
                                  : filteredItems.length,
                              itemBuilder: (context, index) {
                                final data = filteredItems.isEmpty
                                    ? vm.categoryList[index]
                                    : filteredItems[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => ScreenCategory(
                                                    title: data.name,
                                                    catid: data.id,
                                                  ))),
                                      title: Text(
                                        data.name,
                                        style: primaryTextStyle,
                                      ),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                    ),
                                    filteredItems.isEmpty
                                        ? index == vm.categoryList.length - 1
                                            ? Container()
                                            : const Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                height: 5,
                                              )
                                        : index == filteredItems.length - 1
                                            ? Container()
                                            : const Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                height: 5,
                                              )
                                  ],
                                );
                              }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
