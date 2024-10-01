// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/view%20model/common_view_model.dart';

import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ignore: must_be_immutable
class ScreenRazorpay extends StatefulWidget {
  int amt;
  int id;
  int phone;
  ScreenRazorpay({super.key, required this.amt, required this.id,required this.phone});

  @override
  State<ScreenRazorpay> createState() => _ScreenRazorpayState();
}

class _ScreenRazorpayState extends State<ScreenRazorpay> {
  Razorpay? razorpay;


  @override
  void initState() {
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    payment(widget.amt, widget.phone);
    super.initState();
  }


  @override
  void dispose() {
    razorpay!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(),);
  }

  void payment(int amt, int phone) {
    var options = {
      'key': 'rzp_test_4Is1pcMUCfyfHN',
      'amount': amt*100,
      'name': 'Posterify',
      'description': 'Good poster hace you liked it or not',
      'prefill': {'contact': phone}
    };
    try {
      razorpay!.open(options);
    } catch (e) {
      log('error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    log('Payment Success: $response');
    await WebService().premiumRecharge(widget.id,widget.amt,'tfdg245445');
    await WebService().updatePremium(2);
        CommonViewModel? vm =
        Provider.of<CommonViewModel>(context, listen: false);
       await vm.fetchUser();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('Payment Failed: $response');
        Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('Payment Error: $response');
        Navigator.pop(context);
  }
}
