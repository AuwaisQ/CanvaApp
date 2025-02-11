import 'dart:convert';
import 'dart:io';
import 'package:canvas_365/others/Downloads.dart';
import 'package:canvas_365/others/MyColorPicker.dart';
import 'package:canvas_365/pages/CaptureImagePage.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:expandable/expandable.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomFrames extends StatefulWidget
{
  late String categoryId;
  late String displayImage;
  CustomFrames(this.categoryId,this.displayImage);
  @override
  State<CustomFrames> createState() => _CustomFramesState(categoryId,displayImage);
}

enum AppState {
  free,
  picked,
  change,
}

class _CustomFramesState extends State<CustomFrames> with WidgetsBindingObserver
{
  late String categoryId,displayImage;
  _CustomFramesState(categoryId,displayImage);

  late AppState state = AppState.free;
  bool isApiCallingProcess = false;
  GlobalKey? globalkey;
  bool isProfileUpdate = false;
  String? userId;
  String? mobile;
  String? address;
  String? emailAddress;
  String? logo;
  bool? issubscribed;
  File? imageFile;
  String tText="Type Here";
  bool isText=false;
  var top = 10.0;
  var left = 10.0;
  double tSize=15;
  String font = "Select Font";
  var url = Uri.parse(webUrl+"frames");
  // Color pickerColor = Color(0xffff7686);
  // Color changeColor = Color(0xffb83bf1);
  String backgroundImg="https://canva365.com/img/1639049966100.png";
  CameraController? _controller;
  Future<void>? _initController;
  var isCameraReady = false;
  //XFile ?imageFile;
  File? fle;
  List<XFile> images = [];
  List<String> imags = [];
  TextEditingController textController=new TextEditingController();
  Color currentColor = Colors.amber;
  void changeColor(Color color) => setState(() => currentColor = color);
  var data;
  List<dynamic> dta=[];
  List<dynamic> dtaFrame=[];

  List<NameIdBean> bData=[];
  List<NameIdBean> bFrame=[];
  @override
  void initState() {
    // textController.addListener(()
    // {
    //   tText=textController.text;
    // });

    WidgetsBinding.instance.addObserver(this);
    initCamera();
    getUserData();
    //getGreetingImage();
    super.initState();
  }

  void getGreetingImage() async
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
      //dta=map["subposter"];
      dtaFrame=map["frames"];

      //dtaSelectedCategory=map["slider"];
      // print("Startup Poster:"+dta.length.toString());
      // print(dta.length.toString());
      // for(int i=0;i<dta.length;i++)
      // {
      //   bData.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["gsubcategoryid"].toString(), dta[i]["image"].toString(), true));
      // }

