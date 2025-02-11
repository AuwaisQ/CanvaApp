import 'dart:convert';
import 'dart:io';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/Downloads.dart';
import 'package:canvas_365/others/MyColorPicker.dart';
import 'package:canvas_365/pages/CaptureImagePage.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomsImage extends StatefulWidget
{
  @override
  State<CustomsImage> createState() => _CustomImageState();
}

enum AppState {
  free,
  picked,
  change,
}

class _CustomImageState extends State<CustomsImage> with WidgetsBindingObserver ,SingleTickerProviderStateMixin
{
  late AppState state = AppState.free;
  bool isApiCallingProcess = false;
  GlobalKey? globalkey;
  bool isProfileUpdate = false;
  bool isCustomFrame = false;
  String? userId;
  String? mobile,businessName;
  String? address;
  String? emailAddress;
  String? logo;
  bool? issubscribed;
  File? imageFile;
  String tText="Type Here";
  bool isText=true;
  bool isBorder=false;
  var top = 10.0;
  var left = 10.0;

  var ttop = 20.0;
  var lleft = 250.0;

  double tSize=15;
  String font = "Select Font";
  var url = Uri.parse(webUrl+"background");

  double? borderWidth=0;

  Color _currentColor = primaryColor;
  Color _currentTextColor = Colors.black;
  final _colorController = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  List<Widget> lstWidget = [];
  List<dynamic> stLList=[GoogleFonts.oswald(fontStyle: FontStyle.italic,color: Colors.white)];
  int selectedInd=0;
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
  var temId="none";

  // Color pickerColor = Color(0xffff7686);
  // Color changeColor = Color(0xffb83bf1);
  String backgroundImg="";
  CameraController? _controller;
  Future<void>? _initController;
  var isCameraReady = false;
  //XFile ?imageFile;
  File? fle;
  List<XFile> images = [];
  List<String> imags = [];
  List<String> fontList=["Varela","Poppinsregular","Prompt","Heebo"];
  TextEditingController textController=new TextEditingController();
  Color currentColor = Colors.amber;
  var frameViewUrl = Uri.parse(webUrl + "getCustomFrame");
  List<dynamic> dtaFrameCategory = [];
  String customFrame = "none_custom_image.png";
  List<NameIdBean> dtaFrameCategoryList = [];
  void changeColor(Color color) => setState(() => currentColor = color);
  var data;
  List<dynamic> dta=[];
  List<NameIdBean> bData=[];
  TabController? _tabController;
  @override
  void initState() {
    // textController.addListener(()
    // {
    //   tText=textController.text;
    // });

    _tabController = new TabController(length: 4, vsync: this);
    _tabController!.addListener(() {
      // setState(() {
      //   _selectedIndex = _controller.index;
      // });
      // haiImage = _tabController!.index;
      // setState(() {
      //   haiImage = _tabController!.index;
      // });
      // print("Now Selected Index: " + haiImage.toString());
    });

    WidgetsBinding.instance.addObserver(this);
    initCamera();
    getUserData();
    //getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess);
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
      businessName = prefs.getString('businessName');
    }
    setState(() {});
    print("Is she subscribe$issubscribed");
    getBackgroundImage();
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
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
    print(data);
    // var status = data['status'];
    // var msg = data['msg'];
    // print(status);
    // if (status) {
    Map<String, dynamic> map = json.decode(response.body);
    dtaFrameCategory = map["customframe"];
    customFrame = dtaFrameCategory[0]["frame"];
    for (int i = 0; i < dtaFrameCategory.length; i++) {
      //dta[i]["paid"]=="Free"?stts=true:stts=false;
      dtaFrameCategoryList.add(new NameIdBean(
          dtaFrameCategory[i]["id"].toString(),
          dtaFrameCategory[i]["frame"],
          dtaFrameCategory[i]["frame"],
          true));
    }
    // for(int i=0;i<dta.length;i++)
    // {
    //   bool stts=false;
    //   //dta[i]["paid"]=="Free"?stts=true:stts=false;
    //   posterList.add(new NameIdBean(dta[i]["subcategoryid"].toString(), dta[i]["image"], dta[i]["image"], true));
    // }

    //setState(() {});

    // if (dtaVideo.length > 0)
    // {
    //   //videoList = dtaVideo[0]["videopath"];
    //   for (int i = 0; i < dtaVideo.length; i++) {
    //     bool stts = false;
    //     dtaVideo[i]["paid"] == "Free" ? stts = true : stts = false;
    //     videoList.add(new NameIdBean(dtaVideo[i]["id"].toString(),dtaVideo[i]["video_image"], dtaVideo[i]["videopath"], stts));
    //   }
    // }

    print("fRAMElIST Data Length:" + dtaFrameCategoryList.toString());
    //getWidgetData();
    setState(() {});
    // } else {
    //   //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
    //   Fluttertoast.showToast(
    //       msg: msg,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
    isApiCallingProcess = false;
    setState(() {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
    //getMyFrame();
  }

  void getBackgroundImage() async
  {
    isApiCallingProcess=true;
    print(url);
    var response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // var response = await http.post(url,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>
    //   {
    //     'userId': userId.toString(),
    //     'bcategoryId':businessId.toString()
    //     //'bcategoryId':"40"
    //   }
    //   ),);
    print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"language":"\u0a2a\u0a70\u0a1c\u0a3e\u0a2c\u0a40","defaultlang":"false"},{"id":3,"language":"\u0ba4\u0bae\u0bbf\u0bb4\u0bcd","defaultlang":"false"},{"id":4,"language":"\u0d2e\u0d32\u0d2f\u0d3e\u0d33\u0d02","defaultlang":"false"},{"id":5,"language":"Italia","defaultlang":"false"},{"id":6,"language":"\u0939\u093f\u0902\u0926\u0940","defaultlang":"false"},{"id":7,"language":"English","defaultlang":"true"}],"status":true,"msg":"success"}');
    //print(data);
    var status = data['status'];
    var msg = data['msg'];
    //issubscribed=data['issubscribed'];
    //setIsSubscribed(issubscribed);
    print(status);
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      dta=map["list"];
      //dtaSelectedCategory=map["slider"];
      print("Startup Poster:"+dta.length.toString());
      print(dta.length.toString());
      //for(int i=0;i<dta.length;i++)
      for(int i=0;i<dta.length;i++)
      {
        bData.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["image"].toString(), dta[i]["image"].toString(), true));
      }
      // print(dtaGretrings.length.toString());
      // for(int i=0;i<dtaGretrings.length;i++)
      // {
      //   dtaSelectedGreetingposter.add(new NameIdBean(dtaGretrings[i]["gsubcategoryid"].toString(), dtaGretrings[i]["image"].toString(), "", true));
      // }

      setState(()
      {
        //getProfileStatus();
      });
    } else
    {
      //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(()
      {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      });
    }
    isApiCallingProcess=false;
    setState(() {

    });
  }

  @override
  Widget build_ui(BuildContext context) {
    bool isImage = true;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () {
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
            //                         10))),
            //     builder:
            //         (BuildContext context) {
            //       return SizedBox(
            //         height: 120,
            //         child: Container(
            //           margin: EdgeInsets.all(10),
            //           child: ListView(children: [
            //             ListTile(tileColor: Colors.black12, leading: Icon(Icons.camera_alt),title: Text("Camera"),trailing: Icon(Icons.radio_button_unchecked_sharp),onTap: ()=>_navigateAndDisplaySelection(context),),
            //             SizedBox(height: 5,),
            //             ListTile(tileColor: Colors.black12, leading: Icon(Icons.photo_album_rounded),title: Text("Gallery"),trailing: Icon(Icons.radio_button_unchecked_sharp),onTap:_pickImage,)
            //           ],
            //
            //             ),
            //           ),//buildSheet1(context),
            //       );
            //     });
            if (state == AppState.free)
              getImage();
            else
              backgroundImg="null";
            setState((){});
          },
          child: _buildButtonIcon(),
        ),
        bottomNavigationBar: BottomAppBar(
          color: backgroundColor,
          child: Card(
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () =>
                    {
                      isText=true,
                      // if(isText)
                      //   {
                      //     isText=false,
                      //   }else
                      //   {
                      //     isText=true,
                      //   },
                      setState((){

                      })
                    },
                    icon: Icon(
                      Icons.text_fields,
                      color: !isText?Colors.grey:primaryColor,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                    {
                      // if(isText)
                      //   {
                      isText=false,
                      //   }else
                      //   {
                      //     isText=true,
                      //   },
                      setState((){
                        getWidgetData();
                      })
                    },
                    icon: Icon(
                      Icons.photo_album_rounded,
                      color: isText?Colors.grey:primaryColor,
                      size: 40,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () => {},
                  //   icon: Icon(
                  //     Icons.face,
                  //     color: primaryColor,
                  //     size: 40,
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () => {
                      showModalBottomSheet(
                          backgroundColor:
                          Colors.white
                              .withOpacity(0.95),
                          context: context,
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(
                                  top: Radius
                                      .circular(
                                      10))),
                          builder:
                              (BuildContext context) {
                            return SizedBox(
                              height: 420,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child:Container(
                                    child: GridView.builder(scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisSpacing: 5,
                                            crossAxisCount: 5),
                                        itemBuilder: (context, index)=>InkWell(
                                          onTap: ()=>{
                                            backgroundImg=bData[index].image,
                                            setState(() {})
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        imageUrl+bData[index].image),fit: BoxFit.cover),
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
                                        )//posterList[index].status)
                                        ,itemCount: bData.length
                                    )

                                ),
                              ),//buildSheet1(context),
                            );
                          })
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ],
              )),
        ),
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
            'Custom Image',
            style: TextStyle(fontFamily: "Poppinsregular"),
          ),
          actions: [
            // IconButton(
            //   onPressed: ()async
            //   {
            //     //final chalega=await Utils.capture(globalkey!,context);
            //     //final chal=await Utils.save();
            //     setLikePoster();
            //   },
            //   icon: FaIcon(FontAwesomeIcons.heart,color: Colors.white,size: 20,),
            // ),
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
            // PopupMenuButton(
            //   icon: Icon(
            //       Icons.translate_outlined),
            //   //onSelected: _select,
            //   padding: EdgeInsets.zero,
            //   // initialValue: choices[_selection],
            //   itemBuilder: (BuildContext context) {
            //     return choices.map((String choice) {
            //       return  PopupMenuItem<String>(
            //         value: choice,
            //         child: Text(choice),
            //       );}
            //     ).toList();
            //   },
            // ),
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
                  widgetToImage(builder: (key)
                  {
                    this.globalkey = key;
                    return Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Positioned(
                                top: 0,
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),),
                                  height: MediaQuery.of(context).size.width,
                                  width: MediaQuery.of(context).size.width,
                                  child: imageFile != null
                                      ? PhotoView(
                                    imageProvider: FileImage(imageFile!),
                                    //     ExtendedImage.file(imageFile!,
                                    //     // width: ScreenUtil.instance.setWidth(400),
                                    //     // height: ScreenUtil.instance.setWidth(400),
                                    //     fit: BoxFit.cover,
                                    //     // cache: true,
                                    //     // border: Border.all(color: Colors.red, width: 1.0),
                                    //     // shape: boxShape,
                                    //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    //     //cancelToken: cancellationToken,
                                  )
                                      : Container(                          //               decoration: BoxDecoration(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        // colorFilter: ColorFilter.mode(
                                        //     Colors.white.withOpacity(0.3),
                                        //     BlendMode.dstATop),
                                        //if(logo!=null){image: }
                                        image: backgroundImg!=null?NetworkImage(imageUrl+backgroundImg):NetworkImage('https://canva365.com/img/none.png',
                                        ),
                                      ),
                                    ),),
                                ),
                              ),
                              !issubscribed!
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
                                                : "https://canva365.com/img/none.png",
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
                              isText==false?Container():GestureDetector(
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: ttop,
                                        left: lleft,
                                        child: InkWell(
                                            onTap: () => {

                                            },
                                            child: Text(
                                              tText,
                                              style: TextStyle(color: currentColor,fontSize: tSize,fontFamily: font),
                                              //style: TextStyle(color: currentColor,fontSize: tSize,fontFamily: font),
                                            )))
                                  ],
                                ),
                                onVerticalDragUpdate: (DragUpdateDetails dd) {
                                  setState(() {
                                    print(dd);
                                    ttop = dd.localPosition.dy;
                                    lleft = dd.localPosition.dx;
                                  });
                                },
                              ),
                              temId!="none"?getCustomTemplate(temId):Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    height: 20,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),//BorderRadius.circular(10),
                                      //border: Border.all(color: Colors.white)
                                    ),


                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15, right: 10, bottom: 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "email",
                                            // style: TextStyle(
                                            //     color: Colors.white, fontSize: 15.sp),
                                          ),
                                          Text(
                                            "mobile",
                                            // style: TextStyle(
                                            //   color: Colors.white,
                                            //   fontSize: 14.sp,
                                            // ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              topLeft: Radius.circular(5))),
                                      height: 25,
                                      width: 80,
                                    ),
                                  ),
                                ],
                              ),

                              // CarouselSlider(
                              //   items: <Widget>[
                              //     ///1st Container
                              //     Column(
                              //       crossAxisAlignment: CrossAxisAlignment.end,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: [
                              //         Row(
                              //           mainAxisAlignment: MainAxisAlignment
                              //               .spaceBetween,
                              //           children: [
                              //             Container(
                              //               margin: EdgeInsets.all(7),
                              //               height: 60,
                              //               width: 60,
                              //               decoration: BoxDecoration(
                              //                 image: new DecorationImage(
                              //                   fit: BoxFit.cover,
                              //                   // colorFilter: ColorFilter.mode(
                              //                   //     Colors.white.withOpacity(0.3),
                              //                   //     BlendMode.dstATop),
                              //                   //if(logo!=null){image: }
                              //                   image: logo!=null?NetworkImage(imageUrl+logo!):NetworkImage('https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png',
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             issubscribed==true?Container(
                              //               height: 250,
                              //               width: 250,
                              //               decoration: BoxDecoration(
                              //                 image: new DecorationImage(
                              //                   fit: BoxFit.cover,
                              //                   image: new NetworkImage(
                              //                     imgUrl+'logo.png',
                              //                   ),
                              //                 ),
                              //               ),
                              //             ):
                              //             Container(
                              //             )
                              //           ],
                              //         ),
                              //         Container(
                              //           height: 50,
                              //           width: 300,
                              //           decoration: BoxDecoration(
                              //               image: DecorationImage(
                              //                   image: AssetImage(
                              //                       'assets/images/frame1.png'),
                              //                   fit: BoxFit.fitWidth)),
                              //           child: Column(
                              //             children: [
                              //               Padding(
                              //                 padding:
                              //                 const EdgeInsets.only(
                              //                     left: 25, top: 2),
                              //                 child: Row(
                              //                   mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //                   children: [
                              //                     Text(
                              //                       '+91 $mobile',
                              //                       style: TextStyle(
                              //                           color: Colors.white,
                              //                           fontSize: 9,
                              //                           fontWeight: FontWeight
                              //                               .bold),
                              //                     ),
                              //                     SizedBox(
                              //                       width: 20,
                              //                     ),
                              //                     Text(
                              //                       '$emailAddress',
                              //                       style: TextStyle(
                              //                           color: Colors.white,
                              //                           fontSize: 10,
                              //                           fontWeight: FontWeight
                              //                               .bold),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //
                              //               ///2nd Row
                              //               Padding(
                              //                 padding:
                              //                 EdgeInsets.only(right: 35, top: 12),
                              //                 child: Row(
                              //                   mainAxisAlignment: MainAxisAlignment
                              //                       .end,
                              //                   children: [
                              //                     Text(
                              //                       '$emailAddress',
                              //                       style: TextStyle(
                              //                           color: Colors.white,
                              //                           fontSize: 10),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //
                              //     ///2nd Container
                              //     Column(
                              //       mainAxisSize: MainAxisSize.max,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: [
                              //         issubscribed==false?Container(
                              //           height: 50,
                              //           width: 50,
                              //           decoration: BoxDecoration(
                              //             image: new DecorationImage(
                              //               fit: BoxFit.cover,
                              //               colorFilter: ColorFilter.mode(
                              //                   Colors.white.withOpacity(0.5),
                              //                   BlendMode.dstATop),
                              //               image: new NetworkImage(
                              //                 imgUrl+'logo.png',
                              //               ),
                              //             ),
                              //           ),
                              //         ):Container(),
                              //         Container(
                              //           height: 30,
                              //           width: 300,
                              //           decoration: BoxDecoration(
                              //               image: DecorationImage(
                              //                   image: AssetImage(
                              //                       'assets/images/frame2.png'),
                              //                   fit: BoxFit.fitWidth)),
                              //           child: Padding(
                              //             padding:
                              //             const EdgeInsets.only(
                              //                 left: 37, bottom: 1),
                              //             child: Row(
                              //               mainAxisAlignment: MainAxisAlignment
                              //                   .center,
                              //               children: [
                              //                 Text(
                              //                   '+91 $mobile',
                              //                   style: TextStyle(
                              //                       color: Colors.white,
                              //                       fontSize: 9,
                              //                       fontWeight: FontWeight.bold),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //
                              //     ///3rd Container
                              //     Column(
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       mainAxisAlignment: MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         issubscribed==false?Container(
                              //           height: 50,
                              //           width: 50,
                              //           decoration: BoxDecoration(
                              //             image: new DecorationImage(
                              //               fit: BoxFit.cover,
                              //               colorFilter: ColorFilter.mode(
                              //                   Colors.white.withOpacity(0.5),
                              //                   BlendMode.dstATop),
                              //               image: new NetworkImage(
                              //                 imgUrl+'logo.png',
                              //               ),
                              //             ),
                              //           ),
                              //         ):Container(),
                              //         Container(
                              //           height: 55,
                              //           width: 300,
                              //           decoration: BoxDecoration(
                              //               image: DecorationImage(
                              //                   image: AssetImage(
                              //                       'assets/images/frame3.png'),
                              //                   fit: BoxFit.fitWidth)),
                              //           child: Padding(
                              //             padding:
                              //             const EdgeInsets.only(left: 19, top: 9),
                              //             child: Column(
                              //               crossAxisAlignment: CrossAxisAlignment
                              //                   .start,
                              //               children: [
                              //                 Text(
                              //                   '+91 $mobile',
                              //                   style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontSize: 8,
                              //                       fontWeight: FontWeight.bold),
                              //                 ),
                              //                 SizedBox(
                              //                   height: 4,
                              //                 ),
                              //                 Text(
                              //                   '$address',
                              //                   style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontSize: 8,
                              //                       fontWeight: FontWeight.bold),
                              //                 ),
                              //                 SizedBox(
                              //                   height: 4,
                              //                 ),
                              //                 Text(
                              //                   'Ujjain (M.P.)',
                              //                   style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontSize: 8,
                              //                       fontWeight: FontWeight.bold),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ],
                              //   options: CarouselOptions(
                              //       height: double.infinity,
                              //       enableInfiniteScroll: false,
                              //       enlargeCenterPage: true,
                              //       viewportFraction: 1)),
                            ]));
                  }),
                  SizedBox(height: 10,),
                  isText?Card(elevation: 5,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [new BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4),],
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            onChanged: (text)
                            {
                              tText = text;
                              setState((){

                              });
                            },
                            controller: textController,
                            cursorColor: Colors.black,
                            validator: (value){
                              if(value!.isEmpty)
                              {
                                return 'Set text';
                              }
                              return null;
                            },
                            decoration:
                            new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.grey,size: 24,),
                                // contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                                hintText: "Title",
                                hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 14)
                            ),
                          ),
                        ),

                        //Text("Change Color",style: TextStyle(fontSize: 14),),
                        //Text("Text Size",style: TextStyle(fontSize: 14),),
                        Row(
                          children: [
                            Slider(
                              value: tSize,
                              min: 10,
                              max: 75,
                              divisions: 100,
                              label: tSize.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  tSize = value;
                                });
                              },
                            ),
                          ],
                        ),
                        // Container(
                        //   alignment: Alignment.bottomRight,
                        //   padding: EdgeInsets.only(left: 35),
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        //   height: 50,
                        //   child: DropdownButton(
                        //       underline: SizedBox(),
                        //       icon: Icon(Icons.arrow_drop_down),
                        //       iconSize: 24,
                        //       value: font,
                        //       items: [
                        //         DropdownMenuItem(
                        //           child: Text("Select Font"),
                        //           value: "Select Font",
                        //         ),
                        //
                        //         DropdownMenuItem(
                        //           child: Text("Varela"),
                        //           value: "Varela",
                        //         ),
                        //         DropdownMenuItem(
                        //             child: Text("Poppinsregular",style: TextStyle(fontFamily: 'Poppinsregular'),),
                        //             value: "Poppinsregular"
                        //         ),
                        //         DropdownMenuItem(
                        //             child: Text("Prompt",style: TextStyle(fontFamily: 'Prompt')),
                        //             value: "Prompt"
                        //         ),
                        //         DropdownMenuItem(
                        //             child: Text("Heebo",style: TextStyle(fontFamily: 'Heebo')),
                        //             value: "Heebo"
                        //         ),
                        //       ],
                        //       onChanged: (value) {
                        //         setState(() {
                        //           font = value.toString();
                        //           print(font);
                        //         });
                        //       }),
                        // ),
                        Container(
                          margin: EdgeInsets.only(left: 5,right: 5),
                          // decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //     border: Border.all(color: Colors.black)),
                          child: GridView.builder(
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
                                  border: Border.all(color: Colors.black)),
                              height: 50,
                              margin: EdgeInsets.all(2),
                              child: Center(
                                  child: InkWell(
                                    child:
                                    Text("Can365", style: TextStyle(fontFamily: fontList[index],color: Colors.black)),
                                    onTap: () => {
                                      //selectedInd=index,
                                      font = fontList[index],
                                      setState(() {
                                        //getWidgetData();
                                      })
                                    },
                                  )),
                            ) //posterList[index].status)
                            ,
                            itemCount: fontList.length,
                            physics: ScrollPhysics(),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child: MyColorPicker(
                              onSelectColor: (value) {
                                setState(()
                                {
                                  currentColor = value;
                                });
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
                              initialColor: Colors.blue),
                        )
                      ],
                    ),
                  ):Container(child: Column(children: [
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
                          setState(() => getWidgetData()
                          );
                        },
                        tabs: [
                          Tab(
                            text:"Footer",),//child:Center(child: Text("Footer", style: TextStyle(fontSize: 12)),)),
                          Tab(
                            text:"My Frame",),//child:Center(child: Text("Footer", style: TextStyle(fontSize: 12)),)),
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
                                height: 350,
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 1, crossAxisCount: 3),
                                  itemBuilder: (context, index) =>
                                      Container(
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
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border:
                                                Border.all(color: Colors.white)),
                                            alignment: Alignment.bottomCenter,
                                            // color: Colors.green,
                                            child: Image.asset(
                                                "assets/images/" + lstImage[index]),
                                          ),
                                          onTap: () => {
                                            temId = index.toString(),
                                            print("Tem id is:$temId"),
                                            setState(() {})
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
                                    false) //getCatImage(posterList[index].name,index, posterList[index].image, false)
                                //     : getCatImage(searchPoster[index].name,index,searchPoster[index].image,
                                //     false) //posterList[index].status)

                                // searchPoster.isEmpty
                                //     ? dtaFilteredPosters.isNotEmpty?getCatImage(dtaFilteredPosters[index].name,index,dtaFilteredPosters[index].image,false)
                                //     :getCatImage(posterList[index].name,index,posterList[index].image,false)//getCatImage(posterList[index].name,index, posterList[index].image, false)
                                //     : getCatImage(searchPoster[index].name,index,searchPoster[index].image,
                                //     false) //posterList[index].status)
                                ,
                                itemCount: dtaFrameCategoryList.length,
                                physics: ScrollPhysics(),
                              ),
                            ),
                            Container(
                                height: 350,
                                child: Center(
                                  child:
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Card(elevation: 5,child: Row(children: [Checkbox(
                                      //   checkColor: Colors.white,
                                      //   //fillColor: MaterialStateProperty.resolveWith(primaryColor),
                                      //   fillColor: MaterialStateProperty.resolveWith((states) => primaryColor),
                                      //   value: isBorder,
                                      //   onChanged: (bool? value) {
                                      //     setState(() {
                                      //       isBorder = value!;
                                      //     });
                                      //   },
                                      // ),Text("Border",style: TextStyle(color: primaryColor),),
                                      //   Slider(
                                      //     value: borderWidth!,
                                      //     min: 0,
                                      //     max: 10,
                                      //     divisions: 100,
                                      //     label: borderWidth.toString(),
                                      //     onChanged: (double value) {
                                      //       setState(() {
                                      //         borderWidth = value;
                                      //       });
                                      //     },
                                      //   ),],),),
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
                        )),
                  ],),),

                ],
              ),
            ),
          ),
        ));
  }

  // Future<void> share(dynamic link,String title) async{
  //   await FlutterShare.share(
  //       title: title,text:"It is text",linkUrl:"link",chooserTitle: 'Where you want to share'
  //   );
  // }

  // Future<File> writeFile(Uint8List data, String name) async
  // {
  //   // storage permission ask
  //   // var status = await Permission.storage.status;
  //   // if (!status.isGranted) {
  //   //   await Permission.storage.request();
  //   // }
  //   // the downloads folder path
  //   Directory? tempDir = await PathDownload().pathDownload(TypeFileDirectory.pictures);
  //   String tempPath = tempDir!.path;
  //   var filePath = tempPath + '/$name';
  //   //
  //   // the data
  //   var bytes = ByteData.view(data.buffer);
  //   final buffer = bytes.buffer;
  //   // save the data in the path
  //   return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  // }

  sendProductImage(String anShu) async {
    var url = Uri.parse(webUrl + "uploadMyimage");
    print("anshu Imaget Image" + anShu);
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

  //
  // void setLikePoster() async
  // {
  //   print(userId);
  //   var response = await http.post(likedImageUrl,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },body: jsonEncode(<String, String>
  //       {
  //         //'categoryId': categoryId.toString(),
  //         'userId': userId.toString(),
  //         'imageName': displayImage,
  //       }));
  //   //print(response.body);
  //   data = jsonDecode(response.body);
  //   //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
  //   print(data);
  //   var status = data['status'];
  //   var msg = data['msg'];
  //   print(status);
  //   if (status)
  //   {
  //     Fluttertoast.showToast(
  //         msg: "Successfully added in wishlist",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: successColor,
  //         textColor: Colors.white,
  //         fontSize: 16.0
  //     );
  //   }
  //   else
  //   {
  //     //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
  //     Fluttertoast.showToast(
  //         msg: msg,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0
  //     );
  //   }
  //   isApiCallingProcess=false;
  //   setState(()
  //   {
  //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  //   });
  // }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    // else if (state == AppState.change)
    //   return Icon(Icons.image);
    else
      return Icon(Icons.image);
  }

  Future<Null> _pickImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
    Navigator.pop(context);
  }

  Future<Null> _captureImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.camera);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
    Navigator.pop(context);
  }

  // Future<Null> _clickImage() async
  // {
  //   final pickedImage =
  //   await ImagePicker().getImage(source: ImageSource.camera);
  //   imageFile = pickedImage != null ? File(pickedImage.path) : null;
  //   if (imageFile != null) {
  //     setState(() {
  //       state = AppState.picked;
  //     });
  //   }
  // }

  initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initController = _controller!.initialize();
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  Widget buildSheet1(context) => Column(crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text("Size",style: TextStyle(fontSize: 20),),
        Slider(
          value: tSize,
          min: 0,
          max: 100,
          divisions: 5,
          label: tSize.round().toString(),
          onChanged: (double value) {
            setState(() {
              tSize = value;
            });
          },
        )
        // Slider(min: 10,max: 30,value:tSize,
        //   onChanged: (double value) {
        //   setState(() {
        //     tSize=value;
        //   });
        // },)
      ]);

  // captureImage(BuildContext context)
  // {
  //   _controller!.takePicture().then((file) =>
  //   {
  //     setState(()
  //     {
  //       imageFile=file;
  //       // images.add(file);
  //       // imags.add(file.path);
  //     }),
  //     //imageFile:file,
  //     if(mounted)
  //       {
  //         //Navigator.push(context, MaterialPageRoute(builder: (_)=>displayPictureScreen(image: imageFile,)))
  //       }
  //   });
  // }

  void _navigateAndDisplaySelection(BuildContext context) async
  {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) =>  CaptureImagePage()),
    );
    String imgFile=result.toString();
    imageFile=File(imgFile);
    setState(() {
    });
    Navigator.pop(context);
  }

  getImage()
  {
    showModalBottomSheet(
        backgroundColor:
        Colors.white
            .withOpacity(0.95),
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(
                top: Radius
                    .circular(
                    10))),
        builder:
            (BuildContext context) {
          return SizedBox(
            height: 120,
            child: Container(
              margin: EdgeInsets.all(10),
              child: ListView(children: [
                ListTile(tileColor: Colors.black12, leading: Icon(Icons.camera_alt),title: Text("Camera"),trailing: Icon(Icons.radio_button_unchecked_sharp),onTap: ()=>_navigateAndDisplaySelection(context),),
                SizedBox(height: 5,),
                ListTile(tileColor: Colors.black12, leading: Icon(Icons.photo_album_rounded),title: Text("Gallery"),trailing: Icon(Icons.radio_button_unchecked_sharp),onTap:_pickImage,)
              ],

              ),
            ),//buildSheet1(context),
          );
        });
  }
  getWidgetData() {
    setState(() {});
    stLList.clear();
    stLList = [
      GoogleFonts.oswald(fontStyle: FontStyle.italic, color: _currentTextColor),
      GoogleFonts.poppins(
          fontStyle: FontStyle.italic, color: _currentTextColor),
      GoogleFonts.lato(fontStyle: FontStyle.italic, color: _currentTextColor),
      GoogleFonts.varela(fontStyle: FontStyle.italic, color: _currentTextColor),
      GoogleFonts.aBeeZee(
          fontStyle: FontStyle.italic, color: _currentTextColor),
      GoogleFonts.lato(fontStyle: FontStyle.italic, color: _currentTextColor),
      GoogleFonts.amaranth(
          fontStyle: FontStyle.normal, color: _currentTextColor),
      GoogleFonts.artifika(
          fontStyle: FontStyle.normal, color: _currentTextColor),
      GoogleFonts.bentham(
          fontStyle: FontStyle.normal, color: _currentTextColor),
      GoogleFonts.bangers(
          fontStyle: FontStyle.normal, color: _currentTextColor),
      GoogleFonts.boogaloo(
          fontStyle: FontStyle.normal, color: _currentTextColor),
      GoogleFonts.condiment(
          fontStyle: FontStyle.normal, color: _currentTextColor)
    ];

    lstWidget.clear();
    lstWidget = [
      //1ST FOOTER
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
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: FittedBox(
                fit: BoxFit.none,
                alignment: Alignment.centerLeft,
                child: Text(
                  emailAddress!,
                  style: TextStyle(color: _currentTextColor, fontSize: 14),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5))),
              height: 25,
              width: 90,
              child: FittedBox(
                fit: BoxFit.none,
                child: Text(
                  mobile!, style: tStyle,
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
          ///left Line
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

          ///Bottom Line
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 15),
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
                color: _currentColor, borderRadius: BorderRadius.circular(50)),
          ),

          ///Main Container
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 7, bottom: 10),
                height: 80,
                width: 35,
                decoration: BoxDecoration(
                    color: _currentColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.mail,
                      size: 20,
                      color: _currentTextColor,
                    ),
                    Icon(
                      Icons.phone,
                      size: 20,
                      color: _currentTextColor,
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, bottom: 10),
                height: 80,
                width: 150,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      emailAddress!,
                      style: tStyle,
                    ),
                    Text(
                      mobile!,
                      style: tStyle,
                    )
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
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.5),
                borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(200))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 34, left: 50),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 15,
                    color: _currentTextColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(mobile!, style: tStyle),
                ],
              ),
            ),
          ),
          Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: _currentTextColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      address!,
                      style: tStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
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
            margin: const EdgeInsets.all(2),
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
                    height: 4,
                  ),
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
                  color: Colors.red,
                  borderRadius:
                  BorderRadius.only(topRight: Radius.circular(10))),
              child: FittedBox(
                fit: BoxFit.none,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: _currentColor,
              ),
              child: Row(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Text(
                        address!,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: tStyle,
                      ),
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
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Container(
                  decoration: BoxDecoration(
                      color: _currentColor,
                      borderRadius: BorderRadius.circular(30)),
                  height: 25,
                  width: MediaQuery.of(context).size.width / 2.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/web.png',
                        color: _currentTextColor,
                        height: 13,
                        width: 13,
                      ),
                      // const SizedBox(
                      //   width: 2,
                      // ),
                      Text(
                        "www.canva.com",
                        style: tStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  'City Address Line State-Pincode',
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
              child: Row(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    width: MediaQuery.of(context).size.width / 3.8,
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
                    width: MediaQuery.of(context).size.width / 3,
                    child: FittedBox(
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
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff666633),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    height: 25,
                    width: MediaQuery.of(context).size.width / 3,
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/images/web.png',
                            color: _currentTextColor,
                            height: 13,
                            width: 13,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            businessName!,
                            style: tStyle,
                          ),
                        ],
                      ),
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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                      )),
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/web.png',
                          color: _currentTextColor,
                          height: 15,
                          width: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          businessName!,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      border: Border.all(color: _currentColor, width: 2),
                      borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(40))),
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
                        bottomRight: Radius.circular(40),
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
  // getWidgetData()
  // {
  //   setState(() {
  //
  //   });
  //   stLList.clear();
  //   stLList=[
  //     GoogleFonts.oswald(fontStyle: FontStyle.italic,color: _currentTextColor)
  //     ,GoogleFonts.poppins(fontStyle: FontStyle.italic,color: _currentTextColor)
  //     ,GoogleFonts.lato(fontStyle: FontStyle.italic,color: _currentTextColor)
  //     ,GoogleFonts.varela(fontStyle: FontStyle.italic,color: _currentTextColor)
  //     ,GoogleFonts.aBeeZee(fontStyle: FontStyle.italic,color: _currentTextColor)
  //     ,GoogleFonts.lato(fontStyle: FontStyle.italic,color: _currentTextColor)
  //     ,GoogleFonts.amaranth(fontStyle:FontStyle.normal,color:_currentTextColor)
  //     ,GoogleFonts.artifika(fontStyle:FontStyle.normal,color:_currentTextColor)
  //     ,GoogleFonts.bentham(fontStyle:FontStyle.normal,color:_currentTextColor)
  //     ,GoogleFonts.bangers(fontStyle:FontStyle.normal,color:_currentTextColor)
  //     ,GoogleFonts.boogaloo(fontStyle:FontStyle.normal,color:_currentTextColor)
  //     ,GoogleFonts.condiment(fontStyle:FontStyle.normal,color:_currentTextColor)
  //   ];
  //
  //   lstWidget.clear();
  //   lstWidget = [
  //     Stack(
  //       alignment: Alignment.bottomRight,
  //       children: [
  //         Container(
  //           height: 20,
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             color: _currentColor,
  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),//BorderRadius.circular(10),
  //             //border: Border.all(color: Colors.white)
  //           ),
  //
  //
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 15, right: 10, bottom: 5),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   emailAddress!,
  //                   // style: TextStyle(
  //                   //     color: Colors.white, fontSize: 15.sp),
  //                 ),
  //                 Text(
  //                   mobile!,
  //                   // style: TextStyle(
  //                   //   color: Colors.white,
  //                   //   fontSize: 14.sp,
  //                   // ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.symmetric(vertical: 20),
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.yellow,
  //                 borderRadius: BorderRadius.only(
  //                     bottomLeft: Radius.circular(5.r),
  //                     topLeft: Radius.circular(5.r))),
  //             height: 25,
  //             width: 80,
  //           ),
  //         ),
  //       ],
  //     ),
  //     Stack(
  //       alignment: Alignment.bottomLeft,
  //       children: [
  //         ///left Line
  //         Padding(
  //           padding: EdgeInsets.only(left: 20, bottom: 40),
  //           child: Container(
  //             height: double.infinity,
  //             width: 3,
  //             decoration: BoxDecoration(
  //               color: _currentColor,
  //             ),
  //           ),
  //         ),
  //
  //         ///Bottom Line
  //         Container(
  //           margin: const EdgeInsets.only(left: 10, bottom: 15),
  //           height: 3,
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //               color: _currentColor,
  //               borderRadius: BorderRadius.circular(50)),
  //         ),
  //
  //         ///Main Container
  //         Row(
  //           children: [
  //             Container(
  //               margin: const EdgeInsets.only(left: 7, bottom: 10),
  //               height: 80,
  //               width: 35,
  //               decoration: BoxDecoration(
  //                   color: _currentColor,
  //                   borderRadius: BorderRadius.circular(50)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: const [
  //                   Icon(
  //                     Icons.mail,
  //                     size: 20,
  //                   ),
  //                   Icon(
  //                     Icons.phone,
  //                     size: 20,
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               margin: const EdgeInsets.only(left: 5, bottom: 10),
  //               height: 80,
  //               width: 150,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(50)),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Text(
  //                     emailAddress!,
  //                     style: tStyle,
  //                   ),
  //                   Text(
  //                     mobile!,
  //                     style: tStyle,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //     Stack(
  //       alignment: Alignment.bottomRight,
  //       children: [
  //         Container(
  //           height: 55,
  //           width: 350,
  //           decoration: BoxDecoration(
  //               color: Colors.red.withOpacity(0.5),
  //               borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(200))),
  //           child: Padding(
  //             padding: const EdgeInsets.only(bottom: 34, left: 50),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   Icons.phone,
  //                   size: 15,
  //                   color: Colors.white,
  //                 ),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   mobile!,
  //                   style: tStyle,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Container(
  //           height: 35,
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //               color: _currentColor,
  //               borderRadius:
  //               BorderRadius.only(topLeft: Radius.circular(200))),
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 20),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   Icons.location_on,
  //                   color: Colors.white,
  //                 ),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   address!,
  //                   style: tStyle,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     Stack(
  //       alignment: Alignment.bottomCenter,
  //       children: [
  //         Container(
  //           margin: const EdgeInsets.all(5),
  //           height: 100,
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20.r),
  //             border: Border.all(
  //               color: Colors.red,
  //               width: 2.w,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 100,
  //           width: double.infinity,
  //           child: Column(
  //             children: [
  //               Container(
  //                 height: 25,
  //                 width: 180,
  //                 decoration: BoxDecoration(
  //                     color: Colors.red,
  //                     borderRadius: BorderRadius.circular(50)),
  //                 child: Center(
  //                   child: Text("Business Name",
  //                     //businessName!,
  //                     style: TextStyle(
  //                         color: Colors.white, fontSize: 13),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Icon(
  //                     Icons.phone,
  //                     size: 15,
  //                     color: Colors.red,
  //                   ),
  //                   SizedBox(
  //                     width: 2,
  //                   ),
  //                   Text(
  //                     mobile!,
  //                     style: TextStyle(
  //                         color: Colors.red, fontSize: 15),
  //                   ),
  //                 ],
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Icon(
  //                     Icons.mail,
  //                     size: 15,
  //                     color: Colors.red,
  //                   ),
  //                   SizedBox(
  //                     width: 5,
  //                   ),
  //                   Text(
  //                     emailAddress!,
  //                     style: TextStyle(
  //                         color: Colors.red, fontSize: 13),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 5,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Icon(
  //                     Icons.location_on,
  //                     size: 15,
  //                     color: Colors.red,
  //                   ),
  //                   SizedBox(
  //                     width: 5,
  //                   ),
  //                   Text(
  //                     address!,
  //                     style: TextStyle(
  //                         color: Colors.red, fontSize: 13),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: <Widget>[
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             height: 60,
  //             decoration: const BoxDecoration(
  //                 color: Colors.red,
  //                 borderRadius: BorderRadius.only(
  //                     topRight: Radius.circular(10))),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const Icon(
  //                       Icons.mail,
  //                       size: 20,
  //                       color: Colors.white,
  //                     ),
  //                     SizedBox(
  //                       width: 7,
  //                     ),
  //                     Text(
  //                       emailAddress!,
  //                       style: TextStyle(
  //                           color: Colors.white, fontSize: 15.sp),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const Icon(
  //                       Icons.phone,
  //                       size: 20,
  //                       color: Colors.white,
  //                     ),
  //                     SizedBox(
  //                       width: 2,
  //                     ),
  //                     Text(
  //                       mobile!,
  //                       style: TextStyle(
  //                           color: Colors.white, fontSize: 15.sp),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             height: 40,
  //             decoration: const BoxDecoration(
  //               color: Colors.grey,
  //             ),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const Icon(
  //                       Icons.location_on,
  //                       size: 20,
  //                       color: Colors.red,
  //                     ),
  //                     SizedBox(
  //                       width: 7.w,
  //                     ),
  //                     Text(
  //                       address!,
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                           color: Colors.red, fontSize: 15.sp),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     Stack(
  //       alignment: AlignmentDirectional.bottomCenter,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.symmetric(vertical: 3),
  //           child: Container(
  //             height: 40,
  //             width: double.infinity,
  //             decoration: const BoxDecoration(color: Colors.red),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 10.w),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       const Icon(
  //                         Icons.mail,
  //                         size: 15,
  //                         color: Colors.white,
  //                       ),
  //                       SizedBox(
  //                         width: 7.w,
  //                       ),
  //                       Text(
  //                         emailAddress!,
  //                         style: TextStyle(
  //                             color: Colors.white, fontSize: 12.sp),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       const Icon(
  //                         Icons.phone,
  //                         size: 15,
  //                         color: Colors.white,
  //                       ),
  //                       SizedBox(
  //                         width: 2.w,
  //                       ),
  //                       Text(
  //                         mobile!,
  //                         style: TextStyle(
  //                             color: Colors.white, fontSize: 12.sp),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Container(
  //               height: 50,
  //               width: 100,
  //               decoration: const BoxDecoration(
  //                   color: Colors.yellow,
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(40),
  //                       bottomLeft: Radius.circular(40))),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   SizedBox(
  //                     width: 7.w,
  //                   ),
  //                   Text(
  //                     address!,
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         color: Colors.red, fontSize: 11.sp),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     )
  //     // Padding(
  //     //   padding: const EdgeInsets.symmetric(vertical: 25),
  //     //   child: Container(
  //     //     decoration: const BoxDecoration(
  //     //         color: Colors.yellow,
  //     //         borderRadius: BorderRadius.only(
  //     //             bottomLeft: Radius.circular(10),
  //     //             topLeft: Radius.circular(10))),
  //     //     height: 35,
  //     //     width: 120,
  //     //     // child: Row(
  //     //     //   mainAxisAlignment: MainAxisAlignment.center,
  //     //     //   children: [
  //     //     //     Image.asset(
  //     //     //       'images/facebook.png',
  //     //     //       height: 18,
  //     //     //       width: 18,
  //     //     //     ),
  //     //     //     const SizedBox(width: 10),
  //     //     //     Image.asset(
  //     //     //       'images/instagram.png',
  //     //     //       height: 18,
  //     //     //       width: 18,
  //     //     //     ),
  //     //     //     const SizedBox(width: 10),
  //     //     //     Image.asset(
  //     //     //       'images/whatsapp.png',
  //     //     //       height: 18,
  //     //     //       width: 18,
  //     //     //     ),
  //     //     //   ],
  //     //     // ),
  //     //   ),
  //     // )
  //   ];
  //   setState(() {
  //
  //   });
  // }

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

  // Widget getCustomTemplate(id)
  // {
  //   // setState(() {
  //   //
  //   // });
  //   switch(id)
  //   {
  //     case "0":
  //       return lstWidget[int.parse(id)];
  //       //return Container(color: Colors.red,width: 300,height: 300,);
  //       print("In Switch"+id);
  //       setState(() {
  //
  //       });
  //       break;
  //     case "1":
  //       return lstWidget[int.parse(id)];
  //       // print("In Switch"+id);
  //       // return Container(color: Colors.green,width: 300,height: 300,);
  //       setState(() {
  //
  //       });
  //       break;
  //     case "2":
  //       return lstWidget[int.parse(id)];
  //       setState(() {
  //
  //       });
  //     case "3":
  //       return lstWidget[int.parse(id)];
  //       setState(() {
  //
  //       });
  //     case "4":
  //       return lstWidget[int.parse(id)];
  //       setState(() {
  //
  //       });
  //       break;
  //     case "5":
  //       return lstWidget[int.parse(id)];
  //       setState(() {
  //
  //       });
  //       break;
  //     default:
  //       return Container(color: Colors.black,width: 300,height: 300,);
  //       break;
  //   }
  // }
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
        // if (isProfileUpdate)
        //   {
        //     displayImage = dtaFilteredPosters.isNotEmpty?dtaFilteredPosters[index].image:posterList[index].image,
        //     print("Changed img is here"+displayImage),
        //     //sStatus=false,
        //     setState(() {
        //       getWidgetData();
        //     })
        //   }
        // else
        //   {
        //     //sStatus=true,
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (_) => Account())),
        //   }
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
        // child: Padding(
        //   padding: const EdgeInsets.all(7),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Container(
        //         height: 15,
        //         padding: status
        //             ? EdgeInsets.only(left: 5, right: 5)
        //             : EdgeInsets.only(left: 0, right: 0),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(10),
        //             color: Colors.grey),
        //         child: Center(
        //           child: status
        //               ? Text(
        //             "Free",
        //             style: TextStyle(
        //                 fontSize: 10,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white),
        //           )
        //               : Text(
        //             "",
        //             style: TextStyle(
        //                 backgroundColor: Colors.red.withOpacity(.8)),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ),
    );
  }
}
