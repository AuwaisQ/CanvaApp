import 'package:canvas_365/others/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class PaymentPage extends StatefulWidget
{
  String planType="";
  String planAmount="";
  String planId="";
  PaymentPage({required this.planType,required this.planAmount,required this.planId});
  @override
  _PaymentPageState createState() => _PaymentPageState(planType,planAmount,planId);
}

class _PaymentPageState extends State<PaymentPage>
{
  String planType="";
  String planAmount="";
  String planId="";
  String userId="";
  String email="";
  String contact="";
  Razorpay ?razorpay;
  _PaymentPageState(this.planType,this.planAmount,this.planId);
  var data;
  var url = Uri.parse(webUrl+"subscribedUserApi");
  bool isApiCallingProcess=false;
  String msg="";

  @override
  void initState()
  {
    print("Oh Yes! xPayment is working is here");
    isApiCallingProcess=true;
    getUserData();
    //userId="17";
    super.initState();
    razorpay = new Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay!.clear();
  }

  void handlerPaymentSuccess(PaymentSuccessResponse psr)
  {
    print("Pament success"+psr.paymentId.toString());
    //Toast.show("Pament success", context);
  }

  void handlerErrorFailure(){
    print("Pament error");
    //Toast.show("Pament error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    //Toast.show("External Wallet", context);
  }

  void openCheckout(){
    var options = {
    //'key': 'rzp_test_eZyDmPo1WPTyGy',
    'key': 'rzp_live_sop6uxg5y055jc',
    'amount': 23000,
    'name': appName,
    'description': 'Plan is here',
      'order_id':'1332',
    'prefill': {
    'contact': contact, 'email': email
    },
    'external': {
      'wallets': ['paytm']
    }
    };

    try{
      razorpay!.open(options);
    }catch(e){
      print(e.toString());
    }
  }

  void getData() async
  {
    isApiCallingProcess=true;
    print('userId: $userId ,planId: $planType,planId: $planId,activatedOn'+"03/09/2020"+',transactionId:'"BEMP1250erwi909"+',amount:$planAmount');
    var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>
      {
        'userId': userId,
        'planId':planId,
        'activatedOn':"03/09/2020",
        'transactionId':"BEMP1250erwi909",
        'amount':planAmount
      }
      ),);
    data = jsonDecode(response.body);
    print(data);
    var status = data['status'];
    var validity="";
    msg=data['msg'];
    print(status);
    if (status)
    {
      setState(()
      {
        writePref(validity);//Navigator.push(context,MaterialPageRoute(builder: (_)=>LanguageSelect()));
      });
    } else
    {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      isApiCallingProcess=false;
      // setState(()
      // {
      //
      // });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    Razorpay _razorpay = Razorpay();
    return Scaffold(appBar: AppBar(title: Text("Payment Now"),),body: Container(color: Colors.white12,child: Center(
      child: Column(children: [
        Text("Plan Id $planId",style: TextStyle(fontSize: 20),),
        Text("Plan Amount $planAmount",style: TextStyle(fontSize: 20)),
        TextButton(onPressed: ()=>{
          //getData()
        openCheckout()
        },child: Text("Click to subscribe"),style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: primaryColor)),
      ],),
    ),),);
  }


  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id")!;
    email=prefs.getString("email")!;
    contact=prefs.getString("contact1")!;
    setState(() {

    });
  }

  writePref(String validity) async
  {
    //Toast.show("Click", context, duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("validity", validity);
    prefs.setBool("isProfileUpdate", false);
    Navigator.pop(context);
  }
}