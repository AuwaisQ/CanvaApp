import 'dart:convert';

import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/PaymentPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'ProgressHud.dart';
class DiscountPlans extends StatefulWidget
{
  @override
  State<DiscountPlans> createState() => _DiscountPlansState();
}

class _DiscountPlansState extends State<DiscountPlans>
{
  bool isApiCallingProcess=false;
  var url = Uri.parse(webUrl+"displaySubscriptionApi");
  var data;
  List<dynamic> dta=[];
  //List<NameIdBean> planList=[];
  String msg="";
  String displayImage="";
  //String userId="";
  void getPlan() async
  {
  print(url);
  var response = await http.get(url,
  headers: <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  });
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
  dta = map["plans"];
  //print(dta[0]["title"]);
  // for(int i=0;i<dta.length;i++)
  // {
  //   planList.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["title"], dta[i]["imgpath"], true));
  // }
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

  @override
  void initState()
  {
  isApiCallingProcess=true;
  getPlan();
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
  return Scaffold(
  appBar: AppBar(
  backgroundColor: primaryColor,
  elevation: 0,
  title: Text('Discount Plans'),
    centerTitle: true,
  ),
  body: SafeArea(
  child: Center(
  child: Column(
  children: [
    SizedBox(height: 10,),
  Text('We have some exciting plans for you!',style: TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold),),
    SizedBox(height: 10,),
    Text('Choose the right plan for you',style: TextStyle(fontSize: 15,color: Colors.grey,fontFamily: 'Poppins'),),

  SizedBox(height: 20,),
  ///Slider
  CarouselSlider(
  items:
  List.generate(dta.length, (index) =>
  getPlanCard(index)
  ),
  ///Logo Image
  options: CarouselOptions(
  height: 470,
  enableInfiniteScroll: false,
  enlargeCenterPage: true,
  viewportFraction: 0.9)
  ),

  SizedBox(height: 20,),
  // Text('OR',style: TextStyle(color: primaryColor,fontFamily: 'Poppins',fontWeight: FontWeight.bold),),
  // SizedBox(height: 20,),
  // Text('Enter Key and password to activate your\nSubscription',textAlign: TextAlign.center,
  //   style: TextStyle(color: Colors.black,fontFamily: 'Poppins',fontSize: 12),),
  // SizedBox(height: 30,),
  // Container(
  //   height: 40,width: 150,
  //   decoration: BoxDecoration(
  //       color: Colors.black,
  //       borderRadius: BorderRadius.circular(20)
  //   ),
  //   child: Center(child: Text('Activate Package',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',fontSize: 12),)),
  // ),
  ],),
  ),
  ),
  );
  }
  Widget getPlanCard(index)
  {
  final tagName = dta[index]["details"];
  final split = tagName.split(',');
  final Map<int, String> values =
  {
  for (int i = 0; i < split.length; i++)
  i: split[i]
  };
  return Padding(padding: const EdgeInsets.all(8.0),
  child: Container(
  height: 300,
  decoration: BoxDecoration(
  color: Colors.white,
  boxShadow: [BoxShadow(
  blurRadius: 5,
  color: Colors.grey
  )],
  borderRadius: BorderRadius.all(Radius.circular(10.0)),),
  child: Center(child: SingleChildScrollView(
  child: Column(children: [
  SizedBox(height: 10,),
  Text(dta[index]["title"],style: TextStyle(color: primaryColor,fontFamily: 'Poppins',fontSize: 30),textAlign: TextAlign.center,),
  SizedBox(height: 5,),
  Padding(
  padding: const EdgeInsets.all(10.0),
  child: Center(
  child: Text.rich(TextSpan(
  text:'Rs.',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
  children: <TextSpan>[
  TextSpan(
  text: dta[index]["rate"].toString(),style: TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold,decoration: TextDecoration.lineThrough)
  ),
  TextSpan(
  text: '  RS.'+dta[index]["rate"].toString(),style: TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold)
  )])),
  ),
  ),
  Text('Including GST '+dta[index]["discount"],style: TextStyle(color: Colors.black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.bold),),
  SizedBox(height: 10,),
  Container(
  height: 30,width: double.infinity,
  color: Colors.black,
  child: Center(child: Text('Special 40% flat discount applied.',
  style: TextStyle(color: Colors.white,fontFamily: 'Poppins',fontSize: 12),
  ),),
  ),
  SizedBox(height: 10,),
  Padding(
  padding: const EdgeInsets.only(left: 25.0,right: 20.0),
  child:
  Wrap(
  spacing: 6.0,
  runSpacing: 6.0,
  children:
  List.generate(values.length, (index) =>
  //Text(values[index].toString())
  getList(values[index].toString())
  ),
  )),

  SizedBox(height: 20,),
  Container(
  height: 40,width: 140,
  decoration: BoxDecoration(
  color: primaryColor,
  borderRadius: BorderRadius.circular(20)
  ),
  child: Center(child: InkWell(
  onTap: ()=>{
  Navigator.push(context, MaterialPageRoute(builder: (_)=>PaymentPage(planType:dta[index]["title"], planAmount:dta[index]["rate"].toString(),planId: dta[index]["id"].toString(),)))
  },
  child: Text('CHOOSE PLAN',style:
  TextStyle(color: Colors.white,fontFamily: 'Poppins',fontSize: 10),),
  )),
  ),
  ],),
  ),
  ),
  ),
  );
  }

  getList(String dtta)
  {
  return Row(children: [SizedBox(height: 15,),
  Padding(padding: const EdgeInsets.only(left: 10),
  child: Row(children: [
  Icon(Icons.done_rounded,color: Colors.lightBlue,size: 15,),
  SizedBox(width: 5,),
  Text(dtta,style: TextStyle(fontSize: 14,fontFamily: 'Poppins'),),
  ],),
  ),],);
  }
//
// getUserData() async
// {
//   final prefs = await SharedPreferences.getInstance();
//   userId = prefs.getString("userId")!;
// }
}
