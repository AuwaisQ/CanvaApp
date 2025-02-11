import 'dart:io';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:canvas_365/others/BottomBar.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/OTP.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController contactController = TextEditingController();
  String contact = "";
  String otp = "";
  String userId = "";
  String deviceId="";
  var url = Uri.parse(webUrl + "signup");
  var data;
  List<dynamic> dta = [];
  final formKey = GlobalKey<FormState>();
  bool isApiCallingProcess = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String msg = "";
  String fcmToken="";
  @override
  void initState() {
    getToken();
    initPlatformState();
    super.initState();
  }

  getToken() async {
    fcmToken = (await FirebaseMessaging.instance.getToken())!;
    print("Your Firebase Token is:"+fcmToken);
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      {
        if (Platform.isAndroid)
        {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceId=androidInfo.androidId.toString();
          print('Running on ${deviceId}');
        } else if (Platform.isIOS)
        {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          print('Running on ${iosInfo.utsname.machine}');
        }else
          {
            WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
            print('Running on ${webBrowserInfo.userAgent}');
          }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;
    setState(() {});
  }

  void getData() async {
    print(webUrl + "signup");
    var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': contact,
        'deviceId': deviceId,
        'fcmId': fcmToken,
      }),
    );
    print(jsonEncode(<String, String>{
      'mobile': contact,
      'deviceId': deviceId,
      'fcmToken': fcmToken,
    }));
    print(response.body);
    data = jsonDecode(response.body);
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(msg);
    if (status) {
      userId = (data['userId'].toString());
      print("otp:$otp,userId:$userId");
      isApiCallingProcess = false;
      setState(() {updateUserId(userId);});
    } else {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isApiCallingProcess = false;
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(build_ui(context), isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff4f7fc),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background1.png'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DelayedDisplay(
                      delay: Duration(milliseconds: 2000),
                      slidingBeginOffset: Offset(0.0, -2.0),
                      child: Image.asset(
                        'assets/images/light1.png',
                        fit: BoxFit.cover,
                        height: height /3.2,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 2500),
                      slidingBeginOffset: Offset(0.0, -2.0),
                      child: Image.asset(
                        'assets/images/light-2.png',
                        fit: BoxFit.cover,
                        height: width/2,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: DelayedDisplay(
                        delay: Duration(milliseconds: 2600),
                        slidingBeginOffset: Offset(0.0, -2.0),
                        child: Image.asset(
                          'assets/images/clock.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height/50,),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //TODO: remove this code if any ipad
                    DelayedDisplay(
                        delay: Duration(milliseconds: 3000),
                        slidingBeginOffset: Offset(0.0, -2.0),
                        child: AnimatedImage()),
                  ],
                ),
              ),
              SizedBox(height:height/15),
              ///TexT Field
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 3000),
                  slidingBeginOffset: Offset(0.0, 2.0),
                  child: Container(
                    height: 50,
                    width: width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                              offset: Offset(0.0, 5.0)),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      children: [
                        CountryListPick(
                            appBar: AppBar(
                              backgroundColor: primaryColor,
                              title: Text('Select Country'),
                            ),
                            theme: CountryTheme(
                              labelColor: primaryColor,
                              isShowTitle: false,
                            ),
                            initialSelection: '+91',
                            useUiOverlay: false,
                            useSafeArea: false),
                        VerticalDivider(
                          thickness: 1,
                          indent: 7,
                          endIndent: 7,
                        ),
                        Expanded(
                            child: TextFormField(
                              controller: contactController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      bottom: 13, top: 11, right: 15),
                                  hintText: "Enter Mobile Number",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 15)),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height:height/100),
              //Login Button
              DelayedDisplay(
                delay: Duration(milliseconds: 3000),
                slidingBeginOffset: Offset(0.0, 2.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade800,
                          Colors.red.shade700,
                          Colors.red.shade500,
                          Colors.red.shade300,
                          Colors.red.shade100,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: BouncingWidget(
                        duration: Duration(milliseconds: 100),
                        stayOnBottom: false,
                        scaleFactor: 2,
                        onPressed: () {
                          contact = contactController.text;
                          setState(() {
                            if (contactController.text.length < 10) {
                              Fluttertoast.showToast(
                                  msg: "Invalid Mobile Number",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16);
                            } else {
                              isApiCallingProcess = true;
                              getData();
                            }
                          });
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height:height/20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DelayedDisplay(
                    delay: Duration(milliseconds: 3000),
                    slidingBeginOffset: Offset(0.0, 2.0),
                    child: Text(
                      'Terms of Services',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 3000),
                    slidingBeginOffset: Offset(0.0, 2.0),
                    child: Text(
                      'By continuing you indicate that you\nhave read and agreed to the\nTerms of Services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 3200),
                    slidingBeginOffset: Offset(0.0, 2.0),
                    child: Text(
                      'POWERED BY',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.red,
                        // fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Colors.red.shade300,
                          ),
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 8.0,
                            color: Colors.red.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 3200),
                    slidingBeginOffset: Offset(0.0, 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/digitalindia.png',
                          height: 35,
                          width: 75,
                        ),
                        Image.asset(
                          'assets/images/makeinindia.png',
                          height: 35,
                          width: 75,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  updateUserProfile() async {
    print("finally data is:");
    print(dta[0]["userId"].toString() +
        "," +
        dta[0]["bussinessName"] +
        "," +
        dta[0]["contact1"].toString() +
        "," +
        dta[0]["contact2"].toString() +
        "," +
        dta[0]["email"] +
        dta[0]["address"]);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", dta[0]["userId"].toString());

    dta[0]["businessName"]==null?"businessName":prefs.setString('businessName', dta[0]["bussinessName"]);
    dta[0]["contact1"]==null?"contact1":prefs.setString('contact1', dta[0]["contact1"]);
    dta[0]["logo"]==null?"logo":prefs.setString("logo",dta[0]["logo"]);

    dta[0]["contact2"]==null?"contact2":prefs.setString('contact2', dta[0]["contact2"]);
    dta[0]["email"]==null?"Email":prefs.setString('email', dta[0]["email"]);
    dta[0]["website"]==null?"web":prefs.setString('website', dta[0]["website"]);
    dta[0]["address"]==null?"address":prefs.setString('businessAddress', dta[0]["address"]);
    prefs.setBool("isProfileUpdate", true);
    //
    prefs.setBool("isLogin", true);
    prefs.setBool("isProfileUpdate", true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => BottomBar()));
  }

  updateUserId(String useId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", userId);
    prefs.setString("device_id", deviceId);
    otp = (data['otp']);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => OtpScreen(
              userId: userId,
              otp: otp,
              mobile_no: contact,
            )));
    //
    // prefs.setBool("isLogin", true);
    // prefs.setBool("isProfileUpdate", false);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => BottomBar()));
  }
}

class AnimatedImage extends StatefulWidget {
  const AnimatedImage({Key? key}) : super(key: key);

  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);
  late final Animation<Offset> _animation = Tween(
    begin: Offset.zero,
    end: const Offset(0, 0.08),
  ).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Image.asset(
        'assets/images/logo.png',
        height: MediaQuery.of(context).size.width/3.2,
        width: MediaQuery.of(context).size.width/3.2,
      ),
    );
  }
}
