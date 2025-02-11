import 'dart:convert';
import 'dart:io';

import 'package:canvas_365/others/BottomBar.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/Login.dart';
import 'package:canvas_365/pages/addLogoPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProgressHud.dart';
final formKey = GlobalKey<FormState>();
class EditBusinessPage extends StatefulWidget
{
  @override
  _EditBusinessPageState createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {

  String ?businessName="",contact1="",contact2="",email="",website="",businessAddress="",otherInformation="";
  TextEditingController businesNameController=new TextEditingController();
  TextEditingController contact1Controller=new TextEditingController();
  TextEditingController contact2Controller=new TextEditingController();
  TextEditingController emailController=new TextEditingController();
  TextEditingController websiteController=new TextEditingController();
  TextEditingController businessAddressController=new TextEditingController();
  TextEditingController otherInformationController=new TextEditingController();
  File ?imageFile;
  var url = Uri.parse(webUrl+"updateProfileApi");
  var data;
  List<dynamic> dta=[];
  bool isApiCallingProcess = false;
  String msg="";
  String ?userId="";
  String ?logo;
  bool ?isProfileUpdate=false;

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id")!;
    isProfileUpdate = prefs.getBool("isProfileUpdate");
    if(isProfileUpdate==true)
    {
      businesNameController.text=prefs.getString('businessName').toString();
      contact1Controller.text=prefs.getString('contact1').toString();
      contact2Controller.text=prefs.getString('contact2').toString();
      emailController.text=prefs.getString('email').toString();
      websiteController.text=prefs.getString('website').toString();
      businessAddressController.text=prefs.getString('businessAddress').toString();
      logo=prefs.getString('logo');
      //otherI.text=prefs.getString('otherInformation').toString();
    }
    print("$isProfileUpdate:#:$logo:Contact us:");
    setState(() {

    });
  }

