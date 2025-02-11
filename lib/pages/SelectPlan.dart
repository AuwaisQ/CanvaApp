// ignore_for_file: unrelated_type_equality_checks
import 'dart:io';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ProgressHud.dart';

class SelectPlan extends StatefulWidget {
  const SelectPlan({Key? key}) : super(key: key);

  @override
  _SelectPlanState createState() => _SelectPlanState();
}

class _SelectPlanState extends State<SelectPlan> {
  bool isApiCallingProcess = false;
  var url = Uri.parse(webUrl + "displaySubscriptionApi");
  var subscriveUrl = Uri.parse(webUrl + "subscribedUserApi");
  var data;
  List<dynamic> dta = [];
  List<NameIdBean> planList = [];
  String msg = "";
  String displayImage = "";
  bool _isLoading = false;
  String transactionId = "";
  String planType = "";
  String planAmount = "";
  String planId = "";
  String userId = "";
  String email = "";
  String contact = "";
  Razorpay? razorpay;
  String activatedOn = "";
  //String userId="";
  void getPlan() async {
    print(url);
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    //print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status) {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["plans"];
      //print(dta[0]["title"]);
      // for(int i=0;i<dta.length;i++)
      // {
      //   planList.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["title"], dta[i]["imgpath"], true));
      // }
      setState(() {});

      print(dta.length.toString());
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
  }

  void getData() async {
    isApiCallingProcess = true;
    print(
        '$subscriveUrl userId: $userId ,planType: $planType,planId: $planId,activatedOn' +
            "03/09/2020" +
            ',transactionId:$transactionId"+,amount:$planAmount');
    var response = await http.post(
      subscriveUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'planId': planId,
        'activatedOn': activatedOn,
        'transactionId': transactionId,
        'amount': planAmount
      }),
    );
    data = jsonDecode(response.body);
    print(data);
    var status = data['status'];
    var validity = "";
    msg = data['msg'];
    print(status);
    if (status) {
      isApiCallingProcess = false;
      setIsSubscribed(true);
      setState(() {
        //writePref(validity);//Navigator.push(context,MaterialPageRoute(builder: (_)=>LanguageSelect()));
      });
      Navigator.pop(context);
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
      // setState(()
      // {
      //
      // });
    }
  }

  @override
  void initState() {
    print("Payment is working is here");
    isApiCallingProcess = true;
    getUserData();
    //userId="17";
    razorpay = new Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    getPlan();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay!.clear();
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    transactionId = response.paymentId.toString();
    print("response id is here:$transactionId");
    getData();
    // Fluttertoast.showToast(
    //     msg: "Success",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: successColor,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
  }

  void handlerErrorFailure() {
    print("Pament error");
    Fluttertoast.showToast(
        msg: "error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: errorColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void handlerExternalWallet() {
    Fluttertoast.showToast(
        msg: "Wallet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: successColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void openCheckout(String amt) {
    var options = {
      'key': 'rzp_live_sop6uxg5y055jc',
      'amount': amt,
      'name': appName,
      'description': 'Plan is here',
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay!.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id")!;
    email = prefs.getString("email")!;
    contact = prefs.getString("contact1")!;
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Package',
          style: TextStyle(fontSize: 23,fontFamily: 'Poppins',color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Find the right spot for your brand',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Choose the right plan for you',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey, fontFamily: 'Poppins'),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Slider
                CarouselSlider(
                    items: List.generate(dta.length, (index) => getPlanCard(index)),
                    ///Logo Image
                    options: CarouselOptions(
                        height: 630,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9)),

                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getPlanCard(index) {
    final tagName = dta[index]["details"];
    final split = tagName.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    int amt = 0;
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              image: DecorationImage(
                  image: NetworkImage(imgUrl + dta[index]["poster"])),
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 23,horizontal: 5),
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2)),
            child: Center(
                child: InkWell(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      //Razor Pay
                      activatedOn = "05/05/2021";
                      planId = dta[index]["id"].toString();
                      planType = dta[index]["title"];
                      amt = int.parse(dta[index]["rate"]) * 100;
                      print('Rate Hai ye Bhai $amt');
                      // amt = 1000 * 100;
                      planAmount = dta[index]["rate"].toString();
                      openCheckout(amt.toString());
                    } else {
                      print('Apple Pay Triggered');
                      //Apple Pay
                      try{
                        setState(()=>isApiCallingProcess = true);
                        await Purchases.purchaseProduct('canvaz_999_1y');
                        setState(()=>isApiCallingProcess = false);
                      } catch(e){
                        print(e);
                        setState(()=>isApiCallingProcess = false);
                      }
                    }
                  },
                  child: Text(
                    'CHOOSE  PLAN',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 20),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  getList(String dtta) {
    return Row(
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(
                Icons.done_rounded,
                color: Colors.lightBlue,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                dtta,
                style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  setIsSubscribed(bool isSub) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isSubscribed", isSub);
    prefs.setBool("isFirstTime", false);
    print("it is inSub:$isSub");
    setState(() {});
  }
}
