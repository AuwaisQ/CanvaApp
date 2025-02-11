import 'dart:convert';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/collageframe.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/CustomGreetingPage.dart';
import 'package:canvas_365/pages/CustomIamge.dart';
import 'package:canvas_365/pages/EditBusinessPage.dart';
import 'package:canvas_365/pages/GreetingFeeds.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:canvas_365/pages/custom_frame.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPage extends StatefulWidget {
  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  bool isApiCallingProcess = false;
  var url = Uri.parse(webUrl + "greetings");
  var data;
  List<dynamic> dta = [];
  List<NameIdBean> bData = [];

  List<dynamic> dtaFrame = [];
  List<NameIdBean> bFrame = [];

  List<dynamic> dtaSC = [];
  List<dynamic> dtaSPOS = [];
  List<NameIdBean> dtaSelectedPosters = [];
  List<NameIdBean> dtaFilteredPosters = [];

  bool profileStatus = false;

  @override
  void initState() {
    isApiCallingProcess = false;
    setState(() {});
    getProfileStatus(true);
    super.initState();
  }

  void getGreetingImage() async {
    print(url);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    data = jsonDecode(response.body);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status) {
      Map<String, dynamic> map = json.decode(response.body);

      dtaSC = map["categorylist"];
      dtaSPOS = map["subposter"];
      print("Startup Poster:" + dta.length.toString());
      print("dtascc:" + dtaSPOS.length.toString());
      dtaSelectedPosters.clear();
      for (int i = 0; i < dtaSPOS.length; i++) {
        bool stts = false;
        dtaSPOS[i]["paid"] == "Free" ? stts = true : stts = false;
        dtaSelectedPosters.add(new NameIdBean(
            dtaSPOS[i]["gsubcategoryid"].toString(),
            dtaSPOS[i]["categoryid"].toString(),
            dtaSPOS[i]["image"].toString(),
            stts));
      }

      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return ProgressHud(build_ui(context), isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Custom',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Letter head/ Create Poster/ Collage
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:EdgeInsets.only(right:10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red, width: 2.5)),
                          child: Center(
                              child: InkWell(
                                onTap: () => profileStatus?Navigator.push(context,MaterialPageRoute(builder: (_) =>

                                    CanvaCustomFrame()))
                                    :registratinConfirmation(context),child: Column(children: [
                                Image.asset(
                                  "assets/images/letterheadlogo.png",
                                  height: 95,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                              ),
                              ))),
                      Container(
                          margin:EdgeInsets.only(right:10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red, width: 2.5)),
                          child: Center(
                              child: InkWell(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => CustomImage())),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/creat_sticker.png",
                                      height: 95,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ))),
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red, width: 2.5)),
                          child: Center(
                              child: InkWell(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => CollageFrames())),
                                child: Image.asset(
                                  "assets/images/collage_sticker.png",
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ))),
                    ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(children: [
                    //Congratulations
                    Container(margin: EdgeInsets.only(left: 15,top: 10,right: 15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Congratulations",style: headTitle,)],)),
                    congratulations.length==0
                        ?Container(child: Center(child: Lottie.asset('assets/lottieFiles/loading.json'),),)
                        :Container(
                        padding: EdgeInsets.all(8),
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 5, crossAxisCount: 4),
                            itemBuilder: (context, index)=>InkWell(
                              onTap: ()=>{
                                profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>CustomGreetingPage("Congratulations",congratulations[index].imageUrl,congratulations[index].typeId)))
                                    :registratinConfirmation(context),
                                setState(() {})
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/"+congratulations[index].imageUrl),fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
                            )
                            ,itemCount: congratulations.length
                        )

                    ),

                    //Get Well Soon
                    Container(margin: EdgeInsets.only(left: 15,right: 15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Get Well Soon",style: headTitle,)],)),
                    getwellsoon.length==0
                        ?Container(child: Center(child: CircularProgressIndicator(),),)
                        :Container(
                        padding: EdgeInsets.all(8),
                        child: GridView.builder(scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 5,
                                crossAxisCount: 4),
                            itemBuilder: (context, index)=>InkWell(
                              onTap: ()=>{
                                profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>CustomGreetingPage("Get Well Soon",getwellsoon[index].imageUrl,getwellsoon[index].typeId))):registratinConfirmation(context),
                                setState(() {})
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/"+getwellsoon[index].imageUrl),fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
                            )//posterList[index].status)
                            //,itemCount: bData.length
                            ,itemCount: getwellsoon.length
                        )

                    ),

                    //Happy Birthday
                    Container(margin: EdgeInsets.only(left: 15,right: 15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Happy Birthday",style: headTitle,)],)),
                    happybirthday.length==0
                        ?Container(child: Center(child: CircularProgressIndicator(),),)
                        :Container(
                        padding: EdgeInsets.all(8),
                        child: GridView.builder(scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 5,
                                crossAxisCount: 4),
                            itemBuilder: (context, index)=>InkWell(
                              onTap: ()=>{
                                profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>CustomGreetingPage("HappyBirthday",happybirthday[index].imageUrl,happybirthday[index].typeId))):registratinConfirmation(context),
                                //profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>GreetingFeeds(categoryId: "Happy Birthday",displayImage:bData[index].image))):registratinConfirmation(context),
                                setState(() {})
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/"+happybirthday[index].imageUrl),fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
                            )//posterList[index].status)
                            //,itemCount: bData.length
                            ,itemCount: happybirthday.length
                        )

                    ),

                    //Happy Anniversary
                    Container(margin: EdgeInsets.only(left: 15,right: 15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Happy Anniversary",style: headTitle,)],)),
                    getwellsoon.length==0
                        ?Container(child: Center(child: CircularProgressIndicator(),),)
                        :Container(
                        padding: EdgeInsets.all(8),
                        child: GridView.builder(scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 5,
                                crossAxisCount: 4),
                            itemBuilder: (context, index)=>InkWell(
                              onTap: ()=>{
                                profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>CustomGreetingPage("Happy Aniversary",happyanniversary[index].imageUrl,happyanniversary[index].typeId))):registratinConfirmation(context),
                                //profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>GreetingFeeds(categoryId: "Happy Anniversary",displayImage:bData[index].image))):registratinConfirmation(context),
                                setState(() {})
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/"+happyanniversary[index].imageUrl),fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
                            )//posterList[index].status)
                            //,itemCount: bData.length
                            ,itemCount: happyanniversary.length
                        )

                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getProfileStatus(bool isSet) async {
    final prefs = await SharedPreferences.getInstance();
    profileStatus = prefs.getBool("isProfileUpdate")!;
    if (isSet) {}
    setState(() {});
  }

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

  Widget getSelectedCategoryPoster(String id, String name) {
    print(id + "::" + name);
    dtaFilteredPosters =
        dtaSelectedPosters.where((element) => element.name == id).toList();
    print("its filter list" + dtaFilteredPosters.length.toString());
    setState(() {});
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
                          builder: (_) => GreetingFeeds(
                              categoryId: id, displayImage: "none")))
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
                  false) //,dtaFilteredPosters[index].status)
              ),
        ),
      )
    ]);
  }

  Widget getCatImage(String catId, index, String name, bool status) {
    return InkWell(
      onTap: () =>
          profileStatus
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          GreetingFeeds(categoryId: catId, displayImage: name)))
              : registratinConfirmation(context),
      child: Container(
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
}
