import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/shared_preference.dart';

class ScreenRegistration extends StatefulWidget {
  const ScreenRegistration({super.key});

  @override
  State<ScreenRegistration> createState() => _ScreenRegistrationState();
}

class _ScreenRegistrationState extends State<ScreenRegistration> {
  TextEditingController phoneController = TextEditingController();
  bool areFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      areFieldsFilled = phoneController.text.length == 10;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = isDark ? darkPrimaryColor : lightPrimaryColor;
    Color borderColor = isDark ? white : black;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 20),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(0.1),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/image/posters.png'),
                              fit: BoxFit.cover,
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height / 2.3,
                        ),
                        const FadeEndListView(),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 40,
                        ),
                        const Text(
                          "Welcome to Posterify",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSerif',
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 40,
                        ),
                        Text(
                          'Enter your phone number to create an account and start creating stunning posters effortlessly.',
                          textAlign: TextAlign.center,
                          style: isDark ? lightTextStyle : darkTextStyle,
                        ),
                        // SizedBox(height: MediaQuery.of(context).size.width/20,),
                        // TextFormField(
                        //   controller: nameController,
                        //   cursorColor: black,
                        //   keyboardType: TextInputType.name,
                        //   textCapitalization: TextCapitalization.words,
                        //   decoration: InputDecoration(
                        //     prefixIcon: Align(
                        //       widthFactor: 1.0,
                        //       child: !isDark
                        //           ? SvgPicture.asset(
                        //               'assets/icons/black_profile.svg',
                        //               height: 20,
                        //             )
                        //           : SvgPicture.asset(
                        //               'assets/icons/white_profile.svg',
                        //               height: 20,
                        //             ),
                        //     ),
                        //     hintText: 'Name',
                        //     border: const OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(20)),
                        //       borderSide: BorderSide(width: 1.5),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: const BorderRadius.all(Radius.circular(20)),
                        //       borderSide: BorderSide(width: 1.5, color: borderColor),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 40,
                        ),
                        TextFormField(
                          controller: phoneController,
                          cursorColor: black,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
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
                            hintText: 'Phone',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(width: 1.5, color: borderColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (phoneController.text.length == 10) {
                              Sharedstore.setphone(phoneController.text);
                              WebService().checkUser(context);
                            }

                            null;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: phoneController.text.length == 10
                                  ? primaryColor
                                  : primaryColor.withOpacity(0.5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Send OTP',
                                style: TextStyle(
                                  color: phoneController.text.length == 10
                                      ? Colors.white
                                      : Colors.white54,
                                fontWeight: FontWeight.w700,
                                  fontFamily: 'SF',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

class FadeEndListView extends StatelessWidget {
  const FadeEndListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 70,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 1.0],
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
      ),
    );
  }
}
