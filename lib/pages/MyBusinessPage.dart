import 'dart:convert';
import 'dart:io';

import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/EditBusinessPage.dart';
import 'package:canvas_365/pages/Login.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ProgressHud.dart';
import 'SelectPlan.dart';
import 'package:intl/intl.dart';
class MyBusiness extends StatefulWidget {
  @override
  _MyBusinessState createState() => _MyBusinessState();
}
class _MyBusinessState extends State<MyBusiness>
{
  String ?businessName,contact1,contact2,email,website,bussinessAddress,otherInformation,userId,imageOne,imageTwo,logo;
  bool isProfileUpdate=false;
  bool isSubscribed=false;
  File ?imageFile,prodImageFile;
  bool isApiCallingProcess=false;
  get failureColor => null;
  String planName="",planExpiry="",planAmount="";
  sendProductImage(String imageType,File file) async
  {
    var url = Uri.parse(webUrl+"updateProfileImageApi");
    //File file=File(imageFile);
    var base64Image = base64Encode(file.readAsBytesSync());
    //print (userId);
    //print (imageType);
    print (base64Image);
    var response = await http.post(url,
      headers: {
        "Accept": "application/json",
        "Content-type": "multipart/form-data",
      },
      encoding: Encoding.getByName("utf-8"),
      body: jsonEncode(<String, dynamic>
      {
        "image": base64Image,
        'userId':userId,
        'imageType':imageType
      }
      ),);
    var body = jsonDecode(response.body);
    print(response.body);
    //print(body);
    var msg = body['msg'];

    if (body['status'] == true)
    {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
      String imageName=body['imageName'];
      setPrefProfileData(imageName,imageType);
    } else {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: failureColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    isApiCallingProcess=false;
    setState(()
    {

    });
    Navigator.pop(context);
  }

  @override
  void initState()
  {
    getPrefProfileData();
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Log Out',style: TextStyle(color: primaryColor),),
          content: Text('Do you want to logout Canva-365?'),
          actions:[
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green),),
              onPressed: () =>
                  Navigator.of(context).pop(false),
              //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () => exitApp(),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess,opacity: 0.3,);
  }

