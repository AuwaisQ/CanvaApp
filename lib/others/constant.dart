import 'package:canvas_365/beans/GreetingsCategoryBean.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//const primaryColor = Color(0xff8c3bb0);//Purple Colour
const primaryColor = Color(0xffd61313);//Purple Colour
//const backgroundColor = Color(0xfff4f7fc);//White Colour
const fontColor = Color(0xfff4f7fc);//White Colour
const backgroundColor = Color(0xff000000);//White Colour
const errorColor = Color(0xffff2e2e);//White Colour
const successColor = Color(0xff19a519);//White Colour
const mainHeading = TextStyle(fontSize: 20,color: primaryColor,fontFamily: 'Poppins');
const mainHeading2 = TextStyle(fontSize: 20,fontFamily: 'Poppins',color: Colors.white);
const headTitle = TextStyle(fontSize: 15,fontWeight: FontWeight.bold,letterSpacing: 1,fontFamily: 'Poppins',color: fontColor);
const tileText = TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'Poppins');
List<dynamic> stList=[
  GoogleFonts.oswald(fontStyle: FontStyle.italic,color: Colors.white)
  ,GoogleFonts.poppins(fontStyle: FontStyle.italic,color: Colors.white)
  ,GoogleFonts.lato(fontStyle: FontStyle.italic,color: Colors.white)
,GoogleFonts.varela(fontStyle: FontStyle.italic,color: Colors.white)
,GoogleFonts.aBeeZee(fontStyle: FontStyle.italic,color: Colors.white)
,GoogleFonts.lato(fontStyle: FontStyle.italic,color: Colors.white)
,GoogleFonts.amaranth(fontStyle:FontStyle.normal,color:Colors.white)
  ,GoogleFonts.artifika(fontStyle:FontStyle.normal,color:Colors.white)
  ,GoogleFonts.bentham(fontStyle:FontStyle.normal,color:Colors.white)
  ,GoogleFonts.bangers(fontStyle:FontStyle.normal,color:Colors.white)
  ,GoogleFonts.boogaloo(fontStyle:FontStyle.normal,color:Colors.white)
  ,GoogleFonts.condiment(fontStyle:FontStyle.normal,color:Colors.white)];

List<GreetingsCategoryBean> congratulations=[
  GreetingsCategoryBean("1","congratulations1.png","customFrame1"),
  GreetingsCategoryBean("2","congratulations2.png","customFrame2"),
  GreetingsCategoryBean("3","congratulations3.png","customFrame3")];
List<GreetingsCategoryBean> getwellsoon=[
  GreetingsCategoryBean("4","getwellsoon1.png","customFrame4"),
  GreetingsCategoryBean("5","getwellsoon2.png","customFrame5"),
];
List<GreetingsCategoryBean> happyanniversary=[
  GreetingsCategoryBean("6","happyanniversary1.png","customFrame6"),
  GreetingsCategoryBean("7","happyanniversary2.png","customFrame7"),
];
List<GreetingsCategoryBean> happybirthday=[
  GreetingsCategoryBean("8","happybirthday1.png","customFrame8"),
  GreetingsCategoryBean("9","happybirthday2.png","customFrame9")
];

List<String> itsboy=["itsboy1.png","itsboy2.png"];
List<String> itsgirl=["itsgirl1.png"];
List<String> sale=["sale1.png","sale2.png"];
List<String> shadhanjali=["shadhanjali1.png","shadhanjali2.png"];
List<String> thankyou=["thankyou1.png","thankyou2.png"];
List<String> wedding=["wedding1.png","wedding2.png"];

