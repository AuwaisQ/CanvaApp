import 'dart:io';
import 'dart:typed_data';

import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/Account.dart';
import 'package:canvas_365/others/Downloads.dart';
import 'package:canvas_365/others/MyColorPicker.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/constants/downloads_directory_type.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'ProgressHud.dart';
class NewCollage extends StatefulWidget {
  String id;
  int numberOfImage=0;
  NewCollage(this.id,this.numberOfImage);
  @override
  _NewCollage createState() =>
      _NewCollage(id, numberOfImage);
}

class _NewCollage extends State<NewCollage>with SingleTickerProviderStateMixin {
  String id;
  int numberOfImage;
  File ?imageFile1,imageFile2,imageFile3,imageFile4,imageFile5;
  File ?imageFile;
  _NewCollage(this.id,this.numberOfImage);

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double? borderWidth=0;
  bool? isBorder=false;
  Color _currentColor = primaryColor;
  Color _currentTextColor = Colors.black;
  final _colorController = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  List<Widget> lstWidget = [Container(color: Colors.amber,)];

  List<dynamic> stLList=[GoogleFonts.oswald(fontStyle: FontStyle.italic,color: Colors.white)];
  int selectedInd=0;
  List<String> lstImage=["frm1.png","frm3.png","frm2.png","frm5.png","frm4.png","frm6.png"];

  dynamic tStyle;
  var temId="none";
  var top = 10.0;
  var left = 10.0;
  // List<dynamic> stLclList=[
  //   GoogleFonts.oswald(fontStyle: FontStyle.italic,color: _currentTextColor)
  //   ,GoogleFonts.poppins(fontStyle: FontStyle.italic,color: _currentTextColor)
  //   ,GoogleFonts.lato(fontStyle: FontStyle.italic,color: _currentTextColor)
  //   ,GoogleFonts.varela(fontStyle: FontStyle.italic,color: _currentTextColor)
  //   ,GoogleFonts.aBeeZee(fontStyle: FontStyle.italic,color: _currentTextColor)
  //   ,GoogleFonts.lato(fontStyle: FontStyle.italic,color: Co_currentTextColor;

  String? categoryId;
  String displayImage = "";
  String displayVideo = "";
  bool isApiCallingProcess = false;
  var url = Uri.parse(webUrl + "posterByCategoryApi");
  var likedImageUrl = Uri.parse(webUrl + "addMyFavouriteImage");
  var data;
  List<dynamic> dta = [];
  List<dynamic> dtaVideo = [];
  List<NameIdBean> posterList = [];
  List<NameIdBean> searchPoster = [];
  List<NameIdBean> videoList = [];
  String msg = "";
  bool sStatus = false;
  String? mobile,businessName;
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
  int haiImage = 0;
  TabController? _tabController;
  // List<String> choices = <String>
  // [
  //   "English",
  //   "Hindi",
  // ];

  //List<String> choices = <String>[];
  List<NameIdBean> choices = <NameIdBean>[];
  List<String> choicesId = <String>[];

  //var lngDta = jsonDecode("{'lang':[{'id':'1','language':'English'},{'id':'2','language':'Hhindi'}]}");

  // print(lngDta.length);

  VideoPlayerController setData(String vUrl) {
    print(vUrl);
    _controller = VideoPlayerController.network(vUrl)
      ..setLooping(true)
      ..setVolume(0);
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
      businessName=prefs.getString('businessName');
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
    setState(() {});
    setState(() {});
    print("Is she subscribe$issubscribed");
    getWidgetData();
  }

