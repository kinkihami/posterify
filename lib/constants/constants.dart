import 'package:flutter/material.dart';

Color lightPrimaryColor = const Color(0xff2f27ce);
Color darkPrimaryColor = 
const Color(0xff3a31d8);


Color black = const Color(0xff333333);
Color white = Colors.grey.shade50;



TextStyle mainHeadingTextStyle = const TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  fontFamily: 'DMSerif'
);

TextStyle headingStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: Colors.white,
  fontFamily: 'SF'
);

TextStyle headingBlackStyle = const  TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  fontFamily: 'SF'
);

TextStyle projectStyle = const  TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  fontFamily: 'SF'
);

TextStyle primaryTextStyle= const TextStyle(
  fontSize: 16,
  // color: black,
  fontFamily: 'SF'
);

TextStyle blackBoldTextStyle= const TextStyle(
  fontSize: 18,
  // color: black,
  fontWeight: FontWeight.bold,
  fontFamily: 'SF',
);

TextStyle lightTextStyle= const TextStyle(
  fontSize: 13,
  color: Colors.white54,
  fontFamily: 'SF'
);

TextStyle darkTextStyle= const TextStyle(
  fontSize: 13,
  color: Colors.black45,
  fontFamily: 'SF'
);

double size2(BuildContext context){
return MediaQuery.of(context).size.width/2;
}
double size3(BuildContext context){
return MediaQuery.of(context).size.width/3;
}
double size4(BuildContext context){
return MediaQuery.of(context).size.width/4;
}
double size20(BuildContext context){
return MediaQuery.of(context).size.width/20;
}
double size40(BuildContext context){
return MediaQuery.of(context).size.width/40;
}

