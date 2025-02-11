import 'dart:convert';
import 'dart:io';

import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class addLogoPage extends StatefulWidget
{
  @override
  State<addLogoPage> createState() => _addLogoPageState();
}

class _addLogoPageState extends State<addLogoPage>
{
  File ?imageFile;
  var url = Uri.parse(webUrl+"updateProfileApi");
  var data;
  List<dynamic> dta=[];
  bool isApiCallingProcess=false;
  String msg="";
  String ?userId="";
  String ?logo;
  bool ?isProfileUpdate=false;

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id")!;
    isProfileUpdate = prefs.getBool("isProfileUpdate");
    if(isProfileUpdate==true)
    {
      logo=prefs.getString('logo');
      //otherI.text=prefs.getString('otherInformation').toString();
    }
    print("$isProfileUpdate:#:$logo:Contact us:");
    setState(() {

    });
  }

  @override
  void initState()
  {
    getUserData();
    setState(() {
      print("$userId:Contact us now:");
    });
    super.initState();
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
    return Scaffold(backgroundColor: backgroundColor,
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //   color: Colors.white, //change your color here
        // ),
      actions: [],
      title: Text("Upload Logo",style: TextStyle(fontFamily: "Poppins"),),backgroundColor: Colors.transparent,elevation: 0,
      ),
      body:Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(children: [
            logo==null?Container(child: Column(children: [
              imageFile==null?Icon(Icons.add,color: Colors.white,size: 300,):
              Image.file(
                imageFile!,
                fit: BoxFit.cover,
                height: 300,
              )
            ],),):
            Container(height: 300,
              child: Column(children: [
              imageFile==null?Image.network(imageUrl+logo!,height: 300,):
              Image.file(
                imageFile!,
                fit: BoxFit.cover,
                height: 300,
              )
            ],),),
  SizedBox(height: 20,),
  Text("Please upload png image for better experience",style: TextStyle(color: Colors.grey),),
            SizedBox(height: 10,),
  Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                ),
                child: TextButton(
                  onPressed:()
                  {
                    imageFile==null?_getFromGallery():sendProductImage("logo", imageFile!);
                  },child: imageFile==null?Text('Please select an image',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),):Text('Save Image',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  ),)))

          ],),
        ),
      )
 //      Column(
 //        children: [
 //      Container(margin: EdgeInsets.all(10),
 //               child:
 //       isProfileUpdate==true?InkWell(onTap: ()=>{
 //             _getFromGallery()
 //       },
 //       child:
 //       Center(
 //         child: logo==null?imageFile==null?Icon(Icons.add,color: Colors.black,size: 100,):
 //             //Container(color: Colors.white,)
 //         Image.file(
 //           imageFile!,
 //           fit: BoxFit.cover,
 //
 //         )
 //             :Image.network(imageUrl+logo!),
 //       )):Container(child: Text("update profile"),),),
 //      SizedBox(height: 10,),
 //           Container(
 //             height: 50,
 //             decoration: BoxDecoration(
 //                 color: primaryColor,
 //                 borderRadius: BorderRadius.all(Radius.circular(30.0))
 //             ),
 //             child: TextButton(
 //               onPressed:()
 //               {
 // _getFromGallery();
 //               },
 //               child: imageFile==null?Text('Please select an image',
 //                 style: TextStyle(
 //                     color: Colors.white,
 //                     fontFamily: 'Poppins',
 //                     fontSize: 15.0,
 //                     fontWeight: FontWeight.bold
 //                 ),
 //               ):InkWell(onTap: ()=>{
 //                 isApiCallingProcess=true,
 //                 sendProductImage("logo",imageFile!)
 //               },
 //                 child: Text('Upload an image now',
 //                   style: TextStyle(
 //                       color: Colors.white,
 //                       fontFamily: 'Poppins',
 //                       fontSize: 15.0,
 //                       fontWeight: FontWeight.bold
 //                   ),
 //                 ),
 //               ),
 //             ),
 //           ),
 //           Container(margin: EdgeInsets.all(10),
 //             child:
 //     isProfileUpdate==true?InkWell(onTap: ()=>{
 //           _getFromGallery()
 //     },
 //             // child:ClipRRect(borderRadius: BorderRadius.circular(10),
 //             //   //child:Container(child:imageFile!=null?Image.file(imageFile!,width: 100,):Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX8nyywqm2R2AFYjWuW3EFakhDqxoVXWkJP3uVEmJ0Tkrmpj4T1SyShi4hRtGNiKTB8p0&usqp=CAU',width: 100,),),
 //             //   child:Container(
 //             //     child:logo!=null?Image.network(imageUrl+logo!,width: 100,):
 //             //     imageFile!=null?Image.file(imageFile!,width: 100,):Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX8nyywqm2R2AFYjWuW3EFakhDqxoVXWkJP3uVEmJ0Tkrmpj4T1SyShi4hRtGNiKTB8p0&usqp=CAU',width: 100,),),
 //             // ),
 //             child:
 //             Center(
 //               child: logo==null?imageFile==null?Icon(Icons.add,color: Colors.black,size: 100,):
 //                   //Container(color: Colors.white,)
 //               Image.file(
 //                 imageFile!,
 //                 fit: BoxFit.cover,
 //
 //               )
 //                   :Image.network(imageUrl+logo!),
 //             )):Container(child: Text("update profile"),),),
 //          SizedBox(height: 10,),
 //           Container(
 //             height: 50,
 //             decoration: BoxDecoration(
 //                 color: primaryColor,
 //                 borderRadius: BorderRadius.all(Radius.circular(30.0))
 //             ),
 //             child: TextButton(
 //               onPressed:()
 //               {
 // _getFromGallery();
 //               },
 //               child: imageFile==null?Text('Please select an image',
 //                 style: TextStyle(
 //                     color: Colors.white,
 //                     fontFamily: 'Poppins',
 //                     fontSize: 15.0,
 //                     fontWeight: FontWeight.bold
 //                 ),
 //               ):InkWell(onTap: ()=>{
 //                 isApiCallingProcess=true,
 //                 sendProductImage("logo",imageFile!)
 //               },
 //                 child: Text('Upload an image now',
 //                   style: TextStyle(
 //                       color: Colors.white,
 //                       fontFamily: 'Poppins',
 //                       fontSize: 15.0,
 //                       fontWeight: FontWeight.bold
 //                   ),
 //                 ),
 //               ),
 //             ),
 //           )
 //        ],
 //      )
      ,);
  }

  writePrefUpdateProfile() async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isProfileUpdate", true);
    isProfileUpdate=true;
    setState(() {
    });
    //Navigator.pop(context,true);
  }

  _getFromGallery() async
  {
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
        // isApiCallingProcess=false;
        //sendProductImage("logo",imageFile!);
        setState(()
        {
          imageFile = File(pickedFile.path);
          _cropImage();
        });
      }
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = (await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],)) as File?;
    if (croppedFile != null)
    {
      imageFile = croppedFile;
      setState(() {
        //state = AppState.cropped;
      });
    }
  }

  sendProductImage(String imageType,File file) async
  {
    isApiCallingProcess=true;
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
      getUserData();
    });
    Navigator.pop(context,false);
  }
  setPrefProfileData(String imageName,String imageType) async
  {
    print("image response$imageName::$imageType");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(imageType,imageName);
    setState((){

    });
  }
}