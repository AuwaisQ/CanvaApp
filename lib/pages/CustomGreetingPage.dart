import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/Downloads.dart';
import 'package:canvas_365/others/MyColorPicker.dart';
import 'package:canvas_365/pages/CaptureImagePage.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomGreetingPage extends StatefulWidget
{
  String title="";
  String image="";
  String widName="";
  CustomGreetingPage(this.title,this.image,this.widName);
  @override
  State<CustomGreetingPage> createState() => _CustomGreetingPage(title,image,widName);
}

enum AppState {
  free,
  picked,
  change,
}

class _CustomGreetingPage extends State<CustomGreetingPage> with WidgetsBindingObserver ,SingleTickerProviderStateMixin {
  String title = "",
      image = "",
      widName = "";

  _CustomGreetingPage(this.title, this.image, this.widName);

  late AppState state = AppState.free;
  bool isApiCallingProcess = false;
  GlobalKey? globalkey;
  bool isProfileUpdate = false;
  String? userId;
  String? mobile, businessName;
  String? address;
  String? emailAddress;
  String? logo;
  bool? issubscribed;
  File? imageFile;
  String tText = "Type Here";
  bool isText = true;
  bool isFooter = false;
  bool isBorder = false;
  var top = 10.0;
  var left = 10.0;
  XFile? _image1;

  //List<Widget> greetingWidget = [customFrame1];
  var ttop = 20.0;
  var lleft = 250.0;
  bool isCustomFrame = false;
  double tSize = 15;
  String font = "Select Font";
  var url = Uri.parse(webUrl + "background");

  double? borderWidth = 0;

  Color _currentColor = primaryColor;
  Color _currentTextColor = Colors.black;
  final _colorController = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  List<Widget> lstWidget = [];
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

  // Color pickerColor = Color(0xffff7686);
  // Color changeColor = Color(0xffb83bf1);
  String backgroundImg = "";
  CameraController? _controller;
  Future<void>? _initController;
  var isCameraReady = false;

  //XFile ?imageFile;
  File? fle;
  List<XFile> images = [];
  List<String> imags = [];
  List<String> fontList = ["Varela", "Poppinsregular", "Prompt", "Heebo"];
  TextEditingController textController = new TextEditingController();
  PhotoViewScaleStateController photoController = new PhotoViewScaleStateController();
  PhotoViewController photoViewController = new PhotoViewController();
  Color currentColor = Colors.amber;

  void changeColor(Color color) => setState(() => currentColor = color);
  var data;
  List<dynamic> dta = [];
  List<NameIdBean> bData = [];
  TabController? _tabController;

  var frameViewUrl = Uri.parse(webUrl + "getCustomFrame");
  List<dynamic> dtaFrameCategory = [];
  List<NameIdBean> dtaFrameCategoryList = [];
  String customFrame = "none_custom_image.png";

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

