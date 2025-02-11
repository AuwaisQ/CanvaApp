import 'package:cached_network_image/cached_network_image.dart';
import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/BottomBar.dart';
import 'package:canvas_365/others/SetupProfilePage.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
String selCat="";
class BusinessCategories extends StatefulWidget
{
  String ?selectedLanguage="";
  BusinessCategories({required this.selectedLanguage});

  @override
  State<BusinessCategories> createState() => _BusinessCategoriesState(selectedLanguage);
}

class _BusinessCategoriesState extends State<BusinessCategories>
{
  String ?userId;
  String ?selectedLanguage="";
  _BusinessCategoriesState(this.selectedLanguage);
  bool isAccount=false;
  List <NameIdBean>searchCategory = [];
  int selectCategory=0;
  String strselectCategory="";
  TextEditingController editingControllerCategory=new TextEditingController();

  var url = Uri.parse(webUrl+"displayBussinessCategory");
  var urlLanguage = Uri.parse(webUrl+"selectBussinessCategory");
  var data;
  List<dynamic> dta=[];
  String msg="";
  List<dynamic> languageListOne=[];
  List<NameIdBean> categoryList=[];
  bool isApiCallingProcess=false;
  bool ?isSelect=false;
  void getBusinessCategory() async
  {
    print(url);
    var response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },);
    data = jsonDecode(response.body);
    var status = data['status'];
    var msg = data['msg'];
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["data"];for(int i=0;i<dta.length;i++)
      {
        categoryList.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["name"], dta[i]["image"], false));
      }
      getUserData();
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
    }
    isApiCallingProcess=false;
    setState(()
    {});
  }

  void setBusinessCategory() async
  {
    print(urlLanguage);
    print("languageIds:$selectedLanguage");
    print("bcategoryid$selectCategory");
    print("userId$userId");

    setState(()
    {});
    var response = await http.post(urlLanguage,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },body: jsonEncode(<String, String>
        {
        'bcategoryId': selectCategory.toString(),
        'userId': userId!,
        }));
    print(response.body);
    data = jsonDecode(response.body);
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status)
    {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setUserData();
    } else
    {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: errorColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    isApiCallingProcess=false;
  }

  @override
  void initState()
  {
    print("Selected Languages:$selectedLanguage");
    isApiCallingProcess=true;
    getBusinessCategory();

    super.initState();
  }

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("user_id")!;
    setState((){

    });
  }

  setUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("business_category",selectCategory.toString());
    prefs.setString("bus_category",strselectCategory.toString());
    print("Now $selectedLanguage");
    selectedLanguage=="account"?Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomBar())):Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Profile()));
  }

  @override
  Widget build(BuildContext context)
  {
    return ProgressHud(build_ui(context), isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context)
  {
    ScrollController _controller;
    return Scaffold(
      floatingActionButton: new Visibility(
        child: new FloatingActionButton(
          heroTag: "businessCategory",
          onPressed: ()=>
          {
            isApiCallingProcess=true,
            setBusinessCategory()
          },
          tooltip: 'Increment',
          child: new Icon(Icons.send),
          backgroundColor: primaryColor,
        ),
        visible: isSelect!,
      ),
      backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text('Select Your Business Category',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18.8),
            ),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Container(
            child: Column(
              children: [
                ///Search Bar
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    style: TextStyle(fontSize: 15),
                    controller: editingControllerCategory,
                    onChanged: (value)
                    {
                      setState(() {
                        searchCategory=categoryList.where((element) =>element.name.toLowerCase().contains(value.toLowerCase())).toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Category',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Popular Categories',style: mainHeading2,),
                    ],),
                ),

                Container(
                    child:
                    //images != null ?
                    GridView.builder(scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //mainAxisSpacing: 15,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio: 0.85,
                          crossAxisCount: 3),
                      itemBuilder: (context, index)
                      {
                        print(imgUrl+categoryList[index].image);
                        return InkWell(
                          onTap: ()=>
                          {
                            isSelect=true,
                            if(editingControllerCategory.text.isEmpty)
                              for(int i=0;i<categoryList.length;i++)
                                {
                                  if(categoryList[i].id==categoryList[index].id)
                                    {
                                      categoryList[index].status=true,
                                      selectCategory=int.parse(categoryList[index].id),
                                      strselectCategory=categoryList[index].name,
                                      print("selected category is: $strselectCategory"),
                                      print("selected category is: $selectCategory"),
                                    }else
                                    {
                                      categoryList[i].status=false,
                                    },
                                  //setState((){})
                                }else
                              for(int j=0;j<searchCategory.length;j++)
                                {
                                  if(searchCategory[j].id==searchCategory[index].id)
                                    {
                                      searchCategory[index].status=true,
                                      selectCategory=int.parse(searchCategory[index].id),
                                    strselectCategory=searchCategory[index].name,
                                      print("selected category is: $strselectCategory"),
                                      print("selected category is: $selectCategory"),
                                    }else
                                    {
                                      searchCategory[j].status=false,
                                    },
                                  //setState((){})
                                },
                            setState((){})
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 3,color: editingControllerCategory.text.isNotEmpty?searchCategory[index].status?primaryColor:Colors.white:categoryList[index].status?primaryColor:Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                CachedNetworkImage(
                                  imageUrl: editingControllerCategory.text.isNotEmpty?imgUrl+searchCategory[index].image:imgUrl+categoryList[index].image,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                              SizedBox(height: 2,),
                              Text(
                                editingControllerCategory.text.isNotEmpty?searchCategory[index].name:categoryList[index].name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 10.0,fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      },itemCount:editingControllerCategory.text.isNotEmpty?searchCategory.length:categoryList.length,
                    physics:  NeverScrollableScrollPhysics(),)
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
