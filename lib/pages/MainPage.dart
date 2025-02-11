import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/BrandFeed.dart';
import 'package:canvas_365/pages/BusinessFeeds.dart';
import 'package:canvas_365/pages/EditBusinessPage.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
//import 'package:canvas_365/pages/TestingBrandFeed.dart';
import 'package:canvas_365/pages/addLogoPage.dart';
import 'package:canvas_365/pages/searchCategoryPage.dart';
import 'package:canvas_365/pages/wishList.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../beans/TestBean.dart';
import '../main.dart';
import 'Login.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var url = Uri.parse(webUrl + "homeapi");
  var data;
  List<dynamic> dtaS = [];
  List<dynamic> dtaC = [];
  List<dynamic> dtaStartUp = [];
  List<dynamic> dtaSC = [];
  List<dynamic> dtaSPOS = [];
  List<dynamic> dtaBposter = [];
  List<dynamic> dtaGretrings = [];

  List<NameIdBean> dtaSlider = [];
  List<NameIdBean> dtaCategory = [];

  List<NameIdBean> dtaSelectedPosters = [];
  List<NameIdBean> dtaFilteredPosters = [];
  List<NameIdBean> dtaSelectedCategory = [];
  List<NameIdBean> dtaSelectedCategoryBposter = [];
  List<TestNameIdBean> dtaSelectedGreetingposter = [];
  String msg = "";
  bool isApiCallingProcess = false;
  //List<NameIdBean> languageListOne=[];
  bool profileStatus = false;
  String? userId, logo, businessName, businessId, bus_category;
  bool? isFirstTime=true;
  String? todayDownloads;
  String? todayDate;
  var issubscribed;
  String deviceId="";
  getUserToken() async
  {
    final prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString("device_id")!;
    getProfileStatus(true);
  }

  @override
  void initState() {
    getUserToken();
    //getProfileStatus(true);
    //getHomeData();
    super.initState();
  }

  void showNotification() {
    // setState(() {
    //   _counter++;
    // });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  void getProfileStatus(bool isSet) async {
    //WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    profileStatus = prefs.getBool("isProfileUpdate")!;
    userId = prefs.getString("user_id");
    businessId = prefs.getString("business_category");
    bus_category = prefs.getString("bus_category");
    businessName = prefs.getString("businessName");
    logo = prefs.getString("logo");
    isFirstTime = (prefs.getBool("isFirstTime"))==null?false:prefs.getBool("isFirstTime");
    print("Lang ids is here");
    print(prefs.getString("language_array"));
    if (isSet) {
      getHomeData();
    }
    setState(() {});
  }

  // setIsSubscribed(bool isSub) async
  // {
  //   final prefs = await SharedPreferences.getInstance();
  //   if(isSub)
  //     {
  //
  //     }else
  //     {
  //
  //     }
  //   prefs.setBool("isSubscribed", isSub);
  //   prefs.setBool("isFirstTime", false);
  //   print("it is inSub:$issubscribed");
  //   setState(() {});
  // }

  void getHomeData() async {
    isApiCallingProcess = true;
    print(url);
    print('userId: $userId,bcategoryId:$businessId,deviceIdId:$deviceId');
    // var response = await http.get(url,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    // );
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId.toString(),
        'bcategoryId': businessId.toString(),
        'deviceId':deviceId
        //'bcategoryId':"40"
      }),
    );
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"language":"\u0a2a\u0a70\u0a1c\u0a3e\u0a2c\u0a40","defaultlang":"false"},{"id":3,"language":"\u0ba4\u0bae\u0bbf\u0bb4\u0bcd","defaultlang":"false"},{"id":4,"language":"\u0d2e\u0d32\u0d2f\u0d3e\u0d33\u0d02","defaultlang":"false"},{"id":5,"language":"Italia","defaultlang":"false"},{"id":6,"language":"\u0939\u093f\u0902\u0926\u0940","defaultlang":"false"},{"id":7,"language":"English","defaultlang":"true"}],"status":true,"msg":"success"}');
    //print(data);
    var status = data['status'];
    var msg = data['msg'];
    issubscribed = data['issubscribe'];
    bool matched = data['matched'];
    //setIsSubscribed(issubscribed);
    print("matched"+matched.toString());
    if (status)
    {
      if(matched)
        {
          Map<String, dynamic> map = json.decode(response.body);
          final prefs = await SharedPreferences.getInstance();
            if(issubscribed)
              {
                var subDetails=map['subdetails'];
                prefs.setString("planName",subDetails[0]["title"]==null?"planName":subDetails[0]["title"]);
                prefs.setString("planExpiry", subDetails[0]["endson"]);
                prefs.setString("planAmount", subDetails[0]["amount"].toString());
              }else
              {

              }
          prefs.setBool("isSubscribed", issubscribed);

          dtaS = map["slider"];
          dtaC = map["category"];
          dtaStartUp = map["startupposter"];
          dtaSC = map["selectedcategory"];
          dtaSPOS = map["posters"];
          dtaBposter = map["bposter"];
          print("Business Poster:" + dtaBposter.toString());
          //dtaGretrings=map["subposter"];
          dtaGretrings = map["upcoming"];
          print(dtaGretrings.toString());
          //dtaSelectedCategory=map["slider"];
          print("Startup Poster:" + dtaStartUp.length.toString());
          if (dtaStartUp.length > 0) {
            NameIdBean bosterBin = new NameIdBean(dtaStartUp[0]["id"].toString(),
                dtaStartUp[0]["title"], dtaStartUp[0]["imgpath"], true);
            if (Platform.isAndroid)
            {
              showStartupDialog(bosterBin.image);
            }
            //showStartup(context,bosterBin.image);
          }
          for (int i = 0; i < dtaS.length; i++) {
            dtaSlider.add(new NameIdBean(
                dtaS[i]["category"].toString(),
                dtaS[i]["categoryid"].toString(),
                dtaS[i]["sliderimg"].toString(),
                true));
          }

          for (int i = 0; i < dtaBposter.length; i++) {
            dtaSelectedCategoryBposter.add(new NameIdBean(
                dtaBposter[i]["id"].toString(),
                dtaBposter[i]["id"].toString(),
                dtaBposter[i]["image"].toString(),
                true));
            print(dtaBposter[i]["id"].toString());
            print(dtaBposter[i]["image"].toString());
          }

          print(dtaC.length.toString());
          for (int i = 0; i < dtaC.length; i++) {
            dtaCategory.add(new NameIdBean(dtaC[i]["id"].toString(),
                dtaC[i]["category"].toString(), "", true));
          }

          print(dtaGretrings.length.toString());
          for (int i = 0; i < dtaGretrings.length; i++) {
            print("Type is here:"+dtaGretrings[i]["category"].toString());
            dtaSelectedGreetingposter.add(new TestNameIdBean(
                dtaGretrings[i]["category_id"].toString(),
                dtaGretrings[i]["ondate"].toString(),
                dtaGretrings[i]["category"].toString(),
                dtaGretrings[i]["image"].toString(),
                true));
          }
          print("dtascc:" + dtaSPOS.length.toString());
          for (int i = 0; i < dtaSPOS.length; i++) {
            //print("it is ist:"+dtaSPOS[i]["id"].toString());
            bool stts = false;
            dtaSPOS[i]["paid"] == "Free" ? stts = true : stts = false;
            dtaSelectedPosters.add(new NameIdBean(
                dtaSPOS[i]["id"].toString(),
                dtaSPOS[i]["categoryid"].toString(),
                dtaSPOS[i]["imgpath"].toString(),
                stts));
          }
          setState(() {
            //getProfileStatus();
          });
        }else
          {
            exitApp();
            //showConfirmDialog(context);
          }
    } else {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {});
    }
    isApiCallingProcess = false;
    setState(() {});
  }

  exitApp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    //prefs.setBool("isLogin",false);
    //SystemNavigator.pop();
    //Navigator.pushReplacement(cont, MaterialPageRoute(builder: (_)=>Login()));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Login()));
    //Navigator.pop(context);
    //SystemNavigator.pop();
    //exit(0);
  }

  showConfirmDialog(BuildContext contex) {
    //Toast.show("List Data $id,$index", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    // Widget cancelButton = new ElevatedButton(
    //   style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(successColor),),
    //   child: Text("Cancel",style: TextStyle(fontFamily: "Varela",color: Colors.white),),
    //   onPressed:  ()
    //   {
    //     Navigator.pop(contex);
    //   },
    // );
    Widget continueButton = new ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
      child: Text("Close App",style: TextStyle(fontFamily: "Varela",color: Colors.white)),
      onPressed:  () {
        //exitApp(contex);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Close App",style: TextStyle(fontFamily: "Varela")),
      elevation: 5.0,
      content: Text("Already Login to Other Device",style: TextStyle(fontFamily: "Varela")),
      actions: [
        //cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: true,
      context: contex,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Business',
              style: TextStyle(
                  color: Colors.grey, fontSize: 10, fontFamily: 'Poppins'),
            ),
            businessName != null
                ? Text(
                    businessName!,
                    style: TextStyle(fontSize: 20),
                  )
                : Text(
                    'Add Business Detail',
                    style: TextStyle(fontSize: 17),
                  )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Wishlist()));
                    //Navigator.push(context, MaterialPageRoute(builder: (_)=>PaymentPage(planType: "annual", planAmount: "3000", planId: "25")));
                  },
                ),
                // IconButton(icon: Icon(Icons.notifications_none,size: 27,), onPressed: () {
                //   Navigator.push(context, MaterialPageRoute(builder: (_)=>NewBrandFeed(categoryId: "2",displayImage: "16376605831.jpg",)));
                //   //Navigator.push(context, MaterialPageRoute(builder: (_)=>PaymentPage(planType: "annual", planAmount: "3000", planId: "25")));
                // },),
                // },),
              ],
            ),
          ),
          logo == null || logo == ""
              ? Container(
                  margin: EdgeInsets.only(bottom: 10, right: 10),
                  height: 40.0,
                  width: 40.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      heroTag: "front",
                      onPressed: () {
                        profileStatus
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => addLogoPage()))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditBusinessPage()));
                      },
                      backgroundColor: primaryColor,
                      child: Text(
                        "A",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                )

              // FloatingActionButton(onPressed: ()=>{
              //   profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>addLogoPage())):
              //   Navigator.push(context, MaterialPageRoute(builder: (_)=>EditBusinessPage()))
              // },child: Text("CA"),)

              // IconButton(onPressed: ()=>{
              //   profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>addLogoPage())):
              //   Navigator.push(context, MaterialPageRoute(builder: (_)=>EditBusinessPage()))
              // }, icon: Icon(Icons.account_circle,color: Colors.blueGrey,size: 40,))
              : InkWell(
                  onTap: () => {setNewLogo()},
                  child: Container(
                    // margin:EdgeInsets.only(right: 30),
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(imageUrl + logo!))),
                    margin: EdgeInsets.all(10),
                    // child: ClipRRect(borderRadius: BorderRadius.circular(50),
                    //   child: Image.network(imageUrl+logo!,fit: BoxFit.cover,),
                    // ),
                  ),
                )
          // IconButton(icon: Icon(Icons.account_circle,color: Colors.blueGrey,size: 27,), onPressed: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (_)=>TestingBrandFeed()));
          // },)
          ,
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              ///Search Bar
              Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => searchCategoryPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 160,
                          ),
                          child: Container(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              //Slider
              CarouselSlider(
                  items: dtaSlider.map((sliderImage) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () => profileStatus
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BrandFeed(
                                            categoryId: sliderImage.name,
                                            displayImage: "none",
                                            categoryName: sliderImage.id,
                                          )))
                              : registratinConfirmation(context),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        imgUrl + "slider/" + sliderImage.image
                                        //'https://static.wixstatic.com/media/bb1bd6_0f057001908f4395bf0a3d45deb148ee~mv2.png/v1/fit/w_1024,h_586,al_c,q_80/file.png'
                                        ),
                                    fit: BoxFit.cover)),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                      height: 200,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      viewportFraction: 0.9)),
              //Choice Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 5),
                  child: Row(
                    children: List.generate(
                      dtaCategory.length,
                      (index) =>
                          //getChip(new NameIdBean(languageList[index]['id'],languageList[index]['language'],"aaa",languageList[index]['status']))
                          getChip(dtaCategory[index], index),
                    ),
                  ),
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       onTap: () => Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (_) =>
              //                   WebViewPage(logoUrl))), //EnquiryPage())),
              //       child: Container(
              //         margin: EdgeInsets.only(left: 15),
              //         height: 110,
              //         width: MediaQuery.of(context).size.width / 2.25,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             image: DecorationImage(
              //                 image: NetworkImage(imgCreateLogo),
              //                 fit: BoxFit.cover)),
              //       ),
              //     ),
              //     SizedBox(width: 10),
              //     InkWell(
              //       onTap: () => Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (_) => WebViewPage(businessCardUrl))),
              //       child: Container(
              //         margin: EdgeInsets.only(right: 15),
              //         height: 110,
              //         width: MediaQuery.of(context).size.width / 2.25,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             image: DecorationImage(
              //                 image: NetworkImage(imgCreateCard),
              //                 fit: BoxFit.cover)),
              //       ),
              //     ),
              //   ],
              // ),

              Container(
                  child: dtaSelectedCategoryBposter.length <= 0
                      ? SizedBox(
                          height: 1,
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, //dtaSelectedCategoryBposter[0].name
                              children: [
                                Text("$bus_category (My Business)",
                                    style: headTitle),
                                InkWell(
                                    onTap: () => profileStatus
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => BusinessFeeds(
                                                    categoryId: businessId,
                                                    displayImage:
                                                        dtaSelectedCategoryBposter[
                                                                0]
                                                            .image)))
                                        : registratinConfirmation(context),
                                    child: Text("View All", style: tileText),)
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    dtaSelectedCategoryBposter.length,
                                    (index) => getBCatImage(
                                        dtaSelectedCategoryBposter[index].name,
                                        index,
                                        dtaSelectedCategoryBposter[index].image,
                                        false) //,dtaFilteredPosters[index].status)
                                    ),
                              ),
                            ),
                          ],
                        )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Column(
                  children: List.generate(
                      dtaSC.length,
                      (index) => getSelectedCategoryPoster(
                          dtaSC[index]["categoryid"].toString(),
                          dtaSC[index]["name"])),
                ),
              ),
              Container(
                child: dtaSelectedGreetingposter.length <= 0
                    ? SizedBox(
                        height: 1,
                      )
                    : Column(
                        children: [
                          Container(
                              margin:
                                  EdgeInsets.only(left: 15, top: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Upcoming",
                                    style: headTitle,
                                  )
                                  //   ,InkWell(child: Text("View All",style: tileText),onTap: ()=>{
                                  //   Navigator.push(context, MaterialPageRoute(builder: (_)=>GreetingFeeds(categoryId: "1")))
                                  // },)
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    dtaSelectedGreetingposter.length,
                                    (index) => getGCatImage(
                                        dtaSelectedGreetingposter[index].id,
                                        dtaSelectedGreetingposter[index].name,
                                        dtaSelectedGreetingposter[index].type,
                                        index,
                                        dtaSelectedGreetingposter[index].image,
                                        false) //,dtaFilteredPosters[index].status)
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getChip(NameIdBean nameIdBean, int index) {
    //print(nameIdBean.status);
    var _isSelected = false;
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: ChoiceChip(
        padding: EdgeInsets.symmetric(horizontal: 15),
        elevation: 10,
        label: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(nameIdBean.name)),
        labelStyle: TextStyle(
            color: _isSelected ? Colors.white : Colors.white,
            fontFamily: 'Poppins',
            fontSize: 12.0,
        ),
        selected: _isSelected,
        backgroundColor: Color(0xFF36454f), //_isSelected? Colors.black : Colors.white,//Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.green)
        ),
        onSelected: (isSelected) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BrandFeed(
                        categoryId: nameIdBean.id,
                        displayImage: "none",
                        categoryName: nameIdBean.name,
                      )));
        },
        selectedColor: _isSelected ? primaryColor : primaryColor,
      ),
    );
  }

  Widget getSelectedCategoryPoster(String id, String name) {
    //print(id+"::"+name);
    dtaFilteredPosters = dtaSelectedPosters.where((element) => element.name == id).toList();
    //dtaFilteredPosters=dtaSelectedPosters.where((element) =>element.id.contains(id)).toList();
    // setState((){
    //
    // });
    //print(dtaFilteredPosters.length.toString()+"::"+dtaSelectedPosters.length.toString());
    return Column(children: [
      SizedBox(height: 10),

      ///1St Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: headTitle),
          InkWell(
              onTap: () => profileStatus
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BrandFeed(
                                categoryId: id,
                                displayImage: "none",
                                categoryName: name,
                              )))
                  : registratinConfirmation(context),
              child: Text("View All", style: tileText))
        ],
      ),
      SizedBox(height: 5),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              dtaFilteredPosters.length,
              (index) => getCatImage(
                  dtaFilteredPosters[index].name,
                  index,
                  dtaFilteredPosters[index].image,
                  false,
                  name) //,dtaFilteredPosters[index].status)
              ),
        ),
      )
    ]);
  }

  Widget getCatImage(String catId, index, String name, bool status, String nme) {
    //print("https://manalsoftech.in/canva_365/img/"+name);
    return InkWell(
      onTap: () =>
          //registratinConfirmation(context),
          profileStatus
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BrandFeed(
                            categoryId: catId,
                            displayImage: name,
                            categoryName: nme,
                          )))
              : registratinConfirmation(context),
      //profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>BrandFeed(categoryId: catId,displayImage:name))):registratinConfirmation(context),
      //status?Navigator.push(context, MaterialPageRoute(builder: ()=>BrandFeed(categoryId: catId,))):Navigator.push(context, MaterialPageRoute(builder: ()=>SelectPlan())),
      child: Container(
          //margin: EdgeInsets.only(right: 5,left: 5),
          margin: EdgeInsets.all(5),
          height: 130,
          width: 130,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(imgUrl + name), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)]),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 15,
                  padding: status
                      ? EdgeInsets.only(left: 5, right: 5)
                      : EdgeInsets.only(left: 0, right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: Center(
                    child: status
                        ? Text(
                            "Free",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : Text(
                            "",
                            style: TextStyle(
                                backgroundColor: Colors.red.withOpacity(.8)),
                          ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget getBCatImage(String catId, index, String name, bool status) {
    //print("https://manalsoftech.in/canva_365/img/"+name);
    return InkWell(
      onTap: () =>
          //registratinConfirmation(context),//catId
          profileStatus
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BusinessFeeds(
                          categoryId: businessId, displayImage: name)))
              : registratinConfirmation(context),
      //status?Navigator.push(context, MaterialPageRoute(builder: ()=>BrandFeed(categoryId: catId,))):Navigator.push(context, MaterialPageRoute(builder: ()=>SelectPlan())),
      child: Container(
          //margin: EdgeInsets.only(right: 5,left: 5),
          margin: EdgeInsets.all(5),
          height: 130,
          width: 130,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(imgUrl + name), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)]),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 15,
                  padding: status
                      ? EdgeInsets.only(left: 5, right: 5)
                      : EdgeInsets.only(left: 0, right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: Center(
                    child: status
                        ? Text(
                            "Free",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : Text(
                            "",
                            style: TextStyle(
                                backgroundColor: Colors.red.withOpacity(.8)),
                          ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget getGCatImage(String catId, String date,String type, index, String name, bool status) {
    print("categoryId:$catId:displayImage:$name:categoryName:$type");
    //print("Newly Image is:$imgUrl+$name");
    //chcekDate(date);
    return InkWell(
      onTap: () =>
          chcekDate(date)
              ? profileStatus
                  ?
          // Fluttertoast.showToast(
          //     msg: type,
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.grey,
          //     textColor: Colors.white,
          //     fontSize: 16.0)
          Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              BrandFeed(categoryId: catId, displayImage: name,categoryName: type,)))
                  : registratinConfirmation(context)
              : Fluttertoast.showToast(
                  msg: "It is locked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0),
      //status?Navigator.push(context, MaterialPageRoute(builder: ()=>BrandFeed(categoryId: catId,))):Navigator.push(context, MaterialPageRoute(builder: ()=>SelectPlan())),
      child: Container(
          //margin: EdgeInsets.only(right: 5,left: 5),
          margin: EdgeInsets.all(5),
          height: 130,
          width: 130,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(imgUrl + name), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)]),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 25,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blueAccent),
                  child: Center(
                    child: Text(changeDF(date),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          )),
    );
  }

  // Widget getCatImage(String catId,index,String name,bool status)
  // {
  //   //print("https://manalsoftech.in/canva_365/img/"+name);
  //   return InkWell(onTap: ()=>
  //   {
  //     status?Navigator.push(context, MaterialPageRoute(builder: ()=>BrandFeed(categoryId: catId,))):Navigator.push(context, MaterialPageRoute(builder: ()=>SelectPlan()))
  //   },
  //     child: Container(
  //       margin: EdgeInsets.only(right: 15),
  //       height: 100,
  //       width: 100,
  //       child: status?Text("Demo",style: TextStyle(color: Colors.white,backgroundColor: Colors.grey.withOpacity(.8)),):Text("",style: TextStyle(backgroundColor: Colors.red.withOpacity(.8)),),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           image: DecorationImage(
  //               image: NetworkImage("https://manalsoftech.in/canva_365/img/"+name),
  //             //image:NetworkImage("https://images.unsplash.com/photo-1543770544-b6307a69e5d6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2F0ZWdvcnl8ZW58MHx8MHx8&ixlib"),
  //               fit: BoxFit.cover)
  //       ),
  //     ),
  //   );
  // }

// void showStartup(BuildContext context,String img)
// {
//   var alertDialog=AlertDialog(
//
//     content:Image.network("https://manalsoftech.in/canva_365/img/"+img,fit: BoxFit.fill)
//     // Container(
//     //   width: MediaQuery.of(context).size.width/1,
//     //     height: MediaQuery.of(context).size.width/1.2,
//     //     decoration: BoxDecoration(
//     //         color: Colors.white,
//     //         image: DecorationImage(
//     //             image: NetworkImage(
//     //                 'https://www.overallmotivation.com/wp-content/uploads/as-we-look-ahead-into-the-next-century-overallmotivation-768x768.png.webp')),
//     //         borderRadius: BorderRadius.circular(10),
//     //         boxShadow: [
//     //           BoxShadow(
//     //               blurRadius: 7, color: Colors.grey)
//     //         ]),),
//   );
//
//   showDialog(context: context,builder:(BuildContext context)
//   {
//     return alertDialog;
//   });
// }

  registratinConfirmation(BuildContext context) {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Column(
              children: [
                Text(
                  'Update Business Profile',
                  style: TextStyle(fontSize: 20, fontFamily: "Varela"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            content: Text(
              "Please update your profile first! do you want to update it?",
              style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
            ),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () => {Navigator.pop(context)},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.amber),
                          child: Text(
                            "Not this time!",
                            style:
                                TextStyle(fontFamily: 'Varela', fontSize: 15),
                          ),
                          padding: EdgeInsets.all(8),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () => {
                              Navigator.pop(context),
                              _navigateAndDisplaySelection(context)
                            },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor),
                          child: Text(
                            "Update Now",
                            style: TextStyle(
                                fontFamily: 'Varela',
                                color: Colors.white,
                                fontSize: 15),
                          ),
                          padding: EdgeInsets.all(8),
                        )),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showStartupDialog(String img) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.width / 1,
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: NetworkImage(imgUrl + img), fit: BoxFit.fill),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),
                child: CachedNetworkImage(
                  imageUrl: imgUrl + img,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: CircularProgressIndicator(value: downloadProgress.progress),
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
    //disableStartupPoster();
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBusinessPage()),
    );
    if (result == true) {
      getProfileStatus(false);
      setState(() {});
    }
  }

  bool chcekDate(date) {
    DateTime todayDate = DateTime.now();
    DateTime ddt = DateTime.parse(date);
    String formattedDate = DateFormat('dd-MM-yyyy').format(ddt);
    String formattedToDate = DateFormat('dd-MM-yyyy').format(todayDate);
    print("Dateing $formattedToDate and $formattedDate");
    if (ddt.isAfter(todayDate)) {
      return false;
      //print("nahi nikli gai");
    } else {
      return true;
      //print("nikal gai");
    }
  }

  changeDF(String ddt) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var date1 = inputFormat.parse(ddt);

    var outputFormat = DateFormat('dd-MMM-yyyy');
    var date2 = outputFormat.format(date1); // 2019-08-18
    return date2;
  }

  setNewLogo() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => addLogoPage()));
    print(result);
    setState(() {});
    // if(result!="")
    //   {
    //     setState(() {
    //
    //     });
    //   }
  }
}
