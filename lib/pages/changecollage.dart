import 'dart:convert';
import 'dart:io';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/Downloads.dart';
import 'package:canvas_365/others/MyColorPicker.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ChangeCollage extends StatefulWidget
{
  String id;
  int numberOfImage=0;
  ChangeCollage(this.id,this.numberOfImage);
  @override
  State<ChangeCollage> createState() => _ChangeCollageState(id,numberOfImage);
}

class _ChangeCollageState extends State<ChangeCollage>with SingleTickerProviderStateMixin{
  String id;
  int numberOfImage;
  CroppedFile? imageFile1,imageFile2,imageFile3,imageFile4,imageFile5;
  File ?imageFile;
  int currentImage=0;
  GlobalKey? globalkey;
  bool isApiCallingProcess = false;
  String ?userId;
  String? mobile,businessName;
  String? address;
  String? emailAddress, language_array;
  String? logo;
  bool? issubscribed;
  List<dynamic> stLList=[GoogleFonts.oswald(fontStyle: FontStyle.italic,color: Colors.white)];
  bool isProfileUpdate = false;
  double? borderWidth=0;
  bool? isBorder=false;
  Color _currentColor = primaryColor;
  Color _currentTextColor = Colors.black;
  var frameViewUrl = Uri.parse(webUrl + "getCustomFrame");
  var data;
  String customFrame = "none_custom_image.png";
  List<dynamic> dtaFrameCategory = [];
  List<NameIdBean> dtaFrameCategoryList = [];
  bool isCustomFrame = false;
  final _colorController = CircleColorPickerController(
    initialColor: Colors.blue,
  );
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
  var top = 10.0;
  var left = 10.0;
  TabController? _tabController;
  List<Widget> lstWidget = [];
  _ChangeCollageState(this.id,this.numberOfImage);

  @override
  void initState()
  {
    getUserData();
    _tabController = new TabController(length: 4, vsync: this);
    _tabController!.addListener(()
    {
      if(_tabController!.index==1)
      {
        isCustomFrame=true;
      }else
      {
        isCustomFrame=false;
      }
      setState(() {
      });
    });
    super.initState();

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
    if(dtaFrameCategory.isNotEmpty)
      {
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
    // print(language_array);
    // Map<String, dynamic> maps = json.decode(language_array.toString());
    // lnggDta = maps["lang"];
    //
    // print("it le length" + lnggDta.length.toString());
    // for (int i = 0; i < lnggDta.length; i++) {
    //   //choices.add(lnggDta[i]["language"]);
    //   choices.add(new NameIdBean(lnggDta[i]["id"], lnggDta[i]["language"],
    //       lnggDta[i]["language"], true));
    //   choicesId.add(lnggDta[i]["id"]);
    //}
    print("Is she subscribe$issubscribed");
    getMyFrame();
    setState(() {    getWidgetData();});
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
            // IconButton(
            //   onPressed: () async {
            //     //final chalega=await Utils.capture(globalkey!,context);
            //     //final chal=await Utils.save();
            //     setLikePoster();
            //   },
            //   icon: FaIcon(
            //     FontAwesomeIconseart,
            //     color: Colors.white,
            //     size: 20,
            //   ),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            widgetToImage(builder: (key) {
          this.globalkey = key;
          return Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: isBorder!?Border.all(color: _currentColor,width: borderWidth!):Border.all(color: _currentColor,width: 0),
                // image: DecorationImage(
                //     image: NetworkImage(imgUrl + displayImage),
                //     fit: BoxFit.fill)
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                !issubscribed!
                    ? Image.network(
                  imgWaterMark,
                  width: 450,
                )
                    : Container(),
                GestureDetector(
                  child: Stack(
                    children: [
                      getCollage(id),
                      Positioned(
                          top: top,
                          left: left,
                          child: InkWell(
                            onTap: () => {
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
                isCustomFrame
                    ? Image.network(imgUrl + customFrame):
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
                            ),
                            Text(
                              "mobile",
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
              ],
            ),
          );
            //getCollage(id);
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
                              ),Text("Border",style: TextStyle(color: primaryColor),),
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
    )); //getCollage(id),);
  }

  Widget getCollage(id) {
    // setState(() {});
    switch (id) {
      case "1":
        return collage1(context);

      case "2":
        return collage2(context);

      case "3":
        return collage3(context);

      case "4":
        return collage4(context);

      case "5":
        return collage5(context);

      case "6":
        return collage6(context);

      case "7":
        return collage7(context);

      case "8":
        return collage8(context);

      default:
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          width: 400,
          height: double.infinity,
        );
    }
  }

