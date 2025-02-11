import 'package:canvas_365/beans/TestBean.dart';
import 'package:canvas_365/others/BottomBar.dart';
import 'package:canvas_365/others/SetupProfilePage.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/CelebrityView.dart';
import 'package:canvas_365/pages/MainPage.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
String selCat="";
class CelebrityList extends StatefulWidget
{
  //const BusinessCategories({Key? key}) : super(key: key);
  @override
  State<CelebrityList> createState() => _CelebrityListState();
}

class _CelebrityListState extends State<CelebrityList>
{
  String ?userId;
  String ?selectedLanguage="";
  _CelebrityListState();

  bool isAccount=false;
  List <TestNameIdBean>searchCategory = [];
  int selectCategory=0;
  String strselectCategory="";
  TextEditingController editingControllerCategory=new TextEditingController();

  var url = Uri.parse(webUrl+"getcelebrityList");
  var urlLanguage = Uri.parse(webUrl+"selectBussinessCategory");
  var data;
  List<dynamic> dta=[];
  String msg="";
  List<dynamic> languageListOne=[];
  List<TestNameIdBean> categoryList=[];
  bool isApiCallingProcess=false;
  bool ?isSelect=false;
  void getBusinessCategory() async
  {
    print(url);
    var response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },);
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
      for(int i=0;i<dta.length;i++)
      {
        categoryList.add(new TestNameIdBean(dta[i]["id"].toString(),dta[i]["celebrity_name"],dta[i]["title"],dta[i]["image"], false));
      }
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

  // void setBusinessCategory() async
  // {
  //   //selectedLanguage="1,"+selectedLanguage!;
  //   print(urlLanguage);
  //   print("languageIds:$selectedLanguage");
  //   print("bcategoryid$selectCategory");
  //   print("userId$userId");
  //
  //   setState(()
  //   {
  //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  //   });
  //   var response = await http.post(urlLanguage,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },body: jsonEncode(<String, String>
  //       {
  //         'bcategoryId': selectCategory.toString(),
  //         'userId': userId!,
  //       }));
  //   print(response.body);
  //   data = jsonDecode(response.body);
  //   //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
  //   print(data);
  //   var status = data['status'];
  //   var msg = data['msg'];
  //   print(status);
  //   if (status)
  //   {
  //     Fluttertoast.showToast(
  //         msg: msg,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: successColor,
  //         textColor: Colors.white,
  //         fontSize: 16.0
  //     );
  //     setUserData();
  //   } else
  //   {
  //     //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
  //     Fluttertoast.showToast(
  //         msg: msg,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: errorColor,
  //         textColor: Colors.white,
  //         fontSize: 16.0
  //     );
  //   }
  //   isApiCallingProcess=false;
  //   //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomBar()));
  //   //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Profile()));
  // }

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
    //Toast.show("Click", context, duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
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
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context)
  {
    ScrollController _controller;
    return Scaffold(
      //if(isSelect==true)?floatingActionButton: FloatingActionButton(onPressed: ()=>{},child: Text("Next"),),else{},
      // floatingActionButton: new Visibility(
      //   child: new FloatingActionButton(
      //     heroTag: "businessCategory",
      //     onPressed: ()=>
      //     {
      //       //print("$selectCategory Selected Options:$selectedLanguage"),
      //       isApiCallingProcess=true,
      //       setBusinessCategory()
      //     },
      //     },
      //     tooltip: 'Increment',
      //     child: new Icon(Icons.send),
      //     backgroundColor: primaryColor,
      //   ),
      //   visible: isSelect!,
      // ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed:(){Navigator.pop(context);},
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(onPressed:()
          {
            //print("language: $selectedLanguage");
            //print("category: $selCat");
          Navigator.push
          (context,
            MaterialPageRoute(builder: (context) => MainPage())
          );
        },
          icon: Icon(Icons.arrow_forward_ios,color: Colors.black,))],
        title: Text('Celebrity List',
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
                    //decoration: InputDecoration(hintText: "Search Category",border: OutlineInputBorder(),contentPadding: EdgeInsets.only(left: 10,top: 5,bottom: 5)),
                    decoration: InputDecoration(
                      hintText: 'Search Celebrate',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [Text('Popular Categories',style: mainHeading2,),
                //       // isSelect==true?Container(
                //       //   height: 40,
                //       //   decoration: BoxDecoration(
                //       //       borderRadius: BorderRadius.circular(7),
                //       //       color: primaryColor),
                //       //   child: Center(
                //       //     child: Padding(
                //       //       padding: const EdgeInsets.all(8.0),
                //       //       child: Row(
                //       //         mainAxisAlignment: MainAxisAlignment.center,
                //       //         children: [
                //       //           InkWell(
                //       //             onTap: ()=>{
                //       //             print("$selectCategory Selected Options:$selectedLanguage"),
                //       //             isApiCallingProcess=true,
                //       //               setUserLanguage()
                //       //               // Navigator.pushReplacement
                //       //               //   (context,
                //       //               //     MaterialPageRoute(builder: (context) => MainPage())
                //       //               // )
                //       //             },
                //       //             child:
                //       //             Row(
                //       //               children :[Text('Next',style: TextStyle(color: Colors.white, fontSize: 15)),Icon(Icons.arrow_right_alt_sharp,color: Colors.white,size: 20,)],
                //       //             ),
                //       //           ),
                //       //         ],
                //       //       ),
                //       //     ),
                //       //   ),
                //       // ):SizedBox(width: 5,)
                //     ],),
                // ),

                Container(
                    child:
                    //images != null ?
                    GridView.builder(scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //mainAxisSpacing: 15,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio: 0.75,
                          crossAxisCount: 2),
                      itemBuilder: (context, index)
                      {
                        //print(imgUrl+categoryList[index].image);
                        return Card(
                          elevation: 10,
                          child: Column(children: [
                            InkWell(
                              onTap:() {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration: Duration(milliseconds: 1000),
                                      reverseTransitionDuration: Duration(milliseconds: 500),
                                      pageBuilder: (_,__,___) => CelebrityView(id: categoryList[index].id,)),
                                  // MaterialPageRoute(
                                  //     builder: (context) => const CelebrityView())
                                );
                              },
                              child: Hero(
                                tag: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(editingControllerCategory.text.isNotEmpty?imgUrl+searchCategory[index].image:imgUrl+categoryList[index].image,fit: BoxFit.contain,

                                  ),),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              height: 35,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      spreadRadius: 5
                                  )],
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child:Center(
                                child: Text(editingControllerCategory.text.isNotEmpty?searchCategory[index].name:categoryList[index].name,style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16),),
                              ),
                            ),
                          ],),
                        );
                          // Container(
                          //   margin: EdgeInsets.all(10),
                          //   decoration: BoxDecoration(
                          //       borderRadius: const BorderRadius.only(
                          //           topLeft: Radius.circular(10),
                          //           topRight: Radius.circular(10),
                          //           bottomLeft: Radius.circular(10),
                          //           bottomRight: Radius.circular(10)),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.grey.withOpacity(0.6), //color of shadow
                          //           spreadRadius: 2, //spread radius
                          //           blurRadius: 7, // blur radius
                          //           offset:const Offset(0, 2), // changes position of shadow
                          //           //first paramerter of offset is left-right
                          //           //second parameter is top to down
                          //         ),
                          //         //you can set more BoxShadow() here
                          //       ],
                          //       color: Colors.black,
                          //       border: Border.all(color: Colors.black)),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //         height: 190,
                          //         width: 160,
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(4),
                          //             image: DecorationImage(
                          //                 image: NetworkImage(editingControllerCategory.text.isNotEmpty?imgUrl+searchCategory[index].image:imgUrl+categoryList[index].image),
                          //                 fit: BoxFit.cover)),
                          //         child: MaterialButton(
                          //           onPressed: () {},
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.only(left: 10),
                          //         child: Container(
                          //           height: 40,
                          //           width: 130,
                          //           decoration: BoxDecoration(
                          //               color: Colors.white,
                          //               borderRadius: BorderRadius.circular(25)),
                          //           child: TextButton(
                          //             onPressed: () {
                          //               // Navigator.push(
                          //               //     context,
                          //               //     MaterialPageRoute(
                          //               //         builder: (context) => const Otp()));
                          //             },
                          //             child:
                          //             InkWell(child: Text(editingControllerCategory.text.isNotEmpty?searchCategory[index].name:categoryList[index].name,
                          //               style: TextStyle(
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 15,
                          //               ),
                          //
                          //             ),
                          //               onTap: ()=>
                          //             {
                          //               Navigator.push(
                          //                 context,
                          //                 PageRouteBuilder(
                          //                     transitionDuration: Duration(milliseconds: 1000),
                          //                     reverseTransitionDuration: Duration(milliseconds: 500),
                          //                     pageBuilder: (_,__,___) => CelebrityView(id: editingControllerCategory.text.isNotEmpty?searchCategory[index].id:categoryList[index].id)),
                          //                 // MaterialPageRoute(
                          //                 //     builder: (context) => const CelebrityView())
                          //               )
                          //             }),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );

                      },itemCount:editingControllerCategory.text.isNotEmpty?searchCategory.length:categoryList.length,
                      //},itemCount:2,
                      physics:  NeverScrollableScrollPhysics(),)
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: backgroundColor,
//     appBar: AppBar(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       leading: IconButton(onPressed:(){Navigator.pop(context);},
//         icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//       ),
//       // actions: [
//       //   IconButton(onPressed:()
//       //   {
//       //     //print("language: $selectedLanguage");
//       //     //print("category: $selCat");
//       //   Navigator.push
//       //   (context,
//       //     MaterialPageRoute(builder: (context) => MainPage())
//       //   );
//       // },
//       //   icon: Icon(Icons.arrow_forward_ios,color: Colors.black,))],
//       title: Text('Select Your Business Category',
//         style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontSize: 14.8),
//       ),
//     ),
//     body: Home(),
//   );
// }
}

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home>
// {
//
// }