List<dynamic> stListNClr=[
  GoogleFonts.oswald(fontStyle: FontStyle.italic,fontSize: 10)
  ,GoogleFonts.poppins(fontStyle: FontStyle.italic,fontSize: 10)
  ,GoogleFonts.lato(fontStyle: FontStyle.italic,fontSize: 10)
  ,GoogleFonts.varela(fontStyle: FontStyle.italic,fontSize: 10)
  ,GoogleFonts.aBeeZee(fontStyle: FontStyle.italic,fontSize: 10)
  ,GoogleFonts.lato(fontStyle: FontStyle.italic,fontSize: 10)
  ,GoogleFonts.amaranth(fontStyle:FontStyle.normal,fontSize: 10)
  ,GoogleFonts.artifika(fontStyle:FontStyle.normal,fontSize: 10)
  ,GoogleFonts.bentham(fontStyle:FontStyle.normal,fontSize: 10)
  ,GoogleFonts.bangers(fontStyle:FontStyle.normal,fontSize: 10)
  ,GoogleFonts.boogaloo(fontStyle:FontStyle.normal,fontSize: 10)
  ,GoogleFonts.condiment(fontStyle:FontStyle.normal,fontSize: 10)
];

const String webUrl="https://canvaz.in/";
//const String webUrl="https://code.developerzone.in/";
const String appName="Canvaz";
//const String webUrl="https://manalsoftech.in/canva_365/";
const String imageUrl=webUrl+"/public/img/";
// const String logoUrl="https://www.canva365.co.in/logo";
const String logoUrl="http://canvaz.in";
const String businessCardUrl="https://www.canvaz.co.in";
//const String imageUrl=webUrl+"img/bprofile/";
const String imgUrl=webUrl+"/public/img/";
const String vdoUrl=webUrl+"/public/videos/";
const String imgCreateLogo=webUrl+"/public/img/create_logo.jpg";
const String imgCreateCard=webUrl+"/public/img/create_card.jpg";
const String imgWaterMark=webUrl+"/public/img/logo.png";
const String imgAddLogo=webUrl+"/public/img/logo_here.png";
///OTP Boxes
final boxDecoration = BoxDecoration
  (
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(50)),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);

Gradient grdLogin=LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.black12,Colors.redAccent]);

final inputDecoration = InputDecoration
  (
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  counterText: "",
  contentPadding: EdgeInsets.symmetric(vertical: 15),
);

  //   final textInputDecoration=new InputDecoration(
  //   border: InputBorder.none,
  //   focusedBorder: InputBorder.none,
  //   enabledBorder: InputBorder.none,
  //   errorBorder: InputBorder.none,
  //   disabledBorder: InputBorder.none,
  //   prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.grey,size: 20,),
  //   contentPadding: EdgeInsets.only(bottom: 15, top: 15, right: 15),
  //   hintText: "Business Name",
  //   hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 13)
  // );

List languageList=[
  {"id":"0","language":"Hindi","status":false},
  {"id":"1","language":"English","status":true},
  {"id":"2","language":"Marathi","status":true},
  {"id":"3","language":"Panjabi","status":true},
  {"id":"4","language":"Marwadi","status":true},
  {"id":"5","language":"Malayalam","status":false},
  {"id":"6","language":"Udiya","status":true},
  ];
const font = 'Poppins';
// List<NameIdBean> languageListOne=[
//   NameIdBean("0", "English","",true),
//   NameIdBean("1","Hindi","",false),
//   NameIdBean("2","Marathi","",false),
//   NameIdBean("3","Panjabi","",false),
//   NameIdBean("4","Marwadi","",false),
//   NameIdBean("5","Malayalam","",false),
//   NameIdBean("6","Udiya","",false),
// ];

// List<NameIdBean> categoryList=[
//   NameIdBean("0","Shrawan","https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib",true),
//   NameIdBean("1","Youth Day","https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib",false),
//   NameIdBean("2","Elephant Day","https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib",false),
//   NameIdBean("3","Ethics","https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib",false),
//   NameIdBean("4","Trending","https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib",false),
//   NameIdBean("5","Olympic","https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib",false),
//   NameIdBean("6","Good Thoughts","https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib",false),
// ];