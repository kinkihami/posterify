import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/constants/shimmer.dart';
import 'package:posterify/shared_preference.dart';
import 'package:posterify/view%20model/common_view_model.dart';
import 'package:posterify/view/Nav_pages/profile/razorpay.dart';
import 'package:provider/provider.dart';

class ScreenPremium extends StatefulWidget {
  const ScreenPremium({super.key});

  @override
  State<ScreenPremium> createState() => _ScreenPremiumState();
}

class _ScreenPremiumState extends State<ScreenPremium> {
  CommonViewModel? vm;
  int selectedValue = 0;
  int? phone;

  @override
  void initState() {
    vm = Provider.of<CommonViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm!.fetchPremium();
    });
    loadPhone();
    super.initState();
  }

  loadPhone() async {
  final String? phoneStr = await Sharedstore.getphone();
  if (phoneStr != null && phoneStr.isNotEmpty) {
    try {
      phone = int.parse(phoneStr);
    } catch (e) {
      log("Invalid phone number format: $e");
      phone = null; // Or handle as needed
    }
  } else {
    log("Phone number not found");
    phone = null; // Or handle as needed
  }
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = isDark ? darkPrimaryColor : lightPrimaryColor;

    Color borderColor =
        isDark ? white.withOpacity(0.5) : black.withOpacity(0.5);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body:
              Consumer<CommonViewModel>(builder: (context, value, child) {
            return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select your plan',
                            style: projectStyle,
                          ),
                          Text(
                            'Upgrade to Premium plan and enjoy exclusive features and take your creative to the next level',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: size20(context),
                          ),
                          SizedBox(
                            height: size20(context),
                          ),
                          ShimmerLoading(
                            isLoading: value.premiumLoading,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: vm!.premiumList.length,
                                itemBuilder: (context, index) {
                                  final data = vm!.premiumList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = index;
                                      });
                                    },
                                    child: Card(
                                      surfaceTintColor: selectedValue == index
                                          ? primaryColor.withOpacity(0.1)
                                          : Colors.transparent,
                                      elevation: 5,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: selectedValue == index
                                            ? BorderSide(
                                                color: primaryColor, width: 2)
                                            : BorderSide(color: borderColor),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 15, right: 15),
                                        child: SizedBox(
                                          child: Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Radio<int>(
                                                  activeColor: primaryColor,
                                                  value: index,
                                                  groupValue: selectedValue,
                                                  onChanged: (int? v) {
                                                    setState(() {
                                                      selectedValue = v!;
                                                    });
                                                  },
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data.duration,
                                                        style: const TextStyle(
                                                            fontFamily: 'SF',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700),
                                                      ),
                                                      // SizedBox(height: size40(context)),
                                                      Text(
                                                        '\u{20B9} ${data.price}/month',
                                                        style: const TextStyle(
                                                            fontFamily: 'SF',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: size20(context),
                          ),
                          SizedBox(
                            height: size20(context),
                          ),
                          GestureDetector(
                            onTap: () {
                              log('selected price======> ${ int.parse(vm!.premiumList[selectedValue].price)}');
                              log('selected price id======> ${vm!.premiumList[selectedValue].id}');
                              final id=vm!.premiumList[selectedValue].id;
                              int amt(){
                                if(id==1){
                                  return int.parse(vm!.premiumList[selectedValue].price)*12;
                                }else if(id==2){
                                  return int.parse(vm!.premiumList[selectedValue].price)*6;
                                }else{
                                  return int.parse(vm!.premiumList[selectedValue].price);
                                }
                              }
                              log('phone ======> $phone');
                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ScreenRazorpay(amt: amt(), id: vm!.premiumList[selectedValue].id,phone: phone!,)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: primaryColor),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Center(
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
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
                  );
          })),
    );
  }
}
