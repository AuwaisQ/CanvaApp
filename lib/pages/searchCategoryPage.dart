import 'dart:convert';

import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/BrandFeed.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class searchCategoryPage extends StatefulWidget
{
  @override
  State<searchCategoryPage> createState() => _searchCategoryPageState();
}

class _searchCategoryPageState extends State<searchCategoryPage>
{
  bool isApiCallingProcess=false;
  List <NameIdBean>searchCategory = [];
  int selectCategory=0;
  TextEditingController editingControllerCategory=new TextEditingController();
  List<NameIdBean> categoryList=[];
  bool ?isSelect=false;

  var url = Uri.parse(webUrl+"displayCategory");
  //var url = Uri.parse("https://manalsoftech.in/canva_365/displaySubscriptionApi");
  //var url="https://manalsoftech.in/canva_365/displaySubscriptionApi";
  var data;
  List<dynamic> dta=[];
  String msg="";

  @override
  Widget build(BuildContext context)
  {
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess);
  }

  void getBusinessCategory() async
  {
    print(url);
    var response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },);
    print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":22,"name":"Mahatma Gandhi"},{"id":23,"name":"Ayurveda"},{"id":24,"name":"Navratri"},{"id":25,"name":"Positive Life"}],"status":true,"msg":"success"}');
    //print(data);
    var status = data['status'];
    var msg = data['msg'];
    //print(status);
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      //Map<String, dynamic> map = json.decode('{"data":[{"id":22,"name":"Mahatma Gandhi"},{"id":23,"name":"Ayurveda"},{"id":24,"name":"Navratri"},{"id":25,"name":"Positive Life"}],"status":true,"msg":"success"}');
      dta = map["data"];
      //print(dta[0]["name"]);


      for(int i=0;i<dta.length;i++)
      {
        categoryList.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["name"], dta[i]["name"], false));
      }
      //print(dta.length.toString());

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
  void initState() {
    getBusinessCategory();
    super.initState();
  }

  @override
  Widget build_ui(BuildContext context)
  {
    ScrollController _controller;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Select Your Category',
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
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: editingControllerCategory,
                    onChanged: (value)
                    {
                      setState(()
                      {
                        searchCategory=categoryList.where((element) =>element.name.toLowerCase().contains(value.toLowerCase())).toList();
                      });
                    },
                    //decoration: InputDecoration(hintText: "Search Category",border: OutlineInputBorder(),contentPadding: EdgeInsets.only(left: 10,top: 5,bottom: 5)),
                    decoration: InputDecoration(
                      hintText: 'Search Category',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),),
                ),
                Container(
                  margin:EdgeInsets.all(10),
                    child:
                    Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: List.generate(editingControllerCategory.text.isNotEmpty?searchCategory.length:categoryList.length, (index)
                    {
                      return InkWell(
                        onTap: ()=>
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>BrandFeed(categoryId: editingControllerCategory.text.isNotEmpty?searchCategory[index].id:categoryList[index].id,displayImage: "none",categoryName:
                          editingControllerCategory.text.isNotEmpty?searchCategory[index].name:categoryList[index].name,)))
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 3),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                            ),
                          ],
                          color: Colors.white,
                        ),
                            child: Text(editingControllerCategory.text.isNotEmpty?searchCategory[index].name:categoryList[index].name,style:TextStyle(fontSize: 16,fontWeight: FontWeight.w300))),
                      );}),)
                    //images != null ?

                    // GridView.builder(scrollDirection: Axis.vertical,
                    //   shrinkWrap: true,
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     //mainAxisSpacing: 15,
                    //       crossAxisSpacing: 5.0,
                    //       mainAxisSpacing: 5.0,
                    //       childAspectRatio: 0.85,
                    //       crossAxisCount: 3),
                    //   itemBuilder: (context, index)
                    //   {
                    //     //print(imgUrl+categoryList[index].image);
                    //     return InkWell(
                    //       onTap: ()=>
                    //       {
                    //         isSelect=true,
                    //         if(editingControllerCategory.text.isEmpty)
                    //           for(int i=0;i<categoryList.length;i++)
                    //             {
                    //               if(categoryList[i].id==categoryList[index].id)
                    //                 {
                    //                   categoryList[index].status=true,
                    //                   selectCategory=int.parse(categoryList[index].id),
                    //                   //print("selected category is: $selectCategory"),
                    //                 }else
                    //                 {
                    //                   categoryList[i].status=false,
                    //                 },
                    //               //setState((){})
                    //             }else
                    //           for(int i=0;i<searchCategory.length;i++)
                    //             {
                    //               if(searchCategory[i].id==searchCategory[index].id)
                    //                 {
                    //                   searchCategory[index].status=true,
                    //                   selectCategory=int.parse(searchCategory[index].id),
                    //                   //print("selected category is: $selectCategory"),
                    //                 }else
                    //                 {
                    //                   searchCategory[i].status=false,
                    //                 },
                    //               //setState((){})
                    //             },
                    //         setState((){})
                    //       },
                    //       child: Column(
                    //         children: [
                    //           Container(
                    //             height: 100,
                    //             width: 100,
                    //             decoration: BoxDecoration(
                    //               //border: Border.all(width: 3,color: categoryList[index].status?primaryColor:Colors.white),
                    //                 border: Border.all(width: 3,color: editingControllerCategory.text.isNotEmpty?searchCategory[index].status?primaryColor:Colors.white:categoryList[index].status?primaryColor:Colors.white),
                    //                 borderRadius: BorderRadius.circular(10),
                    //             ),
                    //           ),
                    //           Text(
                    //             editingControllerCategory.text.isNotEmpty?searchCategory[index].name:categoryList[index].name,
                    //             //categoryList[index].name,
                    //
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontFamily: 'Poppins',
                    //                 fontSize: 10.0,fontWeight: FontWeight.bold),
                    //           )
                    //         ],
                    //       ),
                    //     );
                    //   },
                    //   itemCount:editingControllerCategory.text.isNotEmpty?searchCategory.length:categoryList.length
                    //   ,
                    //
                    //   physics:  NeverScrollableScrollPhysics(),)
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}