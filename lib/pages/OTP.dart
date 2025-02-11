import 'dart:async';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/LanguageSelect.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../others/BottomBar.dart';

class OtpScreen extends StatefulWidget {
  String userId = "";
  String otp = "";
  String msg = "";
  String mobile_no = "";
  //UpdateProductPage({Key key,@required this.product_id}):super(key: key);
  OtpScreen({required this.userId, required this.otp, required this.mobile_no});
  @override
  _OtpScreenState createState() => _OtpScreenState(userId, otp, mobile_no);
}

class _OtpScreenState extends State<OtpScreen> {
  _OtpScreenState(this.userId, this.otp, this.mobile_on);
  String userId = "";
  String otp = "";
  String msg = "";
  String mobile_on = "";
  int _start = 33;
  bool isApiCallingProcess = false;
  bool timerStatus = true;
  Timer? _timer;
  List<dynamic> dta = [];
  List<dynamic> subscriptionData = [];
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (timerStatus) {
          if (_start == 0) {
            setState(() {
              timer.cancel();
            });
          } else {
            setState(() {
              _start--;
            });
          }
        } else {
          _timer!.cancel();
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  var data;
  var status=false;
  var verified=false;
  var uprofile=false;
  var bprofile=false;
  var refCode="";
  var tmr = 60;
  var url = Uri.parse(webUrl + "verifyOtp");
  var resendUrl = Uri.parse(webUrl + "resendOtp");
  int otpCnt = 0;
  void getData() async {
    isApiCallingProcess = true;
    print("$userId URL IS HERE:" + url.toString());
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'userId': userId, 'otp': otp}),
    );
    data = jsonDecode(response.body);
    print(response.body);
    print(data);
    status = data['status'];
    verified = data['verified'];
    uprofile = data['uprofile'];
    bprofile = data['bprofile'];
    refCode = data['refcode'].toString();
