import 'dart:convert';

import 'package:canvas_365/beans/TestBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CelebrityView extends StatefulWidget
{
  String id;
  CelebrityView({required this.id});
  @override
  State<CelebrityView> createState() => _CelebrityViewState(id);
}


class _CelebrityViewState extends State<CelebrityView>
{
  String id;
  _CelebrityViewState(this.id);
  var url = Uri.parse(webUrl+"getcelebrityDetails");
  var enquiryUrl = Uri.parse(webUrl+"celebrityEnquiry");
  String celebrity_name="";
  String title="";
  String amount="";
  String image="";
  String description="";
  String userId="";
  var data;
  List<TestNameIdBean> categoryList=[];
  bool isApiCallingProcess=false;

  List<dynamic> dta=[];
  @override
  void initState()
  {
    super.initState();
    getUserData();
    getBusinessCategory();
  }

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id")!;
    // email=prefs.getString("email")!;
    // contact=prefs.getString("contact1")!;
    setState(() {

    });
  }

  void getBusinessCategory() async
  {
    print(url);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
          //'categoryId': categoryId.toString(),
          'celebrityId': id,
        }));
    //print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
    //print(data);
    var status = data['status'];
    var msg = data['msg'];
    //print(status);
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["celebrity"];
      print(dta);
      celebrity_name=dta[0]["celebrity_name"];
      title=dta[0]["title"];
      amount=dta[0]["amount"];
      image=dta[0]["image"];
      description=dta[0]["description"];
      setState(() {});
      // for(int i=0;i<dta.length;i++)
      // {
      //   categoryList.add(new TestNameIdBean(dta[i]["id"].toString(),dta[i]["celebrity_name"],dta[i]["title"],dta[i]["image"], false));
      // }
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

  void addCelebrityEnquiry() async
  {
    print(url);
    var response = await http.post(enquiryUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
          'userId': userId,
          'celebrityId': id,
        }));
    //print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
    //print(data);
    var status = data['status'];
    var msg = data['msg'];
    //print(status);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    isApiCallingProcess=false;
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context)
  {
    const primaryColor = Color(0xffd61313);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title:Text(celebrity_name,style: TextStyle(
            color: Colors.white,
            fontSize: 20),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(imageUrl+image,fit: BoxFit.contain,
                      height: 400,width: double.infinity,
                    ),),
                ),
                SizedBox(height: 15,),
                Text(celebrity_name,style: TextStyle(
                    color: Colors.black,
                    fontSize: 30),),
                SizedBox(height: 10,),
                Text(title,style: TextStyle(
                    color: Colors.black,
                    fontSize: 25),),
                SizedBox(height: 10,),
                Container(child: Text(description,style: TextStyle(fontSize: 18),),margin: EdgeInsets.all(5),),
                SizedBox(height: 20,),

                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Request\'s for',style: TextStyle(
                        color: Colors.black,
                        fontSize: 18),),
                    InkWell(child:
                    Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child:Center(
                          child: Text('₹5000/-',style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2,
                              fontSize: 12),),
                        )),onTap: ()=>{
                      addCelebrityEnquiry()
                    }),
                  ],
                ),
                SizedBox(height: 10,),
                SizedBox(height: 10,),
                InkWell(child:
                Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child:Center(
                      child: Text('Let\'s Talk',style: TextStyle(
                          color: Colors.white,
                          fontSize: 20),),
                    )),onTap: ()=>{
                  addCelebrityEnquiry()
                }),
              ],),
          ),
        ),
      ),
    );
  }
}