  ///Collage 1
  Widget collage1(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () {

          },
          child: Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(onTap: ()=>
                  {
                    currentImage=1,
                    _getFromGallery()
                  },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                      child: imageFile1 == null
                          ? const Icon(
                        Icons.add_a_photo,
                        color: Colors.white70,
                        size: 100,
                      )
                          : Image(
                        image: FileImage(
                          File(imageFile1!.path),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: ()=>{
                      currentImage=2,
                      _getFromGallery()
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                      child: imageFile2 == null
                          ? const Icon(
                        Icons.add_a_photo,
                        color: Colors.white70,
                        size: 100,
                      )
                          : Image(
                        image: FileImage(
                          File(imageFile2!.path),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  ///Collage 2
  Widget collage2(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()=>{
                    currentImage=1,
                    _getFromGallery()
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    width: double.infinity,
                    color: Colors.grey.shade400,
                    child: imageFile1 == null
                        ? const Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 100,
                    )
                        : Image(
                      image: FileImage(
                        File(imageFile1!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()=>
                  {
                    currentImage=2,
                    _getFromGallery()
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    width: double.infinity,
                    color: Colors.grey.shade400,
                    child: imageFile2 == null
                        ? const Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 100,
                    )
                        : Image(
                      image: FileImage(
                        File(imageFile2!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  ///Collage 3
  Widget collage3(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()=>{
                    currentImage=1,
                    _getFromGallery()
                  },
                  child: Container(
                      margin: const EdgeInsets.all(2),
                      width: double.infinity,
                      color: Colors.grey.shade400,
                    child: imageFile1 == null
                        ? const Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 100,
                    )
                        : Image(
                      image: FileImage(
                        File(imageFile1!.path),
                      ),
                      fit: BoxFit.cover,
                    ),),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          currentImage=2,
                          _getFromGallery()
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                            child: imageFile2 == null
                                ? const Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 100,
                            )
                                : Image(
                              image: FileImage(
                                File(imageFile2!.path),
                              ),
                              fit: BoxFit.cover,
                            ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          currentImage=3,
                          _getFromGallery()
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                            child: imageFile3 == null
                                ? const Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 100,
                            )
                                : Image(
                              image: FileImage(
                                File(imageFile3!.path),
                              ),
                              fit: BoxFit.cover,
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
      );

  ///Collage 4
  Widget collage4(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          currentImage=1,
                          _getFromGallery()
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                            child: imageFile1 == null
                                ? const Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 100,
                            )
                                : Image(
                              image: FileImage(
                                File(imageFile1!.path),
                              ),
                              fit: BoxFit.cover,
                            ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          currentImage=2,
                          _getFromGallery()
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                            child: imageFile2 == null
                                ? const Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 100,
                            )
                                : Image(
                              image: FileImage(
                                File(imageFile2!.path),
                              ),
                              fit: BoxFit.cover,
                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()=>{
                    currentImage=3,
                    _getFromGallery()
                  },
                  child: Container(
                      margin: const EdgeInsets.all(2),
                      width: double.infinity,
                      color: Colors.grey.shade400,
                    child: imageFile3 == null
                        ? const Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 100,
                    )
                        : Image(
                      image: FileImage(
                        File(imageFile3!.path),
                      ),
                      fit: BoxFit.cover,
                    ),),
                ),
              ),
            ],
          ),
        ),
      );
  ///Collage 5
  Widget collage5(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          {
                            currentImage=1,
                            _getFromGallery()
                          },
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile1 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                              image: FileImage(
                                File(imageFile1!.path),
                              )
                        ),
                    ),
                      ),),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          {
                            currentImage=2,
                            _getFromGallery()
                          },
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile2 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                              image: FileImage(
                                File(imageFile2!.path),
                              )
                        ),
                    ),
                      ),
                    )],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          {
                            currentImage=2,
                            _getFromGallery()
                          },
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile3 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                              image: FileImage(
                                File(imageFile3!.path),
                              )
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        height: double.infinity,
                        color: Colors.grey.shade400,
                        child: imageFile4 == null
                            ? const Icon(
                          Icons.add_a_photo,
                          color: Colors.white70,
                          size: 100,
                        )
                            : Image(
                            image: FileImage(
                              File(imageFile4!.path),
                            )
                      ),
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget collage6(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()=>{
                    {
                      currentImage=1,
                      _getFromGallery()
                    },
                  },
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    height: double.infinity,
                    color: Colors.grey.shade400,
                    child: imageFile1 == null
                        ? const Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 100,
                    )
                        : Image(
                      image: FileImage(
                        File(imageFile1!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          {
                            currentImage=2,
                            _getFromGallery()
                          },
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          width: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile2 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                            image: FileImage(
                              File(imageFile2!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          {
                            currentImage=3,
                            _getFromGallery()
                          },
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          width: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile3 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                            image: FileImage(
                              File(imageFile3!.path),
                            ),
                            fit: BoxFit.cover,
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
      );

  Widget collage7(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          {
                            currentImage=1,
                          _getFromGallery()
                        },
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          width: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile1 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                            image: FileImage(
                              File(imageFile1!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          {
                            currentImage=2,
                            _getFromGallery()
                          },
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          width: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile2 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                            image: FileImage(
                              File(imageFile2!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()=>{
                    {
                      currentImage=3,
                      _getFromGallery()
                    },
                  },
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    height: double.infinity,
                    color: Colors.grey.shade400,
                    child: imageFile3 == null
                        ? const Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 100,
                    )
                        : Image(
                      image: FileImage(
                        File(imageFile3!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget collage8(context) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()=>{
                    currentImage=1,
                    _getFromGallery()
                  },
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    width: double.infinity,
                    color: Colors.grey.shade400,
                    child: imageFile1 == null
                        ? const Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 100,
                    )
                        : Image(
                      image: FileImage(
                        File(imageFile1!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          currentImage=2,
                          _getFromGallery()
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile2 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                            image: FileImage(
                              File(imageFile2!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          currentImage=3,
                          _getFromGallery()
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile3 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                            image: FileImage(
                              File(imageFile3!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: ()=>{
                          currentImage=4,
                          _getFromGallery()
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          height: double.infinity,
                          color: Colors.grey.shade400,
                          child: imageFile4 == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 100,
                          )
                              : Image(
                            image: FileImage(
                              File(imageFile4!.path),
                            ),
                            fit: BoxFit.cover,
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
      );
  _getFromGallery() async
  {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null)
    {
      imageFile = File(pickedFile.path);
      // isApiCallingProcess=false;
      //sendProductImage("logo",imageFile!);
      setState(()
      {
        imageFile = File(pickedFile.path);
        _cropImage();
      });
    }

  }

  Future<Null> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9]
            : [CropAspectRatioPreset.original, CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio5x3, CropAspectRatioPreset.ratio5x4, CropAspectRatioPreset.ratio7x5, CropAspectRatioPreset.ratio16x9
        ],);
    if (croppedFile != null)
    {
      switch(currentImage)
        {
        case 1:
          imageFile1=croppedFile;
          break;
        case 2:
          imageFile2=croppedFile;
          break;
        case 3:
          imageFile3=croppedFile;
          break;
        case 4:
          imageFile4=croppedFile;
          break;
        }
      //imageFile = croppedFile;
      setState(() {
        //state = AppState.cropped;
      });
    }
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

  Widget getCustomTemplate(id)
  {
    // setState(() {
    //
    // });
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
      break;
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
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Row(
            //       children: [
            //         Container(
            //           height: 3,
            //           width: 15,
            //           decoration: BoxDecoration(color: _currentColor),
            //         ),
            //         Image.asset(
            //           'assets/images/phone.png',
            //           color: _currentColor,
            //           height: 20,
            //           width: 20,
            //         ),
            //         const SizedBox(
            //           width: 5,
            //         ),
            //         Text(
            //           mobile!,
            //           style: tStyle,
            //         ),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //         Container(
            //           height: 4,
            //           width: 15,
            //           decoration: BoxDecoration(color: _currentColor),
            //         ),
            //         Image.asset(
            //           'assets/images/mail.png',
            //           color: _currentColor,
            //           height: 21,
            //           width: 21,
            //         ),
            //         const SizedBox(
            //           width: 5,
            //         ),
            //         Text(
            //           emailAddress!,
            //           style: tStyle,
            //         ),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //         Container(
            //           height: 4,
            //           width: 15,
            //           decoration: BoxDecoration(color: _currentColor),
            //         ),
            //         Image.asset(
            //           'assets/images/location.png',
            //           color: _currentColor,
            //           height: 20,
            //           width: 20,
            //         ),
            //         const SizedBox(
            //           width: 5,
            //         ),
            //         Text(
            //           address!,
            //           textAlign: TextAlign.center,
            //           style: tStyle,
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
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