print(data['refcode']);
print(refCode);
    String planExpiry="";
    String planName="No Plan Available";
    String planAmount="Subscribe Now";

    msg = data['msg'];
    print(status);
    print(verified);
    if (status)
    {
      setState(()
      {
        isApiCallingProcess=false;
        if(verified && uprofile)
        {
          print("aaaa");
          Map<String, dynamic> map = json.decode(response.body);
          dta = map["bdata"];
          var isSubscribe=data['issubscribe'];
          if(isSubscribe)
            {
              subscriptionData=map["subdetails"];
              planExpiry=subscriptionData[0]["endson"];
              planName=subscriptionData[0]["title"];
              planAmount=subscriptionData[0]["amount"];
            }
            updateUserProfile(isSubscribe,planName,planExpiry,planAmount,refCode);
        }else
          {
            print("bbbbb");
            writePref(refCode);
          }
        //writePref(); //Navigator.push(context,MaterialPageRoute(builder: (_)=>LanguageSelect()));
      });
    } else {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      timerStatus = false;
      isApiCallingProcess = false;
    }
  }

  updateUserProfile(var isSubscribe,  String planName,  String planExpiry,String planAmount,String refCode) async
  {
    print("finally data is:${refCode}");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refCode", refCode);
    if(bprofile)
      {
        prefs.setString("user_id", dta[0]["userId"].toString());
        dta[0]["bussinessName"]==null?"businessName":prefs.setString('businessName', dta[0]["bussinessName"]);
        dta[0]["contact1"]==null?"contact1":prefs.setString('contact1', dta[0]["contact1"]);
        dta[0]["logo"]==null?"logo":prefs.setString("logo",dta[0]["logo"]);

        dta[0]["contact2"]==null?"contact2":prefs.setString('contact2', dta[0]["contact2"]);
        dta[0]["email"]==null?"Email":prefs.setString('email', dta[0]["email"]);
        dta[0]["website"]==null?"web":prefs.setString('website', dta[0]["website"]);
        dta[0]["address"]==null?"address":prefs.setString('businessAddress', dta[0]["address"]);
        prefs.setBool("isProfileUpdate", true);
        prefs.setBool("isLogin", true);
        prefs.setBool("isSubscribed", isSubscribe);
        prefs.setString("planName", planName);
        prefs.setString("planExpiry", planExpiry);
        prefs.setString("planAmount", planAmount);

        prefs.setString("language_array", '{"lang":[{"id":"1","language":"English"},{"id":"2","language":"Hindi"}]}');
      }else
        {
          prefs.setBool("isProfileUpdate", bprofile);
          prefs.setBool("isLogin", true);
          prefs.setBool("isSubscribed", isSubscribe);
          prefs.setString("planName", planName);

          prefs.setString("planExpiry", planExpiry);
          prefs.setString("planAmount", planAmount);
          prefs.setString("language_array", '{"lang":[{"id":"1","language":"English"},{"id":"2","language":"Hindi"}]}');
        }
    print("fromShap${prefs.getString("refCode")}");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomBar()));
  }

  void sendOtp() async {
    isApiCallingProcess = true;
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
      }),
    );
    //print(response.body);
    data = jsonDecode(response.body);
    //var parsedJson = json.decode(data);
    //print('$contact');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status) {
      otp = (data['otp']);
      print("otp:$otp,userId:$userId");
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
  }

  void resendOtp() async {
    var response = await http.post(
      resendUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
      }),
    );
    //print(response.body);
    data = jsonDecode(response.body);
    //var parsedJson = json.decode(data);
    //print('$contact');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status) {
      //Map<String, dynamic> map = json.decode(response.body);
      //dta = map["data"];
      otp = (data['otp']);
      Fluttertoast.showToast(
          msg: otp,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0);
      print("otp:$otp,userId:$userId");
      otpCnt++;
      int realCnt = 5 - otpCnt;
      var msg = "you left $realCnt attempt";
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
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
    setState(() {});
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
      backgroundColor: backgroundColor,
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
              SizedBox(height: height/30,),

              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DelayedDisplay(
                        delay: Duration(milliseconds: 3000),
                        slidingBeginOffset: Offset(0.0, -2.0),
                        child: AnimatedImage())
                  ],
                ),
              ),
              SizedBox(height:height/25),

              DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                slidingBeginOffset: Offset(-2.0, 0.0),
                child: Text.rich(
                  TextSpan(text: 'OTP ', style: mainHeading, children: [
                    TextSpan(
                      text: 'Verification',
                      style: TextStyle(color: Colors.green),
                    )
                  ]),
                ),
              ),
              SizedBox(height: 10),
              DelayedDisplay(
                delay: Duration(milliseconds: 1500),
                slidingBeginOffset: Offset(-2.0, 0.0),
                child: Text.rich(
                  TextSpan(
                      text: 'Enter OTP Sent to  ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text: "******" +
                                mobile_on.substring(mobile_on.length - 4),
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.black))
                      ]),
                ),
              ),

              ///OTP Boxes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 1500),
                  slidingBeginOffset: Offset(-2.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Form(
                      child: Column(children: [
                        SizedBox(height: 30),
                        PinCodeTextField(
                          length: 5,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                              disabledColor: primaryColor),
                          animationDuration: Duration(milliseconds: 300),
                          onCompleted: (v) {
                            otp == v
                                ? //print("Match")
                            getData()
                                : showRequest();
                          }, //62S2019
                          onChanged: (value) {
                            print(value);
                            setState(() {
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                          appContext: context,
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              SizedBox(height:height/25),
              _start == 0
                  ? DelayedDisplay(
                delay: Duration(milliseconds: 500),
                child: Container(
                  height: 45.0,
                  width: MediaQuery.of(context).size.width / 2.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.shade800,
                        Colors.red.shade700,
                        Colors.red.shade500,
                        Colors.red.shade300,
                        Colors.red.shade100,
                      ],
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (otpCnt < 5) {
                        isApiCallingProcess = true;
                        setState(() {});
                        resendOtp();
                      } else {
                        Fluttertoast.showToast(
                            msg: "You reach your max attempt!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: errorColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              )
                  : InkWell(
                onTap: () => startTimer(),
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 3000),
                  slidingBeginOffset: Offset(-2.0, 0.0),
                  child: Text(
                    'Receiving OTP in ? 00:' + _start.toString(),
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // getTimer()
  // {
  //   Timer _timer = new Timer.periodic(
  //     const Duration(seconds: 1),
  //         (Timer timer) => setState(
  //           ()
  //       {
  //         if (_start < 1)
  //         {
  //           timer.cancel();
  //         } else {
  //           _start = _start - 1;
  //         }
  //       },
  //     ),
  //   );
  // }

  writePref(String refCod) async {
    //Toast.show("Click", context, duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
    print("from sharedPref${refCod}");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refCode", refCode);
    prefs.setString("user_id", userId);
    // prefs.setString("user_name", name);
    // prefs.setString("contact", contact);
    prefs.setBool("isLogin", true);
    prefs.setBool("isProfileUpdate", false);
    prefs.setString("refCode", refCod);
    // prefs.setString("email", email);
    // prefs.setBool("isLogin", true);
    // prefs.setString("wallate_balance", wallate_balance);
    // print('it is user data: $user_id saved $name and $contact');
    // //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    print("from prefrences: $userId");
    _timer!.cancel();
    Route route = MaterialPageRoute(
        builder: (context) => LanguageSelect(
          from: "OTP",
        ));
    Navigator.pushReplacement(context, route);
  }

  showRequest() {
    //startTimer();
    Fluttertoast.showToast(
        msg: "Otp Didn't match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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
        height: 125,
        width: 125,
      ),
    );
  }
}