  showConfirmDialog(BuildContext contex) {
    //Toast.show("List Data $id,$index", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    Widget cancelButton = new ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(successColor),),
      child: Text("Cancel",style: TextStyle(fontFamily: "Varela",color: Colors.white),),
      onPressed:  () {
        Navigator.pop(contex);
      },
    );
    Widget continueButton = new ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
      child: Text("Delete",style: TextStyle(fontFamily: "Varela",color: Colors.white)),
      onPressed:  () async{
        final responce = await deleteAccount();
        isApiCallingProcess = true;
        print(responce);
        if(responce['status']){
         isApiCallingProcess = false;
          exitApp(context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account",style: TextStyle(fontFamily: "Varela")),
      elevation: 5.0,
      content: Text("Are You Sure You Want Delete Your Canva365 Account?",style: TextStyle(fontFamily: "Varela")),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: contex,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  exitApp(BuildContext cont) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    SystemNavigator.pop();
    Navigator.pushReplacement(cont, MaterialPageRoute(builder: (_)=>Login()));
    exit(0);
  }

  //Delete Account
  Future deleteAccount() async {
    print(userId.toString());
    print("https://canva365.com/delRecord");
    final response = await http.post(Uri.parse("https://canva365.com/delRecord"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "userId": "${userId.toString()}",
        }));
    var convertDataToJson = await jsonDecode(response.body);
    return convertDataToJson;
  }

  @override
  void initState()
  {
    getUserData();
    setState(() {
      //print("$userId:Contact us now:");
    });
    super.initState();
  }

  void getData() async
  {
    print(webUrl+"updateProfileApi");
    print("userId:$userId,businessName:$businessName,contact1:$contact1,contact2:$contact2,email:$email,website:$website,businessAddress:$businessAddress,otherInformation:$otherInformation,");
    var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>
      {
        'userId':userId.toString(),
        'businessName': businessName.toString(),
        'contact1': contact1.toString(),
        'contact2': contact2.toString(),
        'email': email.toString(),
        'website': website.toString(),
        'bussinessAddress': businessAddress.toString(),
        'otherInformation': otherInformation.toString(),
      }
      ),);
    print(response.body);
    data = jsonDecode(response.body);
    //var parsedJson = json.decode(data);
    //print('$contact');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status)
    {
      //Map<String, dynamic> map = json.decode(response.body);
      //dta = map["data"];
      //otp=(data['otp']);

      // Fluttertoast.showToast(
      //     msg: otp,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 2,
      //     backgroundColor: successColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);

      //userId=(data['userId'].toString());
      //print("otp:$otp,userId:$userId");
      isApiCallingProcess=false;
      writePrefUpdateProfile();
      // setState(()
      // {
      //
      // });
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
      isApiCallingProcess=false;
      setState(()
      {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess,opacity: 0.3,);
  }

  @override
  Widget build_ui(BuildContext context)
  {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: IconButton(onPressed: (){Navigator.pop(context,true);},
        //   icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: 18,),
        // ),
        actions: [
          Container(
            child: Align(
              alignment: Alignment.centerRight,
              child:
              isProfileUpdate==true?
          Container(
                margin: EdgeInsets.only(right: 10),
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey
                    )
                    ]
                ),
                child: TextButton(onPressed: ()
                {
                  //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => EditBusinessPage())
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>addLogoPage())
                  );
                },
                  child: Text('Manage Logo',style:
                  TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,color: primaryColor,
                      fontWeight: FontWeight.bold),),),
              ):Container(),
            ),
          )
         //  isProfileUpdate==true?
         //  IconButton(onPressed: ()=>{
         //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>addLogoPage()))
         //  }, icon: Icon(Icons.image,color: primaryColor,size: 40,)):
         //  IconButton(onPressed: ()=>{
         // Fluttertoast.showToast(
         //  msg: "Please update profile first!",
         //  toastLength: Toast.LENGTH_SHORT,
         //  gravity: ToastGravity.BOTTOM,
         //  timeInSecForIosWeb: 1,
         //  backgroundColor: errorColor,
         //  textColor: Colors.white,
         //  fontSize: 16.0)
         //  }, icon: Icon(Icons.image_not_supported,color: Colors.grey,size: 40,)),
        ],
        title: Text('Edit Business Details',style: TextStyle(fontFamily: 'Poppins'),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:20,left: 30,right: 30),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // InkWell(onTap: ()=>{
                  //   _getFromGallery()
                  // },
                  //   // child:ClipRRect(borderRadius: BorderRadius.circular(10),
                  //   //   //child:Container(child:imageFile!=null?Image.file(imageFile!,width: 100,):Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX8nyywqm2R2AFYjWuW3EFakhDqxoVXWkJP3uVEmJ0Tkrmpj4T1SyShi4hRtGNiKTB8p0&usqp=CAU',width: 100,),),
                  //   //   child:Container(
                  //   //     child:logo!=null?Image.network(imageUrl+logo!,width: 100,):
                  //   //     imageFile!=null?Image.file(imageFile!,width: 100,):Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX8nyywqm2R2AFYjWuW3EFakhDqxoVXWkJP3uVEmJ0Tkrmpj4T1SyShi4hRtGNiKTB8p0&usqp=CAU',width: 100,),),
                  //   // ),
                  //   child:Container(
                  //     height: 100,width: 100,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(50),
                  //         image: DecorationImage(
                  //           image:
                  //           NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX8nyywqm2R2AFYjWuW3EFakhDqxoVXWkJP3uVEmJ0Tkrmpj4T1SyShi4hRtGNiKTB8p0&usqp=CAU')
                  //           // imageFile==null?NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX8nyywqm2R2AFYjWuW3EFakhDqxoVXWkJP3uVEmJ0Tkrmpj4T1SyShi4hRtGNiKTB8p0&usqp=CAU'):
                  //           // Image.file(imageFile.path);
                  //           ,
                  //         )
                  //     ),
                  //   ),
                  // ),
                  //Text('Click To Add Logo',style: TextStyle(fontFamily: 'Poppins',fontSize: 12),),
                  SizedBox(height: 20,),
                  ///1st Text Field
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [new BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4),],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: businesNameController,
                      cursorColor: Colors.black,
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Enter Business Name';
                        }
                        return null;
                      },
                      decoration:
                      new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.grey,size: 24,),
                          // contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                          hintText: "Business Name",
                          hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                      ),
                    ),
                  ),

                  ///2nd Text Field
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,),],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty||value.length<10)
                        {
                          return 'Enter Correct Contact Number';
                        }
                        return null;
                      },
                      controller: contact1Controller,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      inputFormatters: [new LengthLimitingTextInputFormatter(10),],
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.phone_android_outlined,color: Colors.grey,size: 24,),
                          contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                          hintText: "Contact No. 1",
                          hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                      ),
                    ),
                  ),
                  ///3rd Text Field
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,),],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: contact2Controller,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      inputFormatters: [new LengthLimitingTextInputFormatter(10),],
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.phone_android_outlined,color: Colors.grey,size: 24,),
                          contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                          hintText: "Contact No. 2",
                          hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                      ),
                    ),
                  ),

                  ///4th TextField
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,),],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'Enter Email-Id';
                          }
                        else if(!EmailValidator.validate(value))
                          {
                            return 'Enter Valid Email-Id';
                          }
                        return null;
                      },
                      controller: emailController,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.mail_outline,color: Colors.grey,size: 24,),
                          contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                          hintText: "Email",
                          hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                      ),
                    ),
                  ),

                  ///5th TextField
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,),],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: websiteController,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.language,color: Colors.grey,size: 24,),
                          contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 18),
                          hintText: "Website",
                          hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                      ),
                    ),
                  ),

                  ///6th TextField
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,),],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Enter Business Address';
                        }
                        return null;
                      },
                      controller: businessAddressController,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.location_on_outlined,color: Colors.grey,size: 24,),
                          contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                          hintText: "Business Address",
                          hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                      ),
                    ),
                  ),

                  ///5th TextField
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,),],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: otherInformationController,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.perm_device_info,color: Colors.grey,size: 24,),
                          contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
                          hintText: "Other Information",
                          hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(30.0))
                    ),
                    child: TextButton(
                      onPressed:()
                      {
                       if(formKey.currentState!.validate())
                       {
                         businessName=businesNameController.text;
                         contact1=contact1Controller.text;
                         contact2=contact2Controller.text;
                         email=emailController.text;
                         website=websiteController.text;
                         businessAddress=businessAddressController.text;
                         otherInformation=otherInformationController.text;
                         isApiCallingProcess=true;
                         setState(() {
                           getData();
                         });
                       }
                      },
                      child: Text('Update Business Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  //Container(child: Text('Add Product Images',style: TextStyle(fontFamily: 'Poppins',fontSize: 18),)),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(30.0))
                    ),
                    child: TextButton(
                      onPressed:() {
                        showConfirmDialog(context);
                      },
                      child: Text('Delete Business Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Column(
                  //         children: [Text('Add',style: TextStyle(fontFamily: 'Poppins',fontSize: 18),),
                  //           Text('Product Images',style: TextStyle(fontFamily: 'Poppins',fontSize: 18),),
                  //         ],
                  //       ),
                  //       Container(
                  //         height: 70,width: 70,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           boxShadow: [BoxShadow(
                  //               blurRadius: 5,
                  //               color: Colors.grey.shade300
                  //           )],
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child:TextButton(onPressed: ()
                  //         {
                  //           _getFromGallery();
                  //         },
                  //           child: imageFile==null?Icon(Icons.add,color: Colors.black,size: 30,):
                  //           ClipRRect(borderRadius: BorderRadius.circular(10),
                  //             child: Image.file(
                  //               imageFile!,
                  //               fit: BoxFit.fitWidth,
                  //               height: 70,width: 70,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: 20),
                  //       Container(
                  //         height: 70,width: 70,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           boxShadow: [BoxShadow(
                  //               blurRadius: 5,
                  //               color: Colors.grey.shade300
                  //           )],
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: TextButton(onPressed: (){
                  //
                  //         },
                  //           child: Icon(Icons.add,color: Colors.black,size: 30,),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],),
            ),
          ),
        ),
      ),
    );
  }

  writePrefUpdateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('businessName',businessName.toString());
    prefs.setString('contact1',contact1.toString());
    prefs.setString('contact2',contact2.toString());
    prefs.setString('email',email.toString());
    prefs.setString('website',website.toString());
    prefs.setString('businessAddress',businessAddress.toString());
    prefs.setString('otherInformation',otherInformation.toString());
    prefs.setBool("isProfileUpdate", true);
    isProfileUpdate=true;
    setState(() {
    });
    logoConfirmation(context);
    //Navigator.pop(context,true);
  }

  _getFromGallery() async {
    if(!isProfileUpdate!)
    {
      Fluttertoast.showToast(
          msg: "Please update profile first!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }else
      {
        PickedFile? pickedFile = await ImagePicker().getImage(
          source: ImageSource.gallery,
          maxWidth: 1800,
          maxHeight: 1800,
        );
        if (pickedFile != null)
        {
          imageFile = File(pickedFile.path);
          isApiCallingProcess=true;
          sendProductImage("logo",imageFile!);
          setState(()
          {
            imageFile = File(pickedFile.path);
          });
        }
      }
  }

  sendProductImage(String imageType,File file) async {
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
      setPrefProfileData(imageName,"logo");
    } else {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    isApiCallingProcess=false;
    setState(()
    {

    });
    Navigator.pop(context);
  }

  setPrefProfileData(String imageName,String imageType) async {
    print("image response$imageName::$imageType");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(imageType,imageName);
    setState((){

    });
  }

  logoConfirmation(BuildContext context) {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Column(
              children: [
                Text('Add Logo', style: TextStyle(fontSize: 20,fontFamily: "Varela"),textAlign: TextAlign.center,),
                SizedBox(height: 10,),
              ],
            ),
            content:Text("Do you want to upload your logo?",style: TextStyle(fontSize: 15,fontFamily: 'Poppins'),),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(onTap:()=>
                    {
                      Navigator.pop(context),
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomBar()))
                    },
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.amber),child: Text("Not this time!",style: TextStyle(fontFamily: 'Varela',fontSize: 15),),padding: EdgeInsets.all(8),)),
                    SizedBox(width: 20,),
                    GestureDetector(onTap:()=>
                    {
                      Navigator.pop(context),
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>addLogoPage()))
                    },
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: primaryColor),child: Text("Update Now",style: TextStyle(fontFamily: 'Varela',color: Colors.white,fontSize: 15),),padding: EdgeInsets.all(8),)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
