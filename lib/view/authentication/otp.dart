// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_email_auth/phone_email_auth.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/shared_preference.dart';


class ScreenOTP extends StatefulWidget {
  const ScreenOTP({super.key});

  @override
  State<ScreenOTP> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<ScreenOTP> {
  final GlobalKey webViewKey = GlobalKey();

  /// InAppWebView Controller
  InAppWebViewController? webViewController;
  InAppWebViewSettings? initialSettings;

  /// Initial Authentication URL
  late String authenticationUrl;
  PhoneEmailUserModel? phoneEmailUserModel;
  final phoneEmail = PhoneEmail();

  /// Unique device token
  String? deviceId;
  // client id
  String clientid = "";
  bool loading = false;
  bool loading22 = true;
  bool loading33 = false;
  @override
  void initState() {
    super.initState();

    inappvwebbb();
  }

  Widget inappvwebbb() {
    return InAppWebView(
      key: webViewKey,
      initialSettings: initialSettings = InAppWebViewSettings(
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        cacheEnabled: true,
        allowsInlineMediaPlayback: true,
      ),
      onWebViewCreated: (controller) async {
        log("aaaaa");
        webViewController = controller;
        setState(() {
          loading22 = false;
        });
        inAppWebViewConfiguration(controller);
      },
      onLoadStart: (controller, url) {
        log("startedddddd");
        setState(() {
          loading22 = true;
        });
        webViewController!.addJavaScriptHandler(
          handlerName: AppConstant.sendTokenToApp,
          callback: (arguments) {
            log("token === " + arguments[0]["access_token"].toString());
            PhoneEmail.getUserInfo(
              accessToken: arguments[0]["access_token"].toString(),
              clientId: phoneEmail.clientId,
              onSuccess: (userData) {
                setState(() {
                  log("UserData :: $userData");

                  var phone= userData.phoneNumber;
                  log('phone number======== $phone');
                  Sharedstore.setphone(phone!);

                    log("Login success");
                    WebService().checkUser(context);
                });
              },
            );
          },
        );
      },
      onReceivedError: (controller, request, error) {
        print("Error ============>>>>>${error.description}");
        Navigator.pop(context);
      },
      onLoadStop: (controller, url) async {
        log("loadededdd");
        setState(() {
          loading22 = false;

          /// _statusMessage = "Page loaded successfully";
        });
      },
    );
  }

  Future<void> inAppWebViewConfiguration(
      InAppWebViewController controller) async {
    final _phoneEmail = PhoneEmail();

    const String redirectUrl = "your_redirect_url_here";

    /// Build authentication url with registered details
authenticationUrl = "${AppConstant.authUrl}?${AppConstant.clientId}=${_phoneEmail.clientId}&${AppConstant.redirectUrl}=$redirectUrl&${AppConstant.authType}=5";

    debugPrint('Authentication URL: $authenticationUrl');

    /// Load authentication url in WebView
    webViewController!.loadUrl(
      urlRequest: URLRequest(url: WebUri(authenticationUrl)),
    );
  }

  //   InAppWebViewController? webViewController;

  // bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          loading33
              ? CircularProgressIndicator()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "Welcome Back",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Sign In your acount",
                              style: TextStyle(color: black),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                            color: Colors.white, child: inappvwebbb()),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
