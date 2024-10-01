
import 'package:flutter/material.dart';

import 'package:posterify/constants/constants.dart';
import 'package:posterify/constants/shimmer.dart';
import 'package:posterify/provider/logged.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/view%20model/common_view_model.dart';
import 'package:posterify/view/Nav_pages/projects/preview.dart';
import 'package:posterify/view/authentication/otp.dart';

import 'package:provider/provider.dart';

class ScreenProjects extends StatefulWidget {
  const ScreenProjects({super.key});

  @override
  State<ScreenProjects> createState() => _ScreenProjectsState();
}

class _ScreenProjectsState extends State<ScreenProjects> {
  @override
  Widget build(BuildContext context) {
    CommonViewModel vm =
        Provider.of<CommonViewModel>(context, listen: false);
    bool isLogged = Provider.of<Logged>(context).initialized;
    Color primaryColor = Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryColor
        : lightPrimaryColor;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Projects',
              style: projectStyle,
            ),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body:
              Consumer<CommonViewModel>(builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: !isLogged
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "You're not logged in. Please register to access and view your saved poster edits.",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: size20(context),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const ScreenOTP(),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
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
                        ],
                      ),
                    )
                  : vm.projectList.isEmpty
                      ? const Center(
                          child: Text(
                            "No projects found. Let's kickstart your creativity by creating a new project now!",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size20(context),
                              ),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 0.8,
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                children: List.generate(vm.projectList.length,
                                    (index) {
                                  final data = vm.projectList[index];
                                  return GestureDetector(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx)=> ScreenPreview(image: data.image))),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          WebService().projectUrl + data.image,
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
                                        )),
                                  );
                                }),
                              ),
                              SizedBox(
                                height: size20(context),
                              ),
                            ],
                          ),
                        ),
            );
          })),
    );
  }


}