  @override
  void initState() {
    photoController = PhotoViewScaleStateController();
    photoViewController = PhotoViewController();

    _tabController = new TabController(length: 4, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.index == 1) {
        isCustomFrame = true;
      } else {
        isCustomFrame = false;
      }
      setState(() {});
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
  void dispose() {
    photoController.dispose();
    photoViewController.dispose();
    super.dispose();
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

  void getBackgroundImage() async
  {
    isApiCallingProcess = true;
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
    if (status) {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["list"];
      //dtaSelectedCategory=map["slider"];
      print("Startup Poster:" + dta.length.toString());
      print(dta.length.toString());
      //for(int i=0;i<dta.length;i++)
      for (int i = 0; i < dta.length; i++) {
        bData.add(new NameIdBean(
            dta[i]["id"].toString(), dta[i]["image"].toString(),
            dta[i]["image"].toString(), true));
      }
      // print(dtaGretrings.length.toString());
      // for(int i=0;i<dtaGretrings.length;i++)
      // {
      //   dtaSelectedGreetingposter.add(new NameIdBean(dtaGretrings[i]["gsubcategoryid"].toString(), dtaGretrings[i]["image"].toString(), "", true));
      // }

      setState(() {
        //getProfileStatus();
      });
    } else {
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
      setState(() {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      });
    }
    isApiCallingProcess = false;
    setState(() {

    });
  }

  void _showSelectImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Add A Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Take A Photo'),
              onPressed: () => _handleImage(source: ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: const Text('Choose From Gallery'),
              onPressed: () => _handleImage(source: ImageSource.gallery),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  void _handleImage({required ImageSource source}) async {
    Navigator.pop(context);
    XFile? image2 = await ImagePicker().pickImage(source: source);
    if (image2 != null) {
      image2 = await _cropImage(imageFile: image2);
      setState(() {
        _image1 = image2;
      });
    }
  }

  Future<XFile?> _cropImage({required XFile imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) {
      return null;
    }
    return XFile(croppedImage.path);
  }

  @override
  Widget build_ui(BuildContext context) {
    bool isImage = true;
    return Scaffold(
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () =>
              {
                _showSelectImageDialog()
              },
              icon: _buildButtonIcon(),
              label: Text("Image"),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: BottomAppBar(
          color: backgroundColor,
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: Card(
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Text Tab
                    InkWell(
                      onTap: () =>
                      {
                        isText = true,
                        setState(() {})
                      },
                      child: Image.asset('assets/images/text.png',
                        height: isText == true ? 40 : 30,
                        width: isText ==  true ? 40 : 30,
                      ),
                    ),
                    //Footer Tab
                    InkWell(
                      onTap: () =>
                      {
                        isText = false,
                        setState(() {
                          getWidgetData();
                        })
                      },
                        child: Image.asset('assets/images/footer.png',
                          height: isText == false ? 40 : 30,
                          width: isText == false ? 40 : 30,
                          fit: BoxFit.cover,),
                    ),
                  ],
                )),
          ),
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
            title,
            style: TextStyle(fontFamily: "Poppinsregular"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                //TODO: Remove button from IOS
                final chalega = await Utils.capture(globalkey!, context);
                //final chal=await Utils.save();
              },
              child: Image.asset('assets/images/share.png',height: 20,width: 20),
            ),
            TextButton(onPressed: ()async {
              isApiCallingProcess = true;
              setState(() {});
              final bs64 = await Utils.captureBase6(globalkey!);
              sendProductImage(bs64);
            }, child: Image.asset('assets/images/save.png',height: 25,width: 25,)
            ),
            // IconButton(
            //   onPressed: () async {
            //     isApiCallingProcess = true;
            //     setState(() {});
            //     final bs64 = await Utils.captureBase6(globalkey!);
            //     //print("Now BS6 id"+bs64);
            //     sendProductImage(bs64);
            //     // setState(()
            //     // {
            //     //   this.byteOne=byteOne;
            //     // });
            //     //Navigator.push(context,MaterialPageRoute(builder: (context) => Downloads()));
            //   },
            //   icon: Icon(
            //     Icons.save,
            //   ),
            // ),
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
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*(8/100),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*(8/100),
                                width: MediaQuery.of(context).size.width,
                                child: customFrameies(widName),
                              ),
                              //Watermark Image
                              !issubscribed!
                                  ? Stack(
                                children: [
                                  Image.network(imgWaterMark),
                                  PhotoView(
                                    enableRotation: true,
                                    controller: photoViewController,
                                    scaleStateController: photoController,
                                    enablePanAlways: true,
                                    backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                    imageProvider: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/8/89/HD_transparent_picture.png'),
                                  ),
                                ],
                              )
                                  : Container(),
                              //Brand Logo
                              Positioned(
                                  top: top,
                                  left: left,
                                  child: InkWell(
                                    onTap: () =>{},
                                    child: Image.network(
                                      logo != null
                                          ? imageUrl + logo!
                                          : imgAddLogo,
                                      width: 50,
                                    ),
                                  )),
                              //Floating Text
                              isText == false
                                  ? Container()
                                  : GestureDetector(
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: ttop,
                                        left: lleft,
                                        child: InkWell(
                                            onTap: () => {},
                                            child: Text(
                                              tText,
                                              style: TextStyle(color: currentColor,fontSize: tSize,fontFamily: font),
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
                              //Frame Footer
                              isCustomFrame
                                  ? Image.network(imgUrl + customFrame) :
                              temId != "none"
                                  ? getCustomTemplate(temId)
                                  : Stack(
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
                                            style: TextStyle(color: _currentTextColor, fontSize: 14),
                                          ),
                                        ],
                                      ),
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
                            ]));
                  }),
                  SizedBox(height: 10,),
                  if (isText) Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Type Here TextField
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [new BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4),
                            ],
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            maxLength: 20,
                            maxLines: 5,
                            minLines: 1,
                            textAlign: TextAlign.center,
                            onChanged: (text) {
                              tText = text;
                              if (text.length == 0) {
                                ttop = 100.0;
                                lleft = 150.0;
                              }
                              setState(() {});
                            },
                            controller: textController,
                            cursorColor: Colors.black,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Set text';
                              }
                              return null;
                            },
                            decoration:
                            new InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.grey, size: 24,),
                                // contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                                hintText: "Type Here",
                                hintStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 14)
                            ),
                          ),
                        ),

                        //Text Position Slider
                        Padding(
                          padding: const EdgeInsets.only(right: 15,top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              ElevatedButton(onPressed: () =>
                              {
                                setState(() {
                                  ttop = 100.0;
                                  lleft = 150.0;
                                })
                              }, child: Text("Reset Position"))
                            ],
                          ),
                        ),

                        //Choice Chips
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5,top: 10),
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
                            itemBuilder: (context, index) =>
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black)),
                                  height: 50,
                                  margin: EdgeInsets.all(2),
                                  child: Center(
                                      child: InkWell(
                                        child:
                                        Text("Can365", style: TextStyle(
                                            fontFamily: fontList[index],
                                            color: Colors.black)),
                                        onTap: () =>
                                        {
                                          //selectedInd=index,
                                          font = fontList[index],
                                          setState(() {
                                            //getWidgetData();
                                          })
                                        },
                                      )),
                                )
                            //posterList[index].status)
                            ,
                            itemCount: fontList.length,
                            physics: ScrollPhysics(),
                          ),
                        ),

                        //Color Selection Grid
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.43,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10,top: 15),
                            child: MyColorPicker(
                                onSelectColor: (value) {
                                  setState(() {
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
                          ),
                        )
                      ],
                    ),
                  )
                  else Card(
                    color: Colors.black,
                    elevation: 5,
                    child: Column(children: [
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
                            setState(() =>
                            getWidgetData()
                            );
                          },
                          tabs: [
                            Tab(
                              text: "Footer",),
                            //child:Center(child: Text("Footer", style: TextStyle(fontSize: 12)),)),
                            Tab(
                              text: "My Frames",),
                            Tab(
                              text: "Backgrounds",),
                            //child: Text("Backgrounds",style: TextStyle(fontSize: 12))),
                            Tab(text: "Text",),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/3,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            //Footer's Tab
                            Container(
                                height: MediaQuery.of(context).size.height,
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
                                        ),
                                        height: 50,
                                        margin: EdgeInsets.all(5),
                                        child: InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border:
                                                Border.all(
                                                    color: Colors.white)),
                                            alignment: Alignment.bottomCenter,
                                            // color: Colors.green,
                                            child: Image.asset(
                                                "assets/images/" +
                                                    lstImage[index]),
                                          ),
                                          onTap: () =>
                                          {
                                            temId = index.toString(),
                                            print("Tem id is:$temId"),
                                            setState(() {})
                                          },
                                        ),
                                      ),
                                  itemCount: lstWidget.length,
                                  physics: ScrollPhysics(),
                                )),

                            //MyFrames Tab
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height,
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 5, crossAxisCount: 3),
                                itemBuilder: (context, index) =>
                                    getFrameImage(
                                        dtaFrameCategoryList[index].name,
                                        index,
                                        dtaFrameCategoryList[index].image,
                                        false),
                                itemCount: dtaFrameCategoryList.length,
                                physics: ScrollPhysics(),
                              ),
                            ),

                            //BackGround Tab
                            Container(
                                height: 350,
                                child: Center(
                                  child:
                                  Column(crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                    children: [
                                      CircleColorPicker(
                                        controller: _colorController,
                                        onChanged: (color) {
                                          setState(() =>
                                          {
                                            _currentColor = color,
                                            getWidgetData()
                                          });
                                        },
                                        // controller: _colorController,
                                        // onChanged: (color) => print(color),
                                        size: const Size(260, 260),
                                        strokeWidth: 25,
                                        thumbSize: 50,
                                      )
                                    ],),
                                )),

                            //Text Tab
                            Container(
                                height: 300,
                                child:
                                Column(children: [
                                  Expanded(
                                    flex: 1,
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: (30 / 10),
                                          crossAxisCount: 4,
                                      ),
                                      itemBuilder: (context, index) =>
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            height: 50,
                                            margin: EdgeInsets.all(2),
                                            child: Center(
                                                child: InkWell(
                                                  child:
                                                  Text("Can365",
                                                      style: stList[index]),
                                                  onTap: () =>
                                                  {
                                                    selectedInd = index,
                                                    tStyle = stLList[selectedInd],
                                                    setState(() {
                                                      getWidgetData();
                                                    })
                                                  },
                                                )),
                                          )
                                      //posterList[index].status)
                                      ,
                                      itemCount: stList.length,
                                      physics: ScrollPhysics(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: MyColorPicker(
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
                                          Colors.teal
                                        ],
                                        initialColor: Colors.blue),
                                  ),
                                ],)
                            ),
                          ],
                        ),
                      ),
                    ],),),
                ],
              ),
            ),
          ),
        ));
  }

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

  Widget buildSheet1(context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Size", style: TextStyle(fontSize: 20),),
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
        )]);

  void _navigateAndDisplaySelection(BuildContext context) async
  {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => CaptureImagePage()),
    );
    String imgFile = result.toString();
    imageFile = File(imgFile);
    setState(() {});
    Navigator.pop(context);
  }

  getImage() {
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
                ListTile(tileColor: Colors.black12,
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                  trailing: Icon(Icons.radio_button_unchecked_sharp),
                  onTap: () => _navigateAndDisplaySelection(context),),
                SizedBox(height: 5,),
                ListTile(tileColor: Colors.black12,
                  leading: Icon(Icons.photo_album_rounded),
                  title: Text("Gallery"),
                  trailing: Icon(Icons.radio_button_unchecked_sharp),
                  onTap: _pickImage,)
              ],

              ),
            ), //buildSheet1(context),
          );
        });
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
                    style: TextStyle(color: _currentTextColor, fontSize: 14),
                  ),
                ],
              ),
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
              padding: const EdgeInsets.only(bottom: 25, left: 25, right: 10),
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
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
      ///5th Footer
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
      ///6th Footer
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
                                decoration: BoxDecoration(color: _currentColor),
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
                                decoration: BoxDecoration(color: _currentColor),
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
                                decoration: BoxDecoration(color: _currentColor),
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
              )
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
    ];
    setState(() {});
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

  Widget getFrameImage(String catId, index, String name, bool status) {
    return InkWell(
      onTap: () =>
      {
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

  Widget customFrameies(id) {
    print(id);
    switch (id) {
      case "1":
        return Stack(
          children: [
            RotationTransition(
              turns: new AlwaysStoppedAnimation(-6 / 360),
              child: _image1 == null
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.only(right: 50,bottom: 30),
                child: PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/images/congratulations1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "2":
        return Stack(
          children: [
            _image1 == null ? Container() : PhotoView(
              controller: photoViewController,
              scaleStateController: photoController,
              imageProvider: FileImage(File(_image1!.path),),
            ),
            Image.asset(
              'assets/images/congratulations2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "3":
        return Stack(
          children: [
            _image1 == null ? Container() : Padding(
              padding: const EdgeInsets.only(left: 150,top: 50),
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                controller: photoViewController,
                scaleStateController: photoController,
                imageProvider: FileImage(File(_image1!.path),),
              ),
            ),
            Image.asset(
              'assets/images/congratulations3.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "4":
        return Stack(
          children: [
            _image1 == null ? Container() : PhotoView(
              controller: photoViewController,
              scaleStateController: photoController,
              imageProvider: FileImage(File(_image1!.path),),
            ),
            Image.asset(
              'assets/images/getwellsoon1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "5":
        return Stack(
          children: [
            _image1 == null ? Container() : Padding(
              padding: const EdgeInsets.only(right: 70,top: 70),
              child: PhotoView(
                controller: photoViewController,
                scaleStateController: photoController,
                imageProvider: FileImage(File(_image1!.path),),
              ),
            ),
            Image.asset(
              'assets/images/getwellsoon2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "6":
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: _image1 == null ? Container() : PhotoView(
                controller: photoViewController,
                scaleStateController: photoController,
                imageProvider: FileImage(File(_image1!.path),),
              ),
            ),
            Image.asset(
              'assets/images/happyanniversary1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "7":
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
              child: _image1 == null ? Container() : Padding(
                padding: const EdgeInsets.only(right: 120,top: 10,bottom: 10),
                child: PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),

            Image.asset(
              'assets/images/happyanniversary2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "8":
        return Stack(
          children: [
            _image1 == null ? Container() : PhotoView(
              controller: photoViewController,
              scaleStateController: photoController,
              imageProvider: FileImage(File(_image1!.path),),
            ),
            Image.asset(
              'assets/images/happybirthday1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "9":
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: _image1 == null ? Container() : PhotoView(
                controller: photoViewController,
                scaleStateController: photoController,
                imageProvider: FileImage(File(_image1!.path),),
              ),
            ),
            Image.asset(
              'assets/images/happybirthday2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "10":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 150,
                left: 125,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/images/itsboy1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "11":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 140,
                left: 50,
              ),
              child: RotationTransition(
                turns: new AlwaysStoppedAnimation(8 / 360),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/images/itsboy2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "12":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 108,
                left: 110,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
              // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
            ),
            Image.asset(
              'assets/images/itsgirl1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "13":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 55,
                left: 185,
              ),
              child: _image1 == null ? Container() : PhotoView(
                controller: photoViewController,
                scaleStateController: photoController,
                imageProvider: FileImage(File(_image1!.path),),
              ),
            ),
            Image.asset(
              'assets/images/sale1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "14":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 45,
                left: 200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/images/sale2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "15":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 63,
                left: 140,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/images/shadhanjali1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "16":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 65,
                left: 150,
              ),
              child: _image1 == null ? Container() : PhotoView(
                controller: photoViewController,
                scaleStateController: photoController,
                imageProvider: FileImage(File(_image1!.path),),
              ),
            ),
            Image.asset(
              'assets/images/shadhanjali2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "17":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 125,
                left: 50,
              ),
              child: _image1 == null ? Container() : PhotoView(
                controller: photoViewController,
                scaleStateController: photoController,
                imageProvider: FileImage(File(_image1!.path),),
              ),
              // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
            ),
            Image.asset(
              'assets/images/thankyou1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "18":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 118,
                left: 205,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/images/thankyou2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "19":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 70,
                left: 210,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/images/wedding1.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      case "20":
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 85,
                left: 210.5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: _image1 == null ? Container() : PhotoView(
                  controller: photoViewController,
                  scaleStateController: photoController,
                  imageProvider: FileImage(File(_image1!.path),),
                ),
              ),
            ),
            Image.asset(
              'assets/assets/images/wedding2.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        );
      default:
        return Container(child: Text("none"),);
    }
  }
}