  @override
  Widget build_ui(BuildContext context)
  {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        actions: [
          Container(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey
                  )
                  ]
              ),
              child: TextButton(onPressed: (){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => EditBusinessPage())
                );
              },
                child: Text('Edit Profile',style:
                TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,color: Colors.black,
                    fontWeight: FontWeight.bold),),),
            ),
          ),
        ),],
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: IconButton(onPressed: (){Navigator.pop(context);},
        // icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: 18,),
        // ),
        title: Text('My Business',style: TextStyle(fontFamily: 'Poppins'),),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top:20,left: 15,right: 15),
            child: Container(
              width: double.infinity,
              child: Column(children: [
              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(5),
                        child:
                        logo==null?imageFile==null?Icon(Icons.add,color: Colors.white,size: 100,):
                        ClipRRect(borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                            height: 100,width: 100,
                          ),
                        ):ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.network(imageUrl+logo!,width: 100,height: 100,fit: BoxFit.cover,)
                        ),
                        // Image.file(
                        //   imageFile!,
                        //   fit: BoxFit.cover,
                        //   height: 100,width: 100,
                        // ),
                      ),
            //       ClipRRect(borderRadius: BorderRadius.circular(5),
            //   child:
            //   imageFile==null?Icon(Icons.add,color: Colors.black,size: 100,):
            //   ClipRRect(borderRadius: BorderRadius.circular(10),
            //     child: Image.file(
            //       imageFile!,
            //       fit: BoxFit.cover,
            //       height: 100,width: 100,
            //     ),
            //   ),
            //   // Image.file(
            //   //   imageFile!,
            //   //   fit: BoxFit.cover,
            //   //   height: 100,width: 100,
            //   // ),
            // ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 200, child: Text(businessName!=null?businessName!:"Name here",style: TextStyle(fontFamily: 'Poppins',fontSize: 15,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                        SizedBox(height: 2,),
                          Container(width: 200, child: Text(contact1!=null?contact1!:"Contact will be there",style: TextStyle(fontFamily: 'Poppins',fontSize: 15,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                          SizedBox(height: 2,),
                          Container(width: 200, child: Text(bussinessAddress!=null?bussinessAddress!:"Contact will be there",style: TextStyle(fontFamily: 'Poppins',fontSize: 15,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                          SizedBox(height: 2,),
                        Container(width: 200,child: Text(email!=null?email!:"Email will be there",style: TextStyle(fontFamily: 'Poppins',fontSize: 15,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                          SizedBox(height: 2,),
                            Container(width: 200, child: Text(website!=null?website!:"Website will be there",style: TextStyle(fontFamily: 'Poppins',fontSize: 15,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,))
                        // Row(
                        //   children: [
                        //   Icon(Icons.location_on_outlined,color: primaryColor,),
                        //   Text('Ujjain',style: TextStyle(fontFamily: 'Poppins',fontSize: 12),)
                        // ],),
                      ],),

                      // Container(
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Container(
                      //       height: 35,width: 55,
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(20),
                      //           boxShadow: [BoxShadow(
                      //               blurRadius: 5,
                      //               color: Colors.grey
                      //           )
                      //           ]
                      //       ),
                      //       child: TextButton(onPressed: (){
                      //         Navigator.pushReplacement(context,
                      //             MaterialPageRoute(builder: (context) => EditBusinessPage())
                      //         );
                      //       },
                      //         child: Text('Edit',style:
                      //         TextStyle(
                      //             fontFamily: 'Poppins',
                      //             fontSize: 18,color: Colors.black,
                      //             fontWeight: FontWeight.bold),),),
                      //     ),
                      //   ),
                      // ),

                      // Container(
                      //   height: 35,width: 55,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(20),
                      //     boxShadow: [BoxShadow(
                      //       blurRadius: 5,
                      //       color: Colors.grey
                      //     )
                      //     ]
                      //   ),
                      //   child: TextButton(onPressed: (){
                      //     Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => EditBusinessPage())
                      //     );
                      //   },
                      //   child: Text('Edit',style:
                      //   TextStyle(
                      //       fontFamily: 'Poppins',
                      //       fontSize: 18,color: Colors.black,
                      //       fontWeight: FontWeight.bold),),),
                      // )

                    ],),
                SizedBox(height: 20,),
                !isSubscribed
                ? Card(
                  elevation: 5,
                  child: DottedBorder(
                    color: primaryColor,
                    strokeWidth: 1.0,
                    strokeCap: StrokeCap.round,
                    dashPattern: [6, 3],
                    radius: Radius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('You have not selected any Plan yet!',style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'Poppins',),),
                            SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(onPressed: (){
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => SelectPlan())
                                );
                              },
                                child: Text('Select Plan',style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: 'Poopins'),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                : Card(
                  elevation: 5,
                  child: DottedBorder(
                    color: primaryColor,
                    strokeWidth: 3.0,
                    strokeCap: StrokeCap.round,
                    dashPattern: [7, 7],
                    radius: Radius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$planName Plan Activated',style: TextStyle(color: Colors.black,fontSize: 20,fontFamily: 'Poppins'),),
                            SizedBox(height: 5,),
                            Container(height: 1,color: Colors.grey,),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Plan Price',style: TextStyle(color: Colors.black,fontSize: 15,fontFamily: 'Poppins'),),
                                Text('₹$planAmount',style: TextStyle(color: Colors.red,fontSize: 15,fontFamily: 'Poppins',),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Plan Expiry Date',style: TextStyle(color: Colors.black,fontSize: 15,fontFamily: 'Poppins'),),
                                Text(changeDF(planExpiry),style: TextStyle(color: primaryColor,fontSize: 15,fontFamily: 'Poppins',),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getPrefProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    businessName=prefs.getString('businessName');
    contact1=prefs.getString('contact1');
    contact2=prefs.getString('contact2');
    email=prefs.getString('email');
    website=prefs.getString('website');
    userId=prefs.getString("user_id");
    bussinessAddress=prefs.getString('businessAddress');
    otherInformation=prefs.getString('otherInformation');
    imageOne=prefs.getString('product_one');
    imageTwo=prefs.getString('product_two');
    logo=prefs.getString('logo');
    isProfileUpdate = prefs.getBool("isProfileUpdate")!;
    isSubscribed=prefs.getBool("isSubscribed")!;

    if(isSubscribed==true)
      {
        planName=prefs.getString("planName")!;
        planExpiry=prefs.getString("planExpiry")!;
        planAmount=prefs.getString("planAmount")!;
      }


    print("it is userId$userId");
    setState((){

    });
  }

  setPrefProfileData(String imageName,String imageType) async {
    print("image response$imageName::$imageType");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(imageType,imageName);
    setState((){});
  }

  _getFromGallery(int val) async {
    if(!isProfileUpdate)
    {
      Fluttertoast.showToast(
          msg: "Please update profile first!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(context,MaterialPageRoute(builder: (_)=>EditBusinessPage()));
      return;
    }

    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null)
    {
      setState(()
      {
        if(val==1)
          {
            imageFile = File(pickedFile.path);
          }else
            {
              prodImageFile=File(pickedFile.path);
            }

      });
    }
  }

  exitApp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    //prefs.setBool("isLogin",false);
    SystemNavigator.pop();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Login()));
    //Navigator.pop(context);
    //SystemNavigator.pop();
    exit(0);
  }

  showConfirmDialog(BuildContext contex) {
    //Toast.show("List Data $id,$index", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    Widget cancelButton = new ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(successColor),),
      child: Text("Cancel",style: TextStyle(fontFamily: "Varela",color: Colors.white),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = new ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
      child: Text("Logout",style: TextStyle(fontFamily: "Varela",color: Colors.white)),
      onPressed:  () {
        exitApp();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout",style: TextStyle(fontFamily: "Varela")),
      elevation: 5.0,
      content: Text("Are you sure you want to Log out?",style: TextStyle(fontFamily: "Varela")),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  changeDF(String ddt) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var date1 = inputFormat.parse(ddt);

    var outputFormat = DateFormat('dd-MMM-yy');
    var date2 = outputFormat.format(date1); // 2019-08-18
    return date2;
  }
}
