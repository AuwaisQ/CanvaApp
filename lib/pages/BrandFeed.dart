import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/Account.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lecle_downloads_path_provider/constants/downloads_directory_type.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
// import 'package:path_download/path_download.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:canvas_365/others/MyColorPicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class BrandFeed extends StatefulWidget {
  String? categoryId;
  String? displayImage;
  String? categoryName;
  BrandFeed({required this.categoryId, this.displayImage, this.categoryName});
  @override
  _BrandFeedState createState() => _BrandFeedState(
      categoryId, displayImage.toString(), categoryName.toString());
}

class _BrandFeedState extends State<BrandFeed>
    with SingleTickerProviderStateMixin {
  String? categoryId;
  String displayImage = "";
  String selectedFrame = "";
  String displayVideo = "";
  String categoryName = "";
  bool isCustomFrame = false;
  int selectedCategory = 99999999;
  String customFrame = "none_custom_image.png";
  _BrandFeedState(this.categoryId, this.displayImage, this.categoryName);
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double? borderWidth = 0;
  bool? isBorder = false;
  Color _currentColor = primaryColor;
  Color _currentTextColor = Colors.black;
  List<NameIdBean> dtaFilteredPosters = [];
  List<NameIdBean> posterToShow = [];
  final _colorController = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  List<Widget> lstWidget = [
    ///1ST FOOTER
    Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              //Address
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft:
                          Radius.circular(10)), //BorderRadius.circular(10),
                  //border: Border.all(color: Colors.white)
                ),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Brand Address',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              ///Mobile Number
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5))),
                  height: 20,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 12,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          FittedBox(
                            fit: BoxFit.none,
                            child: Text(
                              'Contact Number',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        height: double.infinity,
                        width: 2,
                        color: Colors.red,
                      ),

                      ///Email Address
                      Row(
                        children: [
                          Icon(
                            Icons.mail,
                            size: 12,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          FittedBox(
                            fit: BoxFit.none,
                            child: Text(
                              'BRand Email Address',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              ///Business Name
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5))),
                  height: 20,
                  width: 110,
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: Text(
                      'Name of the Brand',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Image.network(
        //       logo != null
        //           ? imageUrl + logo!
        //           : imgAddLogo,
        //       width: 50,
        //     ),
        //   ),
        // ),
      ],
    ),
  ];

  List<dynamic> stLList = [
    GoogleFonts.oswald(fontStyle: FontStyle.italic, color: Colors.white)
  ];
  int selectedInd = 0;
  List<String> lstImage = [
    "frm1.png",
    "frm3.png",
    "frm2.png",
    "frm5.png",
    "frm4.png",
    "frm6.png",
    "frm7.png",
    "frm8.png",
    "frm9.png",
    "frm10.png",
    "frm11.png",
    "frm12.png",
    "frm13.png",
    "frm14.png",
  ];

  dynamic tStyle;
  var temId = "none";
  var top = 10.0;
  var left = 10.0;
  bool isApiCallingProcess = false;
  var url = Uri.parse(webUrl + "posterByCategoryApi");
  var frameViewUrl = Uri.parse(webUrl + "getCustomFrame");
  var likedImageUrl = Uri.parse(webUrl + "addMyFavouriteImage");
  var data;
  List<dynamic> dta = [];
  List<dynamic> dtaVideo = [];
  List<NameIdBean> posterList = [];
  List<NameIdBean> searchPoster = [];
  List<dynamic> dtaCategory = [];
  List<NameIdBean> dtaCategoryList = [];

  List<dynamic> dtaFrameCategory = [];
  List<NameIdBean> dtaFrameCategoryList = [];

  List<NameIdBean> videoList = [];
  String msg = "";
  bool sStatus = false;
  String? mobile, businessName;
  String? address;
  String? emailAddress, language_array;
  String? logo;
  bool? issubscribed;
  GlobalKey? globalkey;
  Uint8List? byteOne;
  var bs64 = "";
  List<dynamic> lnggDta = [];
  bool isProfileUpdate = false;
  String? userId;
  bool haiImage = true;
  GlobalKey? frameKey;
  TabController? _tabController;
  List<NameIdBean> choices = <NameIdBean>[];
  List<String> choicesId = <String>[];

  VideoPlayerController setData(String vUrl) {
    print(vUrl);
    _controller = VideoPlayerController.network(vUrl)
      ..setLooping(true)
      ..setVolume(20);
    _initializeVideoPlayerFuture = _controller.initialize();
    return _controller;
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    isProfileUpdate = prefs.getBool("isProfileUpdate")!;
    userId = prefs.getString("user_id")!;
    if (isProfileUpdate) {
      mobile = prefs.getString('contact1');
      address = prefs.getString('businessAddress');
      emailAddress = prefs.getString('email');
      logo = prefs.getString('logo');
      issubscribed = prefs.getBool("isSubscribed");
      language_array = prefs.getString("language_array");
      //issubscribed = prefs.getBool("isSubscribed");
      businessName = prefs.getString('businessName');
    }
    print(language_array);
    Map<String, dynamic> maps = json.decode(language_array.toString());
    lnggDta = maps["lang"];

    print("it le length" + lnggDta.length.toString());
    for (int i = 0; i < lnggDta.length; i++) {
      //choices.add(lnggDta[i]["language"]);
      choices.add(new NameIdBean(lnggDta[i]["id"], lnggDta[i]["language"],
          lnggDta[i]["language"], true));
      choicesId.add(lnggDta[i]["id"]);
    }
    print("Is she subscribe$issubscribed");

    setState(() {
      getWidgetData();
    });
  }

  void getBusinessCategory() async {
    print("$categoryId XXX $url");
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'categoryId': categoryId!,
        }));
    print(response.body);
    data = jsonDecode(response.body);
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status) {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["subposter"];
      dtaCategory = map["subcategorylist"];
      print("it is lenght of dtaCategory${dtaCategory.length}");
      dtaVideo = map["videos"];
      if (displayImage == "none") {
        displayImage = dta[0]["image"];
      }
      dtaCategoryList
          .add(new NameIdBean("99999999".toString(), "All", "99999999", true));
      for (int i = 0; i < dtaCategory.length; i++) {
        //dta[i]["paid"]=="Free"?stts=true:stts=false;
        dtaCategoryList.add(new NameIdBean(
            dtaCategory[i]["id"].toString(),
            dtaCategory[i]["subcategory"],
            dtaCategory[i]["subcategory"],
            true));
      }
      print("it is lenght of dtaCategoryList${dtaCategoryList.length}");
      for (int i = 0; i < dta.length; i++) {
        bool stts = false;
        //dta[i]["paid"]=="Free"?stts=true:stts=false;
        posterList.add(new NameIdBean(dta[i]["subcategoryid"].toString(),
            dta[i]["languageid"].toString(), dta[i]["image"], true));
        searchPoster.add(new NameIdBean(dta[i]["subcategoryid"].toString(),
            dta[i]["languageid"].toString(), dta[i]["image"], true));
        print(
            "none here${dta[i]["subcategoryid"].toString() + "," + dta[i]["languageid"].toString() + "," + dta[i]["image"]}");
      }

      setState(() {});

      if (dtaVideo.length > 0) {
        //videoList = dtaVideo[0]["videopath"];
        for (int i = 0; i < dtaVideo.length; i++) {
          bool stts = false;
          dtaVideo[i]["paid"] == "Free" ? stts = true : stts = false;
          videoList.add(new NameIdBean(dtaVideo[i]["id"].toString(),
              dtaVideo[i]["video_image"], dtaVideo[i]["videopath"], stts));
        }
      }

      print("Video Data Length:" + dtaVideo.toString());
      getWidgetData();
      setState(() {});
    } else {
      //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    isApiCallingProcess = false;
    setState(() {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
    getMyFrame();
  }

  void getMyFrame() async {
    print("$userId XXX $frameViewUrl");
    var response = await http.post(frameViewUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': '$userId!', //categoryId.toString(),
        }));
    print(jsonEncode(<String, String>{'userId': '$userId!'}));
    print(response.body);
    data = jsonDecode(response.body);
    print(data);
    Map<String, dynamic> map = json.decode(response.body);
    dtaFrameCategory = map["customframe"];
    if (dtaFrameCategory.isNotEmpty) {
      customFrame = dtaFrameCategory[0]["frame"];
    }

    for (int i = 0; i < dtaFrameCategory.length; i++) {
      //dta[i]["paid"]=="Free"?stts=true:stts=false;
      dtaFrameCategoryList.add(new NameIdBean(
          dtaFrameCategory[i]["id"].toString(),
          dtaFrameCategory[i]["frame"],
          dtaFrameCategory[i]["frame"],
          true));
    }

    print("fRAMElIST Data Length:" + dtaFrameCategoryList.toString());
    //getWidgetData();
    setState(() {});
    isApiCallingProcess = false;
    setState(() {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
    //getMyFrame();
  }

  void setLikePoster() async {
    print(displayImage);
    print(userId);
    var response = await http.post(likedImageUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': userId.toString(),
          'imageName': displayImage,
        }));
    data = jsonDecode(response.body);
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status) {
      Fluttertoast.showToast(
          msg: "Successfully added in wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    isApiCallingProcess = false;
    setState(() {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }

  @override
  void initState() {
    print(
        "categoryId:$categoryId:displayImage:$displayImage:categoryName:$categoryName");
    getUserData();
    //isApiCallingProcess=true;
    getBusinessCategory();
    print("it is category name is hree" + categoryName);
    _tabController = new TabController(length: 6, vsync: this);
    _tabController!.addListener(() {
      // setState(() {
      //   _selectedIndex = _controller.index;
      // });
      if (_tabController!.index == 0 && haiImage == false) {
        haiImage = true;
        setState(() {
          //haiImage = _tabController!.index;
        });
      } else if (_tabController!.index == 1 && haiImage == true) {
        haiImage = false;
        setState(() {
          //haiImage = _tabController!.index;
          displayVideo = vdoUrl + dtaVideo[0]["videopath"].toString().trim();
        });
      }

      if (_tabController!.index == 2) {
        isCustomFrame = false;
        setState(() {});
      }
      if (_tabController!.index == 3) {
        isCustomFrame = true;
        setState(() {});
      }
      //haiImage = _tabController!.index;
      print("Now Selected Index: " + haiImage.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context) {
    VideoPlayerController vpc = setData(displayVideo);
    vpc.play();
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _controller.dispose();
              _controller.pause();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            categoryName,
            //'Category Poster',
            style: TextStyle(fontFamily: font),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                setLikePoster();
              },
              icon: FaIcon(
                FontAwesomeIcons.heart,
                color: Colors.white,
                size: 20,
              ),
            ),
            if (haiImage)
              IconButton(
                onPressed: () async {
                  final chalega = await Utils.capture(globalkey!, context);
                },
                icon: Icon(
                  Icons.share,
                  size: 20,
                ),
              )
            else
              IconButton(
                onPressed: () async {
                  if (frameKey != null) {
                    final bs64 = await Utils.captureBase6(frameKey!);
                    sendFrameImage(bs64);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please Subscribe to use this feature",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: successColor,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                icon: FaIcon(
                  FontAwesomeIcons.shareAlt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            //Language Select Button
            PopupMenuButton(
              icon: Icon(Icons.translate_outlined),
              //onSelected: _select,
              padding: EdgeInsets.zero,
              // initialValue: choices[_selection],
              itemBuilder: (BuildContext context) {
                return choices.map((NameIdBean choice) {
                  return PopupMenuItem<String>(
                    value: choice.id,
                    child: Text(choice.name),
                    onTap: () => {
                      //searchPoster=posterList.where((element) => element.name.contains(choice.id)).toList(),
                      if (selectedCategory == 99999999)
                        {
                          searchPoster = posterList
                              .where(
                                  (element) => element.name.contains(choice.id))
                              .toList(),
                          //print("${element.name}Search Length is:${searchPoster.length}"),
                        }
                      else
                        {
                          searchPoster = dtaFilteredPosters.length > 0
                              ? dtaFilteredPosters
                                  .where((element) =>
                                      element.name.contains(choice.id))
                                  .toList()
                              : posterList
                                  .where((element) =>
                                      element.name.contains(choice.id))
                                  .toList(),
                        },
                      setState(() {}),
                      print(choice.id)
                    },
                  );
                }).toList();
              },
            ),
            //Save Button
            IconButton(
              onPressed: () async {
                isApiCallingProcess = true;
                setState(() {});
                final bs64 = await Utils.captureBase6(globalkey!);
                //print("Now BS6 id"+bs64);
                sendProductImage(bs64);
              },
              icon: Icon(
                Icons.save,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                !haiImage
                    //Video Tab
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: isBorder!
                              ? Border.all(
                                  color: _currentColor, width: borderWidth!)
                              : Border.all(color: _currentColor, width: 0),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            //Video Preview
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: VideoPlayer(vpc),
                                      ),
                                    ))),
                            //Watermark Image
                            issubscribed == false
                                ? Image.network(
                                    "https://canva365.com/public/img/logo.png",
                                    width: 450,
                                  )
                                : Container(),
                            temId != "none"
                                ? widgetToImage(builder: (key) {
                                    this.frameKey = key;
                                    return Container(
                                      child: getCustomTemplate(temId),
                                      alignment: Alignment.bottomCenter,
                                      height: MediaQuery.of(context).size.width,
                                      width: MediaQuery.of(context).size.width,
                                    );
                                  })
                                : lstWidget[0],
                          ],
                        ),
                      )
                    //Image Tab
                    : widgetToImage(builder: (key) {
                        this.globalkey = key;
                        return Container(
                          alignment: Alignment.bottomCenter,
                          height: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width * (8 / 100),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isBorder!
                                  ? Border.all(
                                      color: _currentColor, width: borderWidth!)
                                  : Border.all(color: _currentColor, width: 0),
                              image: DecorationImage(
                                  image: NetworkImage(imgUrl + displayImage),
                                  fit: BoxFit.contain)),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              // //Logo
                              issubscribed == false
                                  ? Image.network(
                                      "https://canva365.com/public/img/logo.png",
                                      width: 450,
                                    )
                                  : GestureDetector(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.network(
                                            logo != null
                                                ? imageUrl + logo!
                                                : imgAddLogo,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                      onVerticalDragUpdate:
                                          (DragUpdateDetails dd) {
                                        setState(() {
                                          print(dd);
                                          top = dd.localPosition.dy;
                                          left = dd.localPosition.dx;
                                        });
                                      },
                                    ),
                              isCustomFrame
                                  ? Image.network(imgUrl + customFrame)
                                  : temId != "none"
                                      ? getCustomTemplate(temId)
                                      : lstWidget[0], //Container()
                            ],
                          ),
                        );
                      }),

                //Choice Chip's
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      children: List.generate(
                        dtaCategoryList.length,
                        (index) => getChip(dtaCategoryList[index], index),
                      ),
                    ),
                  ),
                ),

                !haiImage
                    //Post Tab bar
                    ? TabBar(
                        controller: _tabController,
                        indicatorColor: primaryColor,
                        labelColor: Colors.white,
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey,
                        onTap: (index) {
                          print("selected tab is $index:");
                          getWidgetData();
                          setState(() => {});
                        },
                        tabs: [
                          Tab(
                            text: "Posts",
                          ), //child:Text("Posts", style: TextStyle(fontSize: 12))),
                          Tab(
                            text: "Videos",
                          ),
                          Tab(
                            text: "Footer",
                          ),
                        ],
                      )
                    //Video Tab bar
                    : TabBar(
                        controller: _tabController,
                        indicatorColor: primaryColor,
                        labelColor: Colors.white,
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey,
                        onTap: (index) {
                          print("selected tab is $index:");
                          getWidgetData();
                          setState(() => {});
                        },
                        tabs: [
                          Tab(
                            text: "Posts",
                          ), //child:Text("Posts", style: TextStyle(fontSize: 12))),
                          Tab(
                            text: "Videos",
                          ),
                          Tab(
                            text: "Footer",
                          ), //child:Center(child: Text("Footer", style: TextStyle(fontSize: 12)),)),
                          Tab(
                            text: "My Frame",
                          ), //child:Center(child: Text("Footer", style: TextStyle(fontSize: 12)),)),
                          Tab(
                            text: "Backgrounds",
                          ), //child: Text("Backgrounds",style: TextStyle(fontSize: 12))),
                          Tab(
                            text: "Text",
                          ),
                        ],
                      ),

                //Tab Bar View
                !haiImage
                    //PostTab View
                    ? Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            //Post's Tab
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: searchPoster.isEmpty
                                  ? Center(child: CircularProgressIndicator(color: primaryColor,),)
                                  : GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 5, crossAxisCount: 3),
                                itemBuilder: (context, index) => getCatImage(searchPoster[index].name, index,
                                    searchPoster[index].image,
                                    false),
                                itemCount: searchPoster.length,
                                physics: ScrollPhysics(),
                              ),
                            ),
                            //Video Tab
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: videoList.isEmpty
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/no_video.png",
                                        height: 150,
                                        width: 150,
                                      ))
                                  : GridView.builder(
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: .1,
                                              crossAxisCount: 3),
                                      itemBuilder: (context, index) {
                                        print("Video Image is here" + webUrl + dtaVideo[index]["video_image"].toString());
                                        //VideoPlayerController contro=setData(vdoUrl+dtaVideo[index]["videopath"]);
                                        return Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(imageUrl +
                                                        dtaVideo[index]
                                                                ["video_image"]
                                                            .toString()),
                                                    fit: BoxFit.cover),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: InkWell(
                                              onTap: () {
                                                displayVideo = vdoUrl +
                                                    dtaVideo[index]["videopath"]
                                                        .toString()
                                                        .trim();
                                                print(displayVideo);
                                                if (_controller
                                                    .value.isInitialized) {
                                                  _controller.dispose();
                                                }
                                                setState(() {});
                                              },
                                            ));
                                      },
                                      itemCount: dtaVideo.length,
                                    ),
                            ),
                            //Footer Tab
                            Container(
                                height: 350,
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 1,
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    height: 50,
                                    margin: EdgeInsets.all(5),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.white)),
                                        alignment: Alignment.bottomCenter,
                                        // color: Colors.green,
                                        child: Image.asset(
                                            "assets/images/" + lstImage[index]),
                                      ),
                                      onTap: () => {
                                        temId = index.toString(),
                                        print("Item id is:$temId"),
                                        setState(() {}),
                                      },
                                    ),
                                  ) //posterList[index].status)
                                  ,
                                  itemCount: lstWidget.length,
                                  physics: ScrollPhysics(),
                                )),
                          ],
                        ),
                      )
                    //Video Tab View
                    : Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            //Post's Tab
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: searchPoster.isEmpty
                                  ? Center(child: CircularProgressIndicator(color: primaryColor,),)
                                  : GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 5, crossAxisCount: 3),
                                itemBuilder: (context, index) => getCatImage(searchPoster[index].name, index,
                                    searchPoster[index].image,
                                    false),
                                itemCount: searchPoster.length,
                                physics: ScrollPhysics(),
                              ),
                            ),
                            //Video Tab
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: videoList.isEmpty
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/no_video.png",
                                        height: 150,
                                        width: 150,
                                      ))
                                  : GridView.builder(
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: .1,
                                              crossAxisCount: 3),
                                      itemBuilder: (context, index) {
                                        print("Video Image is here" +
                                            webUrl +
                                            dtaVideo[index]["video_image"]
                                                .toString());
                                        //VideoPlayerController contro=setData(vdoUrl+dtaVideo[index]["videopath"]);
                                        return Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(imageUrl +
                                                        dtaVideo[index]
                                                                ["video_image"]
                                                            .toString()),
                                                    fit: BoxFit.cover),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: InkWell(
                                              onTap: () {
                                                displayVideo = vdoUrl + dtaVideo[index]["videopath"].toString().trim();
                                                print(displayVideo);
                                                if (_controller.value.isInitialized) {
                                                  _controller.dispose();
                                                  _controller.pause();
                                                  _controller.closedCaptionFile;
                                                }
                                                setState(() {});
                                              },
                                            ));
                                      },
                                      itemCount: dtaVideo.length,
                                    ),
                            ),
                            //Footer Tab
                            Container(
                                height: 350,
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 1,
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    height: 50,
                                    margin: EdgeInsets.all(5),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.white)),
                                        alignment: Alignment.bottomCenter,
                                        // color: Colors.green,
                                        child: Image.asset(
                                            "assets/images/" + lstImage[index]),
                                      ),
                                      onTap: () => {
                                        temId = index.toString(),
                                        print("Item id is:$temId"),
                                        setState(() {}),
                                      },
                                    ),
                                  ) //posterList[index].status)
                                  ,
                                  itemCount: lstWidget.length,
                                  physics: ScrollPhysics(),
                                )),
                            //My Frame Tab
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 5, crossAxisCount: 3),
                                itemBuilder: (context, index) => getFrameImage(
                                    dtaFrameCategoryList[index].name,
                                    index,
                                    dtaFrameCategoryList[index].image,
                                    false),
                                itemCount: dtaFrameCategoryList.length,
                                physics: ScrollPhysics(),
                              ),
                            ),
                            //Backgrounds Tab
                            Container(
                                height: 350,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          elevation: 5,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                checkColor: Colors.white,
                                                //fillColor: MaterialStateProperty.resolveWith(primaryColor),
                                                fillColor: MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        primaryColor),
                                                value: isBorder,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isBorder = value!;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Border",
                                                style: TextStyle(
                                                    color: primaryColor),
                                              ),
                                              Slider(
                                                value: borderWidth!,
                                                min: 0,
                                                max: 10,
                                                divisions: 100,
                                                label: borderWidth.toString(),
                                                onChanged: (double value) {
                                                  setState(() {
                                                    borderWidth = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        CircleColorPicker(
                                          controller: _colorController,
                                          onChanged: (color) {
                                            setState(() => {
                                                  _currentColor = color,
                                                  getWidgetData()
                                                });
                                          },
                                          size: const Size(260, 260),
                                          strokeWidth: 25,
                                          thumbSize: 50,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            //Text Tab
                            Container(
                                height: 350,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 5,
                                                childAspectRatio: (30 / 10),
                                                crossAxisCount: 4),
                                        itemBuilder: (context, index) =>
                                            Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          height: 50,
                                          margin: EdgeInsets.all(2),
                                          child: Center(
                                              child: InkWell(
                                            child: Text("Can365",
                                                style: stList[index]),
                                            onTap: () => {
                                              selectedInd = index,
                                              getWidgetData(),
                                              setState(() {}),
                                              tStyle = stLList[selectedInd],
                                            },
                                          )),
                                        ) //posterList[index].status)
                                        ,
                                        itemCount: stList.length,
                                        physics: ScrollPhysics(),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      MyColorPicker(
                                          onSelectColor: (value) {
                                            _currentTextColor = value;
                                            tStyle = stLList[selectedInd];
                                            setState(() {});
                                            getWidgetData();
                                          },
                                          availableColors: [
                                            Colors.blue,
                                            Colors.green,
                                            Colors.greenAccent,
                                            Colors.yellow,
                                            Colors.orange,
                                            Colors.red,
                                            Colors.purple,
                                            Colors.grey,
                                            Colors.deepOrange,
                                            Colors.teal,
                                            Colors.white,
                                            Colors.black
                                          ],
                                          initialColor: Colors.blue)
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ));
  }

  Widget getCatImage(String catId, index, String name, bool status) {
    //print("https://manalsoftech.in/canva_365/img/"+name);
    return InkWell(
      onTap: () => {
        if (isProfileUpdate)
          {
            //displayImage = dtaFilteredPosters.isNotEmpty? dtaFilteredPosters[index].image: posterList[index].image,
            displayImage = searchPoster[index].image,
            print("Changed img is here" + displayImage),
            //sStatus=false,
            setState(() {
              getWidgetData();
            })
          }
        else
          {
            //sStatus=true,
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Account())),
          }
      },
      child: Container(
          margin: EdgeInsets.all(4),
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(imgUrl + name), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey)]),
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

  Widget getFrameImage(String catId, index, String name, bool status) {
    return InkWell(
      onTap: () => {
        isCustomFrame = true,
        customFrame = name,
        setState(() {
          isCustomFrame = true;
          customFrame = name;
        }),
        print("New Frame Url is now:" + customFrame),
      },
      child: Container(
        margin: EdgeInsets.all(4),
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: NetworkImage(imgUrl + name), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey)]),
      ),
    );
  }

  Future<void> share(dynamic link, String title) async {
    await FlutterShare.share(
        title: title,
        text: "It is text",
        linkUrl: "link",
        chooserTitle: 'Where you want to share');
  }

  Future<File> writeFile(Uint8List data, String name) async {
    Directory? tempDir = await
    // PathDownload().pathDownload(TypeFileDirectory.pictures);
    DownloadsPath.downloadsDirectory(dirType: DownloadDirectoryTypes.pictures);
    String tempPath = tempDir!.path;
    var filePath = tempPath + '/$name';
    //
    // the data
    var bytes = ByteData.view(data.buffer);
    final buffer = bytes.buffer;
    // save the data in the path
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  sendProductImage(String anShu) async {
    var url = Uri.parse(webUrl + "uploadMyimage");
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-type": "multipart/form-data",
      },
      encoding: Encoding.getByName("utf-8"),
      body: jsonEncode(<String, dynamic>{
        "image": anShu,
        'userId': userId,
      }),
    );
    var body = jsonDecode(response.body);
    print(response.body);
    //print(body);
    var msg = body['msg'];

    if (body['status'] == true) {
      var imageName = body['imageName'];
      print("it i9s imageName:" + imageName);
      String path = imageUrl + imageName;
      GallerySaver.saveImage(path, albumName: "Download").then((value) => null);
      Fluttertoast.showToast(
          //msg: msg,
          msg: "Poster Download Complete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0);
      // String imageName=body['imageName'];
      // setPrefProfileData(imageName,imageType);
    } else {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    isApiCallingProcess = false;
    setState(() {
      //String path =imageUrl+;
      //GallerySaver.saveImage(path,albumName: "Download").then((value) => null);
    });
    Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: (_) => Downloads()));
  }

  Widget getCustomTemplate(id) {
    switch (id) {
      case "0":
        return lstWidget[int.parse(id)];
      case "1":
        return lstWidget[int.parse(id)];
      case "2":
        return lstWidget[int.parse(id)];
      case "3":
        return lstWidget[int.parse(id)];
      case "4":
        return lstWidget[int.parse(id)];
      case "5":
        return lstWidget[int.parse(id)];
      case "6":
        return lstWidget[int.parse(id)];
      case "7":
        return lstWidget[int.parse(id)];
      case "8":
        return lstWidget[int.parse(id)];
      case "9":
        return lstWidget[int.parse(id)];
      case "10":
        return lstWidget[int.parse(id)];
      case "11":
        return lstWidget[int.parse(id)];
      case "12":
        return lstWidget[int.parse(id)];
      case "13":
        return lstWidget[int.parse(id)];
      case "14":
        return lstWidget[int.parse(id)];
      default:
        return Container(
          color: Colors.black,
          width: 300,
          height: 300,
        );
    }
  }

  getWidgetData() {
    setState(() {});
    stLList.clear();
    stLList = [
      GoogleFonts.oswald(
          fontStyle: FontStyle.italic, color: _currentTextColor, fontSize: 12),
      GoogleFonts.poppins(
          fontStyle: FontStyle.italic, color: _currentTextColor, fontSize: 12),
      GoogleFonts.lato(
          fontStyle: FontStyle.italic, color: _currentTextColor, fontSize: 12),
      GoogleFonts.varela(
          fontStyle: FontStyle.italic, color: _currentTextColor, fontSize: 12),
      GoogleFonts.aBeeZee(
          fontStyle: FontStyle.italic, color: _currentTextColor, fontSize: 12),
      GoogleFonts.lato(
          fontStyle: FontStyle.italic, color: _currentTextColor, fontSize: 12),
      GoogleFonts.amaranth(
          fontStyle: FontStyle.normal, color: _currentTextColor, fontSize: 12),
      GoogleFonts.artifika(
          fontStyle: FontStyle.normal, color: _currentTextColor, fontSize: 12),
      GoogleFonts.bentham(
          fontStyle: FontStyle.normal, color: _currentTextColor, fontSize: 12),
      GoogleFonts.bangers(
          fontStyle: FontStyle.normal, color: _currentTextColor, fontSize: 12),
      GoogleFonts.boogaloo(
          fontStyle: FontStyle.normal, color: _currentTextColor, fontSize: 12),
      GoogleFonts.condiment(
          fontStyle: FontStyle.normal, color: _currentTextColor, fontSize: 12),
    ];

    lstWidget.clear();

    //Footer Widgets
    lstWidget = [
      //1ST FOOTER
      Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                //Address
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _currentColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft:
                            Radius.circular(10)), //BorderRadius.circular(10),
                    //border: Border.all(color: Colors.white)
                  ),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                          color: _currentTextColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          address!,
                          style:
                              TextStyle(color: _currentTextColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                ///Mobile Number
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5))),
                    height: 20,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 12,
                              color: _currentTextColor,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            FittedBox(
                              fit: BoxFit.none,
                              child: Text(
                                mobile!, style: tStyle,
                                // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          height: double.infinity,
                          width: 2,
                          color: Colors.red,
                        ),

                        ///Email Address
                        Row(
                          children: [
                            Icon(
                              Icons.mail,
                              size: 12,
                              color: _currentTextColor,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            FittedBox(
                              fit: BoxFit.none,
                              child: Text(
                                emailAddress!, style: tStyle,
                                // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ///Business Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Container(
                    decoration: BoxDecoration(
                        color: _currentColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5))),
                    height: 20,
                    width: 110,
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: Text(
                        businessName!, style: tStyle,
                        // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
        ],
      ),

      ///2nd Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 40),
                  child: Container(
                    height: double.infinity,
                    width: 3,
                    decoration: BoxDecoration(
                      color: _currentColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 15),
                  height: 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: _currentColor,
                      borderRadius: BorderRadius.circular(50)),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 7, bottom: 10),
                      height: 120,
                      width: 25,
                      decoration: BoxDecoration(
                          color: _currentColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.mail,
                            size: 15,
                            color: _currentTextColor,
                          ),
                          Icon(
                            Icons.phone,
                            size: 15,
                            color: _currentTextColor,
                          ),
                          Icon(
                            Icons.location_on,
                            size: 15,
                            color: _currentTextColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, bottom: 10),
                      height: 80,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            emailAddress!,
                            style: tStyle,
                          ),
                          Text(
                            mobile!,
                            style: tStyle,
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  address!,
                                  style: tStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      ///3rd Footer
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //Logo
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 47, right: 15),
                child: Text(businessName!, style: tStyle),
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.5),
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(200))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 25, left: 25, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Mobile Number
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 15,
                            color: _currentTextColor,
                          ),
                          Text(mobile!, style: tStyle),
                        ],
                      ),
                      Container(
                        height: double.infinity,
                        width: 2,
                        color: Colors.black,
                      ),

                      ///Email Address
                      Row(
                        children: [
                          Icon(
                            Icons.mail,
                            color: _currentTextColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            emailAddress!,
                            style: tStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 25,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: _currentColor,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(200))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),

                  ///Address
                  child: FittedBox(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                          color: _currentTextColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(address!, style: tStyle),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///4th Footer
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _currentColor,
                    width: 2,
                  ),
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///Business Name
                      Container(
                        height: 25,
                        width: 180,
                        decoration: BoxDecoration(
                            color: _currentColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            businessName!,
                            style: tStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      ///Phone Number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 15,
                            color: _currentTextColor,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            mobile!,
                            style: tStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      ///Email Address
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail,
                            size: 15,
                            color: _currentTextColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            emailAddress!,
                            style: tStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),

                      ///Address
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 15,
                              color: _currentTextColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              address!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),

      ///5th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                          color: _currentColor,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(10))),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mail,
                              size: 18,
                              color: _currentTextColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              emailAddress!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 25,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: _currentColor,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(10))),

                      ///Mobile Number
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: double.infinity,
                            width: 3,
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 19,
                                color: _currentTextColor,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                mobile!,
                                style: tStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),

                ///Address
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: _currentTextColor,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        address!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: tStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///6th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 25,
                      // width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          color: _currentColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mail,
                              size: 18,
                              color: _currentTextColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              emailAddress!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20)),

                      ///Mobile Number
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 19,
                            color: _currentTextColor,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            mobile!,
                            style: tStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: _currentColor,
                    ),

                    ///Address
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: _currentTextColor,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            address!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: tStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      ///7th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 5.0, color: _currentColor),
                      left: BorderSide(width: 5.0, color: _currentColor),
                      bottom: BorderSide(width: 5.0, color: _currentColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 3,
                                    width: 15,
                                    decoration:
                                        BoxDecoration(color: _currentColor),
                                  ),
                                  Image.asset(
                                    'assets/images/phone.png',
                                    color: _currentColor,
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 4,
                                    width: 15,
                                    decoration:
                                        BoxDecoration(color: _currentColor),
                                  ),
                                  Image.asset(
                                    'assets/images/mail.png',
                                    color: _currentColor,
                                    height: 21,
                                    width: 21,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 4,
                                    width: 15,
                                    decoration:
                                        BoxDecoration(color: _currentColor),
                                  ),
                                  Image.asset(
                                    'assets/images/location.png',
                                    color: _currentColor,
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              )
                            ],
                          )),
                      Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                mobile!,
                                style: tStyle,
                              ),
                              Text(
                                emailAddress!,
                                style: tStyle,
                              ),
                              FittedBox(
                                child: Text(
                                  address!,
                                  textAlign: TextAlign.center,
                                  style: tStyle,
                                ),
                              ),
                            ],
                          ))
                    ],
                  )),
            ],
          ),
        ],
      ),

      ///8th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Email Address
                  Container(
                    decoration: BoxDecoration(
                        color: _currentColor,
                        borderRadius: BorderRadius.circular(30)),
                    height: 25,
                    width: MediaQuery.of(context).size.width / 2.9,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mail,
                              color: _currentTextColor,
                              size: 12,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              emailAddress!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    businessName!, style: tStyle,
                    // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                  ),
                  SizedBox(width: 5),

                  ///Phone Number
                  Container(
                    decoration: BoxDecoration(
                        color: _currentColor,
                        borderRadius: BorderRadius.circular(30)),
                    height: 25,
                    width: MediaQuery.of(context).size.width / 3.4,
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: _currentTextColor,
                            size: 11,
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          Text(
                            mobile!,
                            style: tStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xffA7A75A),
                ),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: _currentTextColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        address!,
                        textAlign: TextAlign.center,
                        style: tStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///9th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                      color: _currentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        bottomLeft: Radius.circular(7),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/web.png',
                        color: _currentTextColor,
                        height: 15,
                        width: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        businessName!,
                        style: tStyle,
                      ),
                    ],
                  ),
                ),
              ]),
              Container(
                height: 25,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffA7A75A),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/mail.png',
                            color: _currentTextColor,
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            emailAddress!,
                            style: tStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: double.infinity,
                            width: 2,
                            color: _currentTextColor,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            height: double.infinity,
                            width: 2,
                            color: _currentTextColor,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/phone.png',
                            color: _currentTextColor,
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(width: 7),
                          Text(
                            mobile!,
                            style: tStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _currentColor,
                ),
                height: 25,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: _currentTextColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        address!,
                        textAlign: TextAlign.center,
                        style: tStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///10th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(color: Colors.yellow.shade900),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/mail.png',
                              color: _currentTextColor,
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(width: 2),
                            Text(
                              emailAddress!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width / 1.9,
                      decoration: BoxDecoration(color: Colors.green.shade900),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/phone.png',
                              color: _currentTextColor,
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(width: 2),
                            Text(
                              mobile!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _currentColor,
                ),
                height: 25,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: _currentTextColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        address!,
                        textAlign: TextAlign.center,
                        style: tStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///11th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FittedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            border: Border.all(color: _currentColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/mail.png',
                              color: _currentTextColor,
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(width: 2),
                            Text(
                              emailAddress!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width / 1.8,
                        decoration: BoxDecoration(
                            border: Border.all(color: _currentColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/phone.png',
                              color: _currentTextColor,
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(width: 2),
                            Text(
                              mobile!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: _currentColor)),
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: _currentTextColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          address!,
                          textAlign: TextAlign.center,
                          style: tStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///12th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 3,
                width: double.infinity,
                color: _currentColor,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(color: _currentColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/mail.png',
                            color: _currentTextColor,
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(width: 2),
                          Text(
                            emailAddress!,
                            style: tStyle,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          border: Border.all(color: _currentColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/phone.png',
                            color: _currentTextColor,
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(width: 2),
                          Text(
                            mobile!,
                            style: tStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _currentColor,
                ),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: _currentTextColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        address!,
                        textAlign: TextAlign.center,
                        style: tStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///13th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  businessName!,
                  style: tStyle,
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff666633),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        height: 25,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: _currentTextColor,
                              size: 11,
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Text(
                              mobile!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff666633),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        height: 25,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mail,
                              color: _currentTextColor,
                              size: 12,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              emailAddress!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  color: _currentColor,
                ),
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: _currentTextColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          address!,
                          textAlign: TextAlign.center,
                          style: tStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      ///14th Footer
      Stack(
        children: [
          //Logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo != null ? imageUrl + logo! : imgAddLogo,
                width: 50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          border: Border.all(color: _currentColor, width: 2),
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(40))),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/mail.png',
                              color: _currentTextColor,
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              emailAddress!,
                              style: tStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          border: Border.all(color: _currentColor, width: 2),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/phone.png',
                            color: _currentTextColor,
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            mobile!,
                            style: tStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: _currentColor, width: 2),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40))),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/location.png',
                                color: _currentTextColor,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                address!,
                                style: tStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ];
    setState(() {});
  }

  Widget getChip(NameIdBean nameIdBean, int index) {
    //print(nameIdBean.status);
    var _isSelected = false;
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: ChoiceChip(
        shape: StadiumBorder(
            side: BorderSide(
          color: (selectedCategory == int.parse(nameIdBean.id))
              ? Colors.green
              : Colors.grey,
        )),
        padding: EdgeInsets.symmetric(horizontal: 15),
        elevation: 10,
        label: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(nameIdBean.name)),
        labelStyle: TextStyle(
            color: (selectedCategory == int.parse(nameIdBean.id))
                ? Colors.white
                : Colors.grey,
            fontFamily: 'Poppins',
            fontSize: 15.0),
        selected: _isSelected,
        backgroundColor: Color(0xFF36454f),
        onSelected: (isSelected) {
          print("it is selectred${nameIdBean.image}");
          if (nameIdBean.image == "99999999") {
            //dtaFilteredPosters=posterList.where((element) =>element.id.toLowerCase().contains(nameIdBean.id)).toList();
            selectedCategory = 99999999;
            searchPoster =
                posterList; //posterList.where((element) =>element.id.toLowerCase().contains(other)
          } else {
            dtaFilteredPosters = posterList
                .where((element) =>
                    element.id.toLowerCase().contains(nameIdBean.id))
                .toList();
            searchPoster = posterList
                .where((element) =>
                    element.id.toLowerCase().contains(nameIdBean.id))
                .toList();
          }
          selectedCategory = int.parse(nameIdBean.id);
          print("Filterd List is${searchPoster.length}");
          setState(() {});
          //Navigator.push(context, MaterialPageRoute(builder: (_)=>BrandFeed(categoryId: nameIdBean.id,displayImage: "none",)));
        },
        selectedColor: _isSelected ? primaryColor : Colors.lightGreenAccent,
      ),
    );
  }

  sendFrameImage(String anShu) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Please wait....');
    var url = Uri.parse(webUrl + "uploadMyimageFrame");
    print(url);
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-type": "multipart/form-data",
      },
      encoding: Encoding.getByName("utf-8"),
      body: jsonEncode(<String, dynamic>{
        "image": anShu,
        'userId': "21",
      }),
    );
    var body = jsonDecode(response.body);
    print(response.body);
    //print(body);
    var msg = body['msg'];

    if (body['status'] == true) {
      var imageName = body['imageName'];
      print("it i9s imageName:" + imageName);
      String path = imageUrl + imageName;
      pd.close();
      await _controller.pause();
      await _renderVideo(path, displayVideo);
    } else {
      pd.close();
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: errorColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    isApiCallingProcess = false;
    setState(() {});
  }

  Future<void> _renderVideo(String frameUrl, String videoUrl) async {
    if (videoUrl == '') {
      videoUrl = vdoUrl + dtaVideo[0]["videopath"];
      setState(() {});
    }
    final FFmpegKit fFmpegKit = FFmpegKit();
    final FFprobeKit fFprobeKit = FFprobeKit();
    try {
      var dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      print("path ${dir?.path}");
      Dio dio = Dio();
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'video rendering....');
      await dio.download(
        videoUrl,
        "${dir?.path}/video.mp4",
        onReceiveProgress: (count, total) {
          print("Rec: ${count.toString()} , Total: $total");
        },
      ).then((value) {
        log('video downloaded ${dir?.path}/video.mp4', name: 'videoStatus');
      });
      await dio.download(
        frameUrl,
        "${dir?.path}/frame.png",
        onReceiveProgress: (count, total) {
          print("Rec: ${count.toString()} , Total: $total");
        },
      ).then((value) {
        log('frame downloaded ${dir?.path}/frame.png', name: 'frameStatus');
      });
      String pathOfVideo = "${dir?.path}/video.mp4";
      String pathOfFrame = "${dir?.path}/frame.png";
      DateTime datetime = DateTime.now();
      final videoInfo = FlutterVideoInfo();
      var info = await videoInfo.getVideoInfo(pathOfVideo);
      String heightOfVideo = info!.height.toString();
      String widthOfVideo = info.width.toString();
      String command =
          ' -i $pathOfVideo -i $pathOfFrame -filter_complex [1]scale=$heightOfVideo:$widthOfVideo[w];[0][w]overlay=5:H-h-5 -preset ultrafast -y ${dir?.path}/output_${datetime.hour.toString()}.mp4';

      await FFmpegKit.execute(command).then((value) async {
        if (Platform.isIOS) {
          log("ios", name: 'kpkpkp');
          File frameFile = File(pathOfFrame);
          File videoFile = File(pathOfVideo);
          File opFile =
              File('${dir?.path}/output_${datetime.hour.toString()}.mp4');

          await frameFile.delete();
          await videoFile.delete();
          await GallerySaver.saveVideo(opFile.path).then(
              (value) => print("gallery video status " + value.toString()));

          log("frame and video file deleted", name: 'fileDelete');
          pd.close();
          await Fluttertoast.showToast(
              msg: 'Video downloaded successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          _shareDialog(opFile.path);
        } else {
          log("andorid", name: 'kpkpkp');
          File frameFile = File(pathOfFrame);
          File videoFile = File(pathOfVideo);
          File opFile =
              File('${dir?.path}/output_${datetime.hour.toString()}.mp4');

          await GallerySaver.saveVideo(opFile.path, albumName: "Download").then(
              (value) => print("gallery video status " + value.toString()));
          await frameFile.delete();
          await videoFile.delete();
          log("frame and video file deleted", name: 'fileDelete');
          pd.close();

          Fluttertoast.showToast(
              msg: 'Video downloaded successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          _shareDialog(opFile.path);
        }
      });

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  void _shareDialog(String path) {
    log(path, name: 'pathShare');
    //File videoFile = File(path);
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Share Video?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await Share.shareFiles([path]);
                      Navigator.pop(context);
                    },
                    child: const Text("Yes")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text("No"))
              ],
            )
          ],
        );
      },
    );
  }
}