  void getBusinessCategory() async {
    print("$url " + categoryId.toString());
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          //'categoryId': categoryId.toString(),
          'categoryId': categoryId.toString(),
        }));
    //print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status) {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["data"];
      dtaVideo = map["videos"];
      if (displayImage == "none") {
        displayImage = dta[0]["imgpath"];
      }
      for (int i = 0; i < dta.length; i++) {
        bool stts = false;
        dta[i]["paid"] == "Free" ? stts = true : stts = false;
        posterList.add(new NameIdBean(dta[i]["id"].toString(),
            dta[i]["language_id"].toString(), dta[i]["imgpath"], stts));
      }

      setState(() {});

      if (dtaVideo.length > 0) {
        videoList = dtaVideo[0]["videopath"];
        for (int i = 0; i < dtaVideo.length; i++) {
          bool stts = false;
          dtaVideo[i]["paid"] == "Free" ? stts = true : stts = false;
          videoList.add(new NameIdBean(dtaVideo[i]["id"].toString(),
              dtaVideo[i]["title"], dtaVideo[i]["videopath"], stts));
        }
      }

      // Map<String, dynamic> maps = json.decode('{"lang":[{"id":"1","language":"English"},{"id":"2","language":"Hhindi"}]}');
      // lnggDta= maps["lang"];
      // print("it le length"+lnggDta.length.toString());
      setState(() {});

      print(dtaVideo.length.toString());
      // setState(()
      // {
      //
      // });
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

  void setLikePoster() async {
    print(displayImage);
    print(userId);
    var response = await http.post(likedImageUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          //'categoryId': categoryId.toString(),
          'userId': userId.toString(),
          'imageName': displayImage,
        }));
    //print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
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
    print("categoryId:$categoryId:displayImage:$displayImage");
    getUserData();
    //isApiCallingProcess=true;
    getBusinessCategory();


    // Map<String, dynamic> maps = json.decode(language_array.toString());
    // lnggDta= maps["lang"];
    //
    // print("it le length"+lnggDta.length.toString());
    // for(int i=0;i<lnggDta.length;i++)
    // {
    //   //choices.add(lnggDta[i]["language"]);
    //   choices.add(new NameIdBean(lnggDta[i]["id"], lnggDta[i]["language"], lnggDta[i]["language"], true));
    //   choicesId.add(lnggDta[i]["id"]);
    // }
    // setState(() {
    //
    // });
    _tabController = new TabController(length: 4, vsync: this);
    _tabController!.addListener(() {
      // setState(() {
      //   _selectedIndex = _controller.index;
      // });
      haiImage = _tabController!.index;
      setState(() {
        haiImage = _tabController!.index;
      });
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
    bool isImage = true;
    VideoPlayerController vpc = setData(displayVideo);
    vpc.play();
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            'Category Poster',
            style: TextStyle(fontFamily: font),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                //final chalega=await Utils.capture(globalkey!,context);
                //final chal=await Utils.save();
                setLikePoster();
              },
              icon: FaIcon(
                FontAwesomeIcons.heart,
                color: Colors.white,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () async {
                final chalega = await Utils.capture(globalkey!, context);
                //final chal=await Utils.save();
              },
              icon: Icon(
                Icons.share,
                size: 20,
              ),
            ),
            PopupMenuButton(
              icon: Icon(Icons.translate_outlined),
              //onSelected: _select,
              padding: EdgeInsets.zero,
              // initialValue: choices[_selection],
              itemBuilder: (BuildContext context) {
                // return choices.map((String choice)
                // {
                //   return  PopupMenuItem<String>(
                //     value: choice,
                //     child: Text(choice),
                //);}
                return choices.map((NameIdBean choice) {
                  return PopupMenuItem<String>(
                    value: choice.id,
                    child: Text(choice.name),
                    onTap: () => {
                      //searchPoster=posterList.where((element) => element.name.contains(choice.id)).toList(),
                      searchPoster = posterList
                          .where((element) => element.name == choice.id)
                          .toList(),
                      setState(() {}),
                      print(choice.id)
                    },
                  );
                }).toList();
              },
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon:
            //     color: Colors.black,
            //   ),
            // ),
            IconButton(
              onPressed: () async {
                isApiCallingProcess = true;
                setState(() {});
                final bs64 = await Utils.captureBase6(globalkey!);
                //print("Now BS6 id"+bs64);
                sendProductImage(bs64);
                // setState(()
                // {
                //   this.byteOne=byteOne;
                // });
                //Navigator.push(context,MaterialPageRoute(builder: (context) => Downloads()));
              },
              icon: Icon(
                Icons.save,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // haiImage==1?
                  // Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 300,
                  //     margin: EdgeInsets.all(10),
                  //     // decoration: BoxDecoration(
                  //     //     color: Colors.white,
                  //     //     borderRadius: BorderRadius.circular(20),
                  //     //     boxShadow: [BoxShadow(
                  //     //         blurRadius: 5,
                  //     //         color: Colors.grey
                  //     //     )
                  //     //     ]
                  //     // ),
                  //     //child: Text(dta[index]["videopath"]),
                  //     child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(15),
                  //         child:
                  //         FittedBox(
                  //           fit: BoxFit.cover,
                  //           child: SizedBox(
                  //             height: 50,
                  //             width: 50,
                  //             child: VideoPlayer(vpc),
                  //           ),
                  //         )
                  //     )):
                  widgetToImage(builder: (key) {
                    this.globalkey = key;
                    return Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: isBorder!?Border.all(color: _currentColor,width: borderWidth!):Border.all(color: _currentColor,width: 0),
                          image: DecorationImage(
                              image: NetworkImage(imgUrl + displayImage),
                              fit: BoxFit.fill)),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          issubscribed!
                              ? Image.network(
                            imgWaterMark,
                            width: 450,
                          )
                              : Container(),
                          GestureDetector(
                            child: Stack(
                              children: [
                                Positioned(
                                    top: top,
                                    left: left,
                                    child: InkWell(
                                      onTap: () => {
                                        // showModalBottomSheet(
                                        //     backgroundColor:
                                        //         Colors.white
                                        //             .withOpacity(0.95),
                                        //     context: context,
                                        //     enableDrag: true,
                                        //     isScrollControlled: true,
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.vertical(
                                        //                 top: Radius
                                        //                     .circular(
                                        //                         25))),
                                        //     builder:
                                        //         (BuildContext context) {
                                        //       return SizedBox(
                                        //         height: 230,
                                        //         child: Container(
                                        //           margin: EdgeInsets.all(10),
                                        //           child: SfSlider(onChanged: (value) {tSize=value;}, value: tSize,
                                        //
                                        //           ),//buildSheet1(context),
                                        //         ),
                                        //       );
                                        //     })
                                      },
                                      //child: Image.network(imageUrl+logo!,width: 80,)))
                                      child: Image.network(
                                        logo != null
                                            ? imageUrl + logo!
                                            : imgAddLogo,
                                        width: 50,
                                      ),
                                    ))
                              ],
                            ),
                            onVerticalDragUpdate: (DragUpdateDetails dd) {
                              setState(() {
                                print(dd);
                                top = dd.localPosition.dy;
                                left = dd.localPosition.dx;
                              });
                            },
                          ),
                          temId!="none"?getCustomTemplate(temId):lstWidget[0],
                          //ats
                          // Container(
                          //   height: 30,
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(color: _currentColor),
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(
                          //         left: 15, right: 10, bottom: 5),
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.end,
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Text(emailAddress!, style: tStyle
                          //             //TextStyle(color: Colors.white, fontSize: 15),
                          //             ),
                          //         Text(mobile!, style: tStyle
                          //             // TextStyle(
                          //             //   color: Colors.white,
                          //             //   fontSize: 14,
                          //             // ),
                          //             )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 25),
                          //   child: Container(
                          //     decoration: const BoxDecoration(
                          //         color: Colors.yellow,
                          //         borderRadius: BorderRadius.only(
                          //             bottomLeft: Radius.circular(10),
                          //             topLeft: Radius.circular(10))),
                          //     height: 35,
                          //     width: 120,
                          //     // child: Row(
                          //     //   mainAxisAlignment: MainAxisAlignment.center,
                          //     //   children: [
                          //     //     Image.asset(
                          //     //       'images/facebook.png',
                          //     //       height: 18,
                          //     //       width: 18,
                          //     //     ),
                          //     //     const SizedBox(width: 10),
                          //     //     Image.asset(
                          //     //       'images/instagram.png',
                          //     //       height: 18,
                          //     //       width: 18,
                          //     //     ),
                          //     //     const SizedBox(width: 10),
                          //     //     Image.asset(
                          //     //       'images/whatsapp.png',
                          //     //       height: 18,
                          //     //       width: 18,
                          //     //     ),
                          //     //   ],
                          //     // ),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  }),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: primaryColor,
                      labelColor: Colors.white,
                      isScrollable: true,

                      unselectedLabelColor: Colors.grey,
                      onTap: (index) {
                        print("selected tab is $index:");
                      },
                      tabs: [
                        Tab(
                          text:"Posts",),//child:Text("Posts", style: TextStyle(fontSize: 12))),
                        Tab(
                          text:"Footer",),//child:Center(child: Text("Footer", style: TextStyle(fontSize: 12)),)),
                        Tab(
                          text:"Backgrounds",),//child: Text("Backgrounds",style: TextStyle(fontSize: 12))),
                        Tab(text:"Text",),
                      ],
                    ),
                  ),
                  Container(
                      height: 350,
                      width: double.infinity,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 5, crossAxisCount: 3),
                              itemBuilder: (context, index) =>
                              searchPoster.isEmpty
                                  ? getCatImage(posterList[index].name,
                                  index, posterList[index].image, false)
                                  : getCatImage(
                                  searchPoster[index].name,
                                  index,
                                  searchPoster[index].image,
                                  false) //posterList[index].status)
                              ,
                              itemCount: searchPoster.isEmpty
                                  ? posterList.length
                                  : searchPoster.length,
                              physics: ScrollPhysics(),
                            ),
                          ),
                          Container(
                              height: 350,
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 1, crossAxisCount: 3),
                                itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // image: DecorationImage(
                                    //     image: NetworkImage(imgUrl + displayImage),
                                    //     fit: BoxFit.cover)
                                    // borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(color: Colors.white)
                                  ),
                                  height: 50,
                                  margin: EdgeInsets.all(5),

                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white)),
                                      alignment: Alignment.bottomCenter,
                                      // color: Colors.green,
                                      child: Image.asset("assets/images/"+lstImage[index]),
                                    ),
                                    onTap: () => {
                                      temId = index.toString(),
                                      print("Tem id is:$temId"),
                                      setState(() {

                                      })
                                      // setState(() {
                                      //   temId = index.toString();
                                      //   print("Tem id is:$temId");
                                      // })
                                    },
                                  ),
                                ) //posterList[index].status)
                                ,
                                itemCount: lstWidget.length,
                                physics: ScrollPhysics(),
                              )),
                          Container(
                              height: 350,
                              child: Center(
                                child:
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(elevation: 5,child: Row(children: [Checkbox(
                                      checkColor: Colors.white,
                                      //fillColor: MaterialStateProperty.resolveWith(primaryColor),
                                      fillColor: MaterialStateProperty.resolveWith((states) => primaryColor),
                                      value: isBorder,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isBorder = value!;
                                        });
                                      },
                                    ),Text("Display border",style: TextStyle(color: primaryColor),),
                                      Slider(
                                        value: borderWidth!,
                                        min: 0,
                                        max: 10,
                                        divisions: 1000,
                                        label: borderWidth.toString(),
                                        onChanged: (double value) {
                                          setState(() {
                                            borderWidth = value;
                                          });
                                        },
                                      ),],),),
                                    CircleColorPicker(
                                      controller: _colorController,
                                      onChanged: (color)
                                      {
                                        setState(() => {
                                          _currentColor = color,
                                          getWidgetData()
                                        });
                                      },
                                      // controller: _colorController,
                                      // onChanged: (color) => print(color),
                                      size: const Size(260, 260),
                                      strokeWidth: 25,
                                      thumbSize: 50,
                                    )],),
                              )),
                          Container(
                              height: 350,
                              child:
                              Column(children: [
                                GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 1,
                                      childAspectRatio: (30 / 10),
                                      crossAxisCount: 4),
                                  itemBuilder: (context, index) => Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.white)),
                                    height: 50,
                                    margin: EdgeInsets.all(2),
                                    child: Center(
                                        child: InkWell(
                                          child:
                                          Text("Can365", style: stList[index]),
                                          onTap: () => {
                                            selectedInd=index,
                                            tStyle = stLList[selectedInd],
                                            setState(() {
                                              getWidgetData();
                                            })
                                          },
                                        )),
                                  ) //posterList[index].status)
                                  ,
                                  itemCount: stList.length,
                                  physics: ScrollPhysics(),
                                ),
                                MyColorPicker(
                                    onSelectColor: (value) {
                                      _currentTextColor = value;
                                      tStyle = stLList[selectedInd];
                                      setState(() {
                                      });
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
                                      Colors.teal
                                    ],
                                    initialColor: Colors.blue)
                              ],)
                          ),
                        ],
                      ))
                ],
              ),
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
            displayImage = posterList[index].image,
            //sStatus=false,
            setState(() {})
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

  Future<void> share(dynamic link, String title) async {
    await FlutterShare.share(
        title: title,
        text: "It is text",
        linkUrl: "link",
        chooserTitle: 'Where you want to share');
  }

  Future<File> writeFile(Uint8List data, String name) async {
    // storage permission ask
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    // the downloads folder path
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => Downloads()));
  }


  // Future.delayed(Duration.zero, () async
  // {
  // myFunction();
  // });

  Widget getCustomTemplate(id)
  {
    // setState(() {
    //
    // });
    switch(id)
    {
      case "0":
        return lstWidget[int.parse(id)];
        //return Container(color: Colors.red,width: 300,height: 300,);
        print("In Switch"+id);
        setState(() {

        });
        break;
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

      default:
        return Container(color: Colors.black,width: 300,height: 300,);
    }
  }

  getWidgetData() {
    setState(() {});
    stLList.clear();
    stLList = [
      GoogleFonts.oswald(fontStyle: FontStyle.italic, color: _currentTextColor,fontSize: 12),
      GoogleFonts.poppins(fontStyle: FontStyle.italic, color: _currentTextColor,fontSize: 12),
      GoogleFonts.lato(fontStyle: FontStyle.italic, color: _currentTextColor,fontSize: 12),
      GoogleFonts.varela(fontStyle: FontStyle.italic, color: _currentTextColor,fontSize: 12),
      GoogleFonts.aBeeZee(fontStyle: FontStyle.italic, color: _currentTextColor,fontSize: 12),
      GoogleFonts.lato(fontStyle: FontStyle.italic, color: _currentTextColor,fontSize: 12),
      GoogleFonts.amaranth(fontStyle: FontStyle.normal, color: _currentTextColor,fontSize: 12),
      GoogleFonts.artifika(fontStyle: FontStyle.normal, color: _currentTextColor,fontSize: 12),
      GoogleFonts.bentham(fontStyle: FontStyle.normal, color: _currentTextColor,fontSize: 12),
      GoogleFonts.bangers(fontStyle: FontStyle.normal, color: _currentTextColor,fontSize: 12),
      GoogleFonts.boogaloo(fontStyle: FontStyle.normal, color: _currentTextColor,fontSize: 12),
      GoogleFonts.condiment(fontStyle: FontStyle.normal, color: _currentTextColor,fontSize: 12),
    ];

    lstWidget.clear();
    lstWidget = [
      ///1ST FOOTER
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _currentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)), //BorderRadius.circular(10),
              //border: Border.all(color: Colors.white)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on,size: 15,color: _currentTextColor,),
                SizedBox(width: 5,),
                Text(
                  address!,
                  style: TextStyle(color: _currentTextColor, fontSize: 14),
                ),
              ],
            ),
          ),
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
                  ///Mobile Number
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 12,
                        color: _currentTextColor,
                      ),
                      SizedBox(width: 3,),
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
                      SizedBox(width: 3,),
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
      ///2nd Footer
      Stack(
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
                color: _currentColor, borderRadius: BorderRadius.circular(50)),
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
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(50)),
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
      ///3rd Footer
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 47,right: 15),
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
              padding: const EdgeInsets.only(bottom: 25, left: 25,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Mobile Number
                  Row(children: [
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ///Address
              Row(children: [
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
        ],
      ),
      ///4th Footer
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
                  Row(
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
                ],
              ),
            ),
          )
        ],
      ),
      ///5th Footer
      FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius:
                  BorderRadius.only(topRight: Radius.circular(10))),
              child: FittedBox(
                fit: BoxFit.none,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Email Address
                    Row(
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
                    ///Address
                    Row(
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
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  businessName!, style: tStyle,
                  // style: TextStyle(color: _currentTextColor, fontSize: 14.),
                ),
                SizedBox(height: 2,),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                  ),
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
              ],
            ),
          ],
        ),
      ),
      ///6th Footer
      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.red),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.mail,
                          size: 15,
                          color: _currentTextColor,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          emailAddress!,
                          style: tStyle,
                        ),
                      ],
                    ),
                    ///Address
                    Row(
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
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: 100,
                decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 15,
                      color: _currentTextColor,
                    ),
                    Text(
                      mobile!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: tStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ///7th Footer
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      height: 3,
                      width: 15,
                      decoration: BoxDecoration(color: _currentColor),
                    ),
                    Image.asset(
                      'assets/images/phone.png',
                      color: _currentColor,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      mobile!,
                      style: tStyle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 4,
                      width: 15,
                      decoration: BoxDecoration(color: _currentColor),
                    ),
                    Image.asset(
                      'assets/images/mail.png',
                      color: _currentColor,
                      height: 21,
                      width: 21,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      emailAddress!,
                      style: tStyle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 4,
                      width: 15,
                      decoration: BoxDecoration(color: _currentColor),
                    ),
                    Image.asset(
                      'assets/images/location.png',
                      color: _currentColor,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      address!,
                      textAlign: TextAlign.center,
                      style: tStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ///8th Footer
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
        ],
      ),
      ///9th Footer
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
              child:
              Row(
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
        ],
      ),
      ///10th Footer
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
                // Container(
                //   height: 25,
                //   width: MediaQuery.of(context).size.width / 3.1,
                //   decoration: BoxDecoration(color: Colors.blue.shade900),
                //   child: FittedBox(
                //     fit: BoxFit.none,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(
                //           'assets/images/web.png',
                //           color: _currentTextColor,
                //           height: 15,
                //           width: 15,
                //         ),
                //         SizedBox(width: 2.w),
                //         Text(
                //           businessName!,
                //           style: tStyle,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
        ],
      ),
      ///11th Footer
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
                    decoration:
                    BoxDecoration(border: Border.all(color: _currentColor)),
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
                    decoration:
                    BoxDecoration(border: Border.all(color: _currentColor)),
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
      ///12th Footer
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
                  decoration:
                  BoxDecoration(border: Border.all(color: _currentColor)),
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
                  decoration:
                  BoxDecoration(border: Border.all(color: _currentColor)),
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
        ],
      ),
      ///13th Footer
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
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: const Color(0xff666633),
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(20),
                  //           bottomRight: Radius.circular(20))),
                  //   height: 25,
                  //   width: MediaQuery.of(context).size.width / 3,
                  //   child: FittedBox(
                  //     fit: BoxFit.none,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         Image.asset(
                  //           'assets/images/web.png',
                  //           color: _currentTextColor,
                  //           height: 13,
                  //           width: 13,
                  //         ),
                  //         SizedBox(
                  //           width: 5,
                  //         ),
                  //         Text(
                  //           businessName!,
                  //           style: tStyle,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
        ],
      ),
      ///14th Footer
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
                          bottomLeft: Radius.circular(40)
                      )),
                  child: FittedBox(
                    fit: BoxFit.none,
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
              ],
            ),
          ),
        ],
      ),
    ];
    setState(() {});
  }

}
