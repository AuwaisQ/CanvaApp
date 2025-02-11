import 'dart:io';
import 'dart:typed_data';

import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/Account.dart';
import 'package:canvas_365/others/Downloads.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/constants/downloads_directory_type.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProgressHud.dart';

class WithVideo extends StatefulWidget
{
  String ?categoryId;
  String ?displayImage;
  WithVideo({required this.categoryId,this.displayImage});
  @override
  _WithVideo createState() => _WithVideo(categoryId,displayImage.toString());

}

class _WithVideo extends State<WithVideo> with SingleTickerProviderStateMixin
{
  String ?categoryId;
  String displayImage="";
  String displayVideo="";
  _WithVideo(this.categoryId,this.displayImage);
  bool isApiCallingProcess=false;
  var url = Uri.parse(webUrl+"posterByCategoryApi");
  var likedImageUrl = Uri.parse(webUrl+"addMyFavouriteImage");
  var data;
  List<dynamic> dta=[];
  List<dynamic> dtaVideo=[];
  List<NameIdBean> posterList=[];
  List<NameIdBean> videoList=[];
  String msg="";
  bool sStatus=false;
  String ?mobile;
  String ?address;
  String ?emailAddress,language_array;
  String ?logo;
  bool ?issubscribed;
  GlobalKey ?globalkey;
  Uint8List ?byteOne;
  var bs64="";
  List<dynamic> lnggDta=[];
  bool isProfileUpdate=false;
  String ?userId;
  int haiImage=0;
  TabController ?_tabController;
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

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    isProfileUpdate = prefs.getBool("isProfileUpdate")!;
    userId=prefs.getString("user_id")!;
    if(isProfileUpdate)
    {
      mobile=prefs.getString('contact1');
      address=prefs.getString('businessAddress');
      emailAddress=prefs.getString('email');
      logo=prefs.getString('logo');
      issubscribed=prefs.getBool("isSubscribed");
      language_array=prefs.getString("language_array");
    }
    print(language_array);
    setState((){

    });
    print("Is she subscribe$issubscribed");
  }

  void getBusinessCategory() async
  {
    print("$url "+categoryId.toString());
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
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
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["data"];
      dtaVideo = map["feeds"];
      if(displayImage=="none")
      {
        displayImage=dta[0]["imgpath"];
      }
      for(int i=0;i<dta.length;i++)
      {
        bool stts=false;
        dta[i]["paid"]=="Free"?stts=true:stts=false;
        posterList.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["title"], dta[i]["imgpath"], stts));
      }
      // if(dtaVideo.length>1)
      //   {
      //     videoList=dtaVideo[""]
      //   }


      // Map<String, dynamic> maps = json.decode('{"lang":[{"id":"1","language":"English"},{"id":"2","language":"Hhindi"}]}');
      // lnggDta= maps["lang"];
      // print("it le length"+lnggDta.length.toString());
      setState(()
      {

      });

      print(dta.length.toString());
      setState(()
      {

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
    }
    isApiCallingProcess=false;
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }

  void setLikePoster() async
  {
    print(displayImage);
    print(userId);
    var response = await http.post(likedImageUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
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
    if (status)
    {
      Fluttertoast.showToast(
          msg: "Successfully added in wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else
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
    }
    isApiCallingProcess=false;
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }

  @override
  void initState()
  {
    getUserData();
    //isApiCallingProcess=true;
    getBusinessCategory();
    Map<String, dynamic> maps = json.decode('{"lang":[{"id":"1","language":"English"},{"id":"2","language":"Hhindi"}]}');
    lnggDta= maps["lang"];

    print("it le length"+lnggDta.length.toString());
    for(int i=0;i<lnggDta.length;i++)
    {
      //choices.add(lnggDta[i]["language"]);
      choices.add(new NameIdBean(lnggDta[i]["id"], lnggDta[i]["language"], lnggDta[i]["language"], true));
      choicesId.add(lnggDta[i]["id"]);
    }
    setState(() {

    });
    _tabController=new TabController(length: 2,vsync: this);
    _tabController!.addListener(()
    {
      // setState(() {
      //   _selectedIndex = _controller.index;
      // });
      haiImage=_tabController!.index;
      setState(() {
        haiImage=_tabController!.index;
      });
      print("Now Selected Index: " + haiImage.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context)
  {
    bool isImage=true;

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
            'Testing Poster',
            style: TextStyle(fontFamily: font),
          ),
          actions: [
            IconButton(
              onPressed: ()async
              {
                //final chalega=await Utils.capture(globalkey!,context);
                //final chal=await Utils.save();
                setLikePoster();
              },
              icon: FaIcon(FontAwesomeIcons.heart,color: Colors.white,size: 20,),
            ),
            IconButton(
              onPressed: ()async
              {
                final chalega=await Utils.capture(globalkey!,context);
                //final chal=await Utils.save();
              },
              icon: Icon(
                Icons.share,
                size: 20,
              ),
            ),
            PopupMenuButton(
              icon: Icon(
                  Icons.translate_outlined),
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
                return choices.map((NameIdBean choice)
                {
                  return  PopupMenuItem<String>
                    (
                    value: choice.id,
                    child: Text(choice.name),onTap: ()=>{
                    print(choice.id)
                  },
                  );
                }
                ).toList();
              },
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon:
            //     color: Colors.black,
            //   ),
            // ),
            IconButton(
              onPressed: () async
              {
                isApiCallingProcess=true;
                setState(() {
                });
                final bs64=await Utils.captureBase6(globalkey!);
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
                  haiImage==1?Container(color: Colors.yellow,height: 300,):
                  widgetToImage(
                      builder: (key) {
                        this.globalkey = key;
                        return Container(
                            height: 300,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        imgUrl +
                                            displayImage),
                                    fit: BoxFit.cover)),
                            child: CarouselSlider(
                                items: <Widget>[
                                  ///1st Container
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
//                                       Container(
//                                         margin: EdgeInsets.all(7),
//                                         height: 60,
//                                         width: 60,
//                                         decoration: BoxDecoration(
//                                           image: new DecorationImage(
//                                             fit: BoxFit.cover,
//                                             // colorFilter: ColorFilter.mode(
//                                             //     Colors.white.withOpacity(0.3),
//                                             //     BlendMode.dstATop),
//                                               //if(logo!=null){image: }
// image: logo!=null?NetworkImage(imageUrl+logo!):NetworkImage('https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png',
//                                             ),
//                                           ),
//                                         ),
//                                       ),
                                          issubscribed==false?Center(
                                            child: Container(
                                              height: 200,
                                              width: 300,
                                              decoration: BoxDecoration(
                                                image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  // colorFilter: ColorFilter.mode(
                                                  //     Colors.white.withOpacity(.5),
                                                  //     BlendMode.dstATop),
                                                  image: new NetworkImage(
                                                    imgUrl+'logo.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ):
                                          Container(
                                          )
                                        ],
                                      ),
                                      Container(
                                        height: 50,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/frame1.png'),
                                                fit: BoxFit.fitWidth)),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 25, top: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '+91 $mobile',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    '$emailAddress',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            ///2nd Row
                                            Padding(
                                              padding:
                                              EdgeInsets.only(right: 35, top: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  Text(
                                                    '$emailAddress',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                  ///2nd Container
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      issubscribed==false?Container(
                                        height: 250,
                                        width: 350,
                                        decoration: BoxDecoration(
                                          image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            // colorFilter: ColorFilter.mode(
                                            //     Colors.white.withOpacity(0.5),
                                            //     BlendMode.dstATop),
                                            image: new NetworkImage(
                                              imgUrl+'logo.png',
                                            ),
                                          ),
                                        ),
                                      ):Container(),
                                      Container(
                                        height: 30,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/frame2.png'),
                                                fit: BoxFit.fitWidth)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 37, bottom: 1),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                '+91 $mobile',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  ///3rd Container
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      issubscribed==false?Container(
                                        height: 230,
                                        width: 350,
                                        decoration: BoxDecoration(
                                          image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            // colorFilter: ColorFilter.mode(
                                            //     Colors.white.withOpacity(0.5),
                                            //     BlendMode.dstATop),
                                            image: new NetworkImage(
                                              imgUrl+'logo.png',
                                            ),
                                          ),
                                        ),
                                      ):Container(),
                                      Container(
                                        height: 55,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/frame3.png'),
                                                fit: BoxFit.fitWidth)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 19, top: 9),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                '+91 $mobile',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '$address',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                'Ujjain (M.P.)',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 8),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/1.png'),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 43, right: 65, bottom: 12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 35),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      '8878434855',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Text(
                                                    'abcd@gmail.com',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'www.abcd.com',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: const [
                                                  Text(
                                                    'Address',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///5th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 8),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/2.png'),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 18, bottom: 7),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Text(
                                                    '+910000 00000 00',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'abcd@gmail.com',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'www.abcd.com',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Row(
                                                  children: const [
                                                    Text(
                                                      'Address',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///6th Container
                                  Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.white.withOpacity(0.3),
                                                BlendMode.dstATop),
                                            image: new NetworkImage(
                                              imgUrl+'logo.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 100, right: 4),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage('assets/images/3.png'),
                                                  fit: BoxFit.cover)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30, right: 45, bottom: 12),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Text(
                                                      '+910000 00000 00',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Text(
                                                      'Address',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 10),
                                                      child: Text(
                                                        'www.abcd.com',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///7th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/4.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 45, bottom: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, bottom: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Text(
                                                      '+910000 00000 00',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 4),
                                                    child: Text(
                                                      'Address',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 10),
                                                    child: Text(
                                                      'www.abcd.com',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///8th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/5.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 24, bottom: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6, left: 180),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: const [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, bottom: 1.5),
                                                      child: Text(
                                                        '+910000 00000 00',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 7,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 52),
                                                      child: Text(
                                                        'www.abcd.com',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 4),
                                                      child: Text(
                                                        'Address',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///10th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/6.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 33, bottom: 10, right: 40),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Text(
                                                    '+910000 00000 00',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'abcd@gmail.com',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Text(
                                                    'Address',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 8.5),
                                                    child: Text(
                                                      'www.abcd.com',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///11th Container
                                  Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.white.withOpacity(0.3),
                                                BlendMode.dstATop),
                                            image: new NetworkImage(
                                              imgUrl+'logo.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/7.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 10, bottom: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3.5, left: 43),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      '+910000 00000 00',
                                                      style: TextStyle(
                                                          color: Colors.yellow,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 68,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 35),
                                                      child: Text(
                                                        'www.abcd.com',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 70, bottom: 2),
                                                      child: Text(
                                                        'Address',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///10th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/8.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 26, bottom: 1, right: 40),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 5.5),
                                                    child: Text(
                                                      '+910000 00000 00',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 25, bottom: 8.5),
                                                    child: Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 7),
                                                    child: Text(
                                                      'Address',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 45,
                                                    ),
                                                    child: Text(
                                                      'www.abcd.com',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///11th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/9.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 26,
                                            bottom: 1,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 6),
                                                    child: Text(
                                                      '+910000 00000 00',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 7.5, left: 4),
                                                    child: Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20, bottom: 8.5),
                                                    child: Text(
                                                      'www.abcd.com',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Address',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(right: 35),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: const [
                                                        Text(
                                                          '@facebook',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 7,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          '@Twitter',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 7,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///12th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/10.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 24,
                                            bottom: 1,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 2),
                                                    child: Text(
                                                      '+910000 00000 00',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 6, right: 10),
                                                    child: Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 7,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Text(
                                                      'Address',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 18, bottom: 1),
                                                      child: Text(
                                                        'www.abcd.com',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///13th Container
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: new NetworkImage(
                                                imgUrl+'logo.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('images/11.png'),
                                                fit: BoxFit.cover)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 18,
                                            bottom: 1,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 35, bottom: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: const [
                                                    Text(
                                                      '+910000 00000 00',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 20, bottom: 2.5),
                                                      child: Text(
                                                        'Address',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: 5,
                                                    ),
                                                    child: Text(
                                                      'abcd@gmail.com',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 55, bottom: 5),
                                                    child: Text(
                                                      '@Twitter',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 7,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'www.abcd.com',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(right: 40),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: const [
                                                          Text(
                                                            '@facebook',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 8,
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          ),
                                                          // SizedBox(
                                                          //   height: 2,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                options: CarouselOptions(
                                    height: double.infinity,
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1))

                        );
                      }),

                  Align(alignment: Alignment.bottomLeft,
                    child:
                    TabBar(controller: _tabController,
                    indicatorColor: primaryColor,
                    labelColor: Colors.white,
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(right: 45.0),
                    unselectedLabelColor: Colors.grey,
                    onTap: (index){
                      print("selected tab is $index:");
                    },
                    tabs: [
                      Tab(child:Text("Images",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
                      Tab(child:Text("Video",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
                    ],),
                  ),
                  Container(height: 350,width: double.infinity,child:TabBarView(controller: _tabController,children: [
                    Padding(
                      padding: EdgeInsets.all(0),
                      child:
                      Container(height: MediaQuery.of(context).size.height,
                        child: GridView.builder(scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 5,
                              crossAxisCount: 3),
                          itemBuilder: (context, index)=>getCatImage(posterList[index].name,index,posterList[index].image,false)//posterList[index].status)
                          //{
                          //   return InkWell(
                          //     onTap: ()=>
                          //     {
                          //       displayImage=posterList[index].image,
                          //       setState((){})
                          //     },
                          //     child: Column(
                          //       children: [
                          //         Container(
                          //           height: 100,
                          //           width: 100,
                          //           decoration: BoxDecoration(
                          //             //border: Border.all(width: 3,color: categoryList[index].status?primaryColor:Colors.white),
                          //               borderRadius: BorderRadius.circular(10),
                          //               image: DecorationImage(
                          //                   image: NetworkImage(
                          //                       "https://manalsoftech.in/canva_365/img/"+posterList[index].image),
                          //                   fit: BoxFit.cover)),child: Container( width: 30,height: 10, decoration: BoxDecoration(
                          //       //border: Border.all(width: 3,color: categoryList[index].status?primaryColor:Colors.white),
                          //         borderRadius: BorderRadius.circular(20),
                          //         ), margin: EdgeInsets.all(5), child: posterList[index].status?
                          //         Text("Demo",style: TextStyle(backgroundColor: Colors.grey.withOpacity(.8)),):Text("",style: TextStyle(backgroundColor: Colors.red.withOpacity(.8)),)),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // },
                          ,itemCount: posterList.length
                          ,physics: ScrollPhysics(),),
                      ),
                    ),
                    Container(color: Colors.greenAccent,height: 350,child: Text("Video will here"),),
                  ],))
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
                  // SizedBox(height: 10),
                  // Padding(
                  //   padding: EdgeInsets.all(0),
                  //   child:
                  //   Container(height: MediaQuery.of(context).size.height,
                  //     child: GridView.builder(scrollDirection: Axis.vertical,
                  //       shrinkWrap: true,
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           mainAxisSpacing: 5,
                  //           crossAxisCount: 3),
                  //       itemBuilder: (context, index)=>getCatImage(posterList[index].name,index,posterList[index].image,false)//posterList[index].status)
                  //       //{
                  //       //   return InkWell(
                  //       //     onTap: ()=>
                  //       //     {
                  //       //       displayImage=posterList[index].image,
                  //       //       setState((){})
                  //       //     },
                  //       //     child: Column(
                  //       //       children: [
                  //       //         Container(
                  //       //           height: 100,
                  //       //           width: 100,
                  //       //           decoration: BoxDecoration(
                  //       //             //border: Border.all(width: 3,color: categoryList[index].status?primaryColor:Colors.white),
                  //       //               borderRadius: BorderRadius.circular(10),
                  //       //               image: DecorationImage(
                  //       //                   image: NetworkImage(
                  //       //                       "https://manalsoftech.in/canva_365/img/"+posterList[index].image),
                  //       //                   fit: BoxFit.cover)),child: Container( width: 30,height: 10, decoration: BoxDecoration(
                  //       //       //border: Border.all(width: 3,color: categoryList[index].status?primaryColor:Colors.white),
                  //       //         borderRadius: BorderRadius.circular(20),
                  //       //         ), margin: EdgeInsets.all(5), child: posterList[index].status?
                  //       //         Text("Demo",style: TextStyle(backgroundColor: Colors.grey.withOpacity(.8)),):Text("",style: TextStyle(backgroundColor: Colors.red.withOpacity(.8)),)),
                  //       //         ),
                  //       //       ],
                  //       //     ),
                  //       //   );
                  //       // },
                  //       ,itemCount: posterList.length
                  //       ,physics: ScrollPhysics(),),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
  Widget getCatImage(String catId,index,String name,bool status)
  {
    //print("https://manalsoftech.in/canva_365/img/"+name);
    return InkWell(
      onTap: ()=>
      {
        if(isProfileUpdate)
          {
            displayImage=posterList[index].image,
            //sStatus=false,
            setState((){})
          }else
          {
            //sStatus=true,
            Navigator.push(context, MaterialPageRoute(builder: (_)=>Account())),
          }
      },
      child: Container(
          margin: EdgeInsets.all(4),
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(
                      imgUrl+name),fit: BoxFit.cover),
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
                  padding: status?EdgeInsets.only(left: 5,right: 5):EdgeInsets.only(left: 0,right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: Center(
                    child: status?Text("Free",style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white),):Text("",style: TextStyle(backgroundColor: Colors.red.withOpacity(.8)),),
                  ),
                )
              ],
            ),
          )),
    );
  }
  Future<void> share(dynamic link,String title) async{
    await FlutterShare.share(
        title: title,text:"It is text",linkUrl:"link",chooserTitle: 'Where you want to share'
    );
  }

  Future<File> writeFile(Uint8List data, String name) async
  {
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
    return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  sendProductImage(String anShu) async
  {
    var url = Uri.parse(webUrl+"uploadMyimage");
    var response = await http.post(url,
      headers: {
        "Accept": "application/json",
        "Content-type": "multipart/form-data",
      },
      encoding: Encoding.getByName("utf-8"),
      body: jsonEncode(<String, dynamic>
      {
        "image": anShu,
        'userId':userId,
      }
      ),);
    var body = jsonDecode(response.body);
    print(response.body);
    //print(body);
    var msg = body['msg'];

    if (body['status'] == true)
    {
      var imageName=body['imageName'];
      print("it i9s imageName:"+imageName);
      String path =imageUrl +imageName;
      GallerySaver.saveImage(path,albumName: "Download").then((value) => null);
      Fluttertoast.showToast(
        //msg: msg,
          msg: "Poster Download Complete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
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
    isApiCallingProcess=false;
    setState(()
    {
      //String path =imageUrl+;
      //GallerySaver.saveImage(path,albumName: "Download").then((value) => null);
    });
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_)=>Downloads()));
  }
}