      for(int i=0;i<dtaFrame.length;i++)
      {
        bFrame.add(new NameIdBean(dtaFrame[i]["id"].toString(), dtaFrame[i]["type"].toString(), dtaFrame[i]["image"].toString(), true));
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
    }
    setState(() {});
    print("Is she subscribe$issubscribed");
    getGreetingImage();
  }

  // void getBackgroundImage() async
  // {
  //   isApiCallingProcess=true;
  //   print(url);
  //   var response = await http.get(url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   // var response = await http.post(url,
  //   //   headers: <String, String>{
  //   //     'Content-Type': 'application/json; charset=UTF-8',
  //   //   },
  //   //   body: jsonEncode(<String, String>
  //   //   {
  //   //     'userId': userId.toString(),
  //   //     'bcategoryId':businessId.toString()
  //   //     //'bcategoryId':"40"
  //   //   }
  //   //   ),);
  //   print(response.body);
  //   data = jsonDecode(response.body);
  //   //data=jsonDecode('{"data":[{"id":1,"language":"\u0a2a\u0a70\u0a1c\u0a3e\u0a2c\u0a40","defaultlang":"false"},{"id":3,"language":"\u0ba4\u0bae\u0bbf\u0bb4\u0bcd","defaultlang":"false"},{"id":4,"language":"\u0d2e\u0d32\u0d2f\u0d3e\u0d33\u0d02","defaultlang":"false"},{"id":5,"language":"Italia","defaultlang":"false"},{"id":6,"language":"\u0939\u093f\u0902\u0926\u0940","defaultlang":"false"},{"id":7,"language":"English","defaultlang":"true"}],"status":true,"msg":"success"}');
  //   //print(data);
  //   var status = data['status'];
  //   var msg = data['msg'];
  //   //issubscribed=data['issubscribed'];
  //   //setIsSubscribed(issubscribed);
  //   print(status);
  //   if (status)
  //   {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     dta=map["list"];
  //     //dtaSelectedCategory=map["slider"];
  //     print("Startup Poster:"+dta.length.toString());
  //     print(dta.length.toString());
  //     for(int i=0;i<dta.length;i++)
  //     {
  //       bData.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["image"].toString(), dta[i]["image"].toString(), true));
  //     }
  //     // print(dtaGretrings.length.toString());
  //     // for(int i=0;i<dtaGretrings.length;i++)
  //     // {
  //     //   dtaSelectedGreetingposter.add(new NameIdBean(dtaGretrings[i]["gsubcategoryid"].toString(), dtaGretrings[i]["image"].toString(), "", true));
  //     // }
  //
  //     setState(()
  //     {
  //       //getProfileStatus();
  //     });
  //   } else
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
  //     setState(()
  //     {
  //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  //     });
  //   }
  //   isApiCallingProcess=false;
  //   setState(() {
  //
  //   });
  // }

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
            // if (state == AppState.free)
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
            // else
            //   backgroundImg="null";
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
                      if(isText)
                        {
                          isText=false,
                        }else
                        {
                          isText=true,
                        },
                      setState((){

                      })
                    },
                    icon: Icon(
                      Icons.text_fields,
                      color: isText?primaryColor:Colors.grey,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: Icon(
                      Icons.face,
                      color: primaryColor,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () => {
                      // showModalBottomSheet(
                      //     backgroundColor:
                      //     Colors.white
                      //         .withOpacity(0.95),
                      //     context: context,
                      //     enableDrag: true,
                      //     isScrollControlled: true,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius:
                      //         BorderRadius.vertical(
                      //             top: Radius
                      //                 .circular(
                      //                 10))),
                      //     builder:
                      //         (BuildContext context) {
                      //       return SizedBox(
                      //         height: 420,
                      //         child: Container(
                      //           margin: EdgeInsets.all(10),
                      //           child:Container(
                      //               child: GridView.builder(scrollDirection: Axis.vertical,
                      //                   shrinkWrap: true,
                      //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //                       mainAxisSpacing: 5,
                      //                       crossAxisCount: 5),
                      //                   itemBuilder: (context, index)=>InkWell(
                      //                     onTap: ()=>{
                      //                       backgroundImg=bData[index].image,
                      //                       setState(() {})
                      //                     },
                      //                     child: Container(
                      //                       margin: EdgeInsets.all(5),
                      //                       height: 70,
                      //                       width: 70,
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.white,
                      //                           image: DecorationImage(
                      //                               image: NetworkImage(
                      //                                   imageUrl+bData[index].image),fit: BoxFit.cover),
                      //                           borderRadius: BorderRadius.circular(10),
                      //                           boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
                      //                   )//posterList[index].status)
                      //                   ,itemCount: bData.length
                      //               )
                      //
                      //           ),
                      //         ),//buildSheet1(context),
                      //       );
                      //     })
                    },
                    icon: Icon(
                      Icons.image,
                      color: primaryColor,
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
            'Business',
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
                  widgetToImage(builder: (key) {
                    this.globalkey = key;
                    return Container(
                        height: 390,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Stack(children: [
                          Positioned(
                            top: 10,
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
                                  // image: new DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   // colorFilter: ColorFilter.mode(
                                  //   //     Colors.white.withOpacity(0.3),
                                  //   //     BlendMode.dstATop),
                                  //   //if(logo!=null){image: }
                                  //   image: backgroundImg!=null?NetworkImage(imageUrl+backgroundImg!):NetworkImage('https://canva365.com/img/none.png',
                                  //   ),
                                  // ),
                                ),),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),),
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              child: backgroundImg != null
                                  ? Image.network(backgroundImg,fit: BoxFit.cover,)
                              // PhotoView(
                              //   imageProvider: NetworkImage(backgroundImg),
                              //   //     ExtendedImage.file(imageFile!,
                              //   //     // width: ScreenUtil.instance.setWidth(400),
                              //   //     // height: ScreenUtil.instance.setWidth(400),
                              //   //     fit: BoxFit.cover,
                              //   //     // cache: true,
                              //   //     // border: Border.all(color: Colors.red, width: 1.0),
                              //   //     // shape: boxShape,
                              //   //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              //   //     //cancelToken: cancellationToken,
                              // )
                                  : Container(                          //               decoration: BoxDecoration(
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(15),
                                //   // image: new DecorationImage(
                                //   //   fit: BoxFit.cover,
                                //   //   // colorFilter: ColorFilter.mode(
                                //   //   //     Colors.white.withOpacity(0.3),
                                //   //   //     BlendMode.dstATop),
                                //   //   //if(logo!=null){image: }
                                //   //   image: backgroundImg!=null?NetworkImage(imageUrl+backgroundImg!):NetworkImage('https://canva365.com/img/none.png',
                                //   //   ),
                                //   // ),
                                // ),
                              ),
                            ),
                          ),

                          isText==false?Container():GestureDetector(
                            child: Stack(
                              children: [
                                Positioned(
                                    top: top,
                                    left: left,
                                    child: InkWell(
                                        onTap: () => {
                                        },
                                        child: Text(
                                          tText,
                                          style: TextStyle(color: currentColor,fontSize: tSize,fontFamily: font),
                                        )))
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
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child:
                  //   Container(
                  //     child: Row(children:List.generate(dtaCategory.length, (index) =>
                  //     //getChip(new NameIdBean(languageList[index]['id'],languageList[index]['language'],"aaa",languageList[index]['status']))
                  //     getChip(dtaCategoryList[index],index),
                  //       // [
                  //       //   LanguageChips(chipName: 'Business News'),
                  //       //   LanguageChips(chipName:'Trending'),
                  //       //   LanguageChips(chipName:'Sports'),
                  //       //   LanguageChips(chipName:'Devotional'),
                  //       //   LanguageChips(chipName:'Leaders Quotes'),
                  //       //   LanguageChips(chipName:'Olympic 2020'),
                  //       // ]
                  //     ),
                  //     ),
                  //   ),),
                  // Container(
                  //   height: 350,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(7),
                  //       image: DecorationImage(
                  //           image: NetworkImage(
                  //               "https://manalsoftech.in/canva_365/img/"+displayImage),
                  //           fit: BoxFit.cover)),
                  // ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //           border: Border(
                  //               bottom: BorderSide(
                  //                   color: isImage==true?Colors.purple:Colors.white, width: 2))),
                  //       child: Center(
                  //         child: TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               isImage=true;
                  //               print(isImage.toString());
                  //             });
                  //           },
                  //           child: Text(
                  //             'IMAGES',
                  //             style: TextStyle(
                  //                 fontSize: 15),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Container(
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //           border: Border(
                  //               bottom: BorderSide(
                  //                   color: !isImage==true?Colors.purple:Colors.white, width: 2))),
                  //       child: Center(
                  //         child: TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               isImage=false;
                  //               print(isImage.toString());
                  //             });
                  //           },
                  //           child: Text(
                  //             'VIDEOS',
                  //             style: TextStyle(
                  //                 fontSize: 15),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                      padding: EdgeInsets.all(8),
                      child: GridView.builder(scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 5,
                              crossAxisCount: 4),
                          itemBuilder: (context, index)=>InkWell(
                            onTap: ()=>{
                              backgroundImg=imgUrl+bFrame[index].image,
                              print(backgroundImg),
                              //profileStatus?Navigator.push(context, MaterialPageRoute(builder: (_)=>CustomFrames(bFrame[index].name,bFrame[index].image))):registratinConfirmation(context),
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
                                          imageUrl+bFrame[index].image),fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
                          )//posterList[index].status)
                          //,itemCount: bData.length
                          ,itemCount: 4
                      )

                  ),
                  SizedBox(height: 10,),
                  isText?Card(elevation: 5,
                    child: ExpandablePanel(
                      header: Container(margin: EdgeInsets.all(10), child: Text("Text Setup",style: TextStyle(fontSize: 12),)),
                      collapsed: Container(),
                      expanded: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
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
                            Container(
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.only(left: 35),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 50,
                              child: DropdownButton(
                                  underline: SizedBox(),
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  value: font,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Select Font"),
                                      value: "Select Font",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Varela"),
                                      value: "Varela",
                                    ),
                                    DropdownMenuItem(
                                        child: Text("Poppinsregular",style: TextStyle(fontFamily: 'Poppinsregular'),),
                                        value: "Poppinsregular"
                                    ),
                                    DropdownMenuItem(
                                        child: Text("Prompt",style: TextStyle(fontFamily: 'Prompt')),
                                        value: "Prompt"
                                    ),
                                    DropdownMenuItem(
                                        child: Text("Heebo",style: TextStyle(fontFamily: 'Heebo')),
                                        value: "Heebo"
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      font = value.toString();
                                      print(font);
                                    });
                                  }),
                            ),
                            SizedBox(height: 10,),
                            Text("Text Size",style: TextStyle(fontSize: 14),),
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
                            Text("Change Color",style: TextStyle(fontSize: 14),),
                            SizedBox(height: 10,),
                            MyColorPicker(
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
                                  Colors.teal
                                ],
                                initialColor: Colors.blue)
                          ],
                        ),
                      ),
                    ),
                  ):Container(),

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
}
