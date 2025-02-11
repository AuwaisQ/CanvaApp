import 'dart:convert';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:http/http.dart' as http;
import 'package:canvas_365/others/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnquiryPage extends StatefulWidget
{
  @override
  State<EnquiryPage> createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage>
{
  String ?userId,title,message;
  bool isApiCallingProcess=false;
  var urlFeedback = Uri.parse(webUrl+"feedback");
  TextEditingController titleController=new TextEditingController();
  TextEditingController messageController=new TextEditingController();
  var data;
  final formKey = GlobalKey<FormState>();
  void setFeedback() async
  {
    print("languageIds:$title");
    print("bcategoryid$message");
    print("userId$userId");
    print(urlFeedback);
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
    var response = await http.post(urlFeedback,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
          'title': title!,
          'message': message!,
          'userId': userId!,
        }));
    print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
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
      //setUserData();
    } else
    {
      //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
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
    Navigator.pop(context);
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomBar()));
  }

  @override
  void initState()
  {
    //isApiCallingProcess=true;
    getUserData();
    super.initState();
  }

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("user_id")!;
    setState((){

    });
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
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.transparent,
      //   elevation: 0,
      //   child: Padding(
      //     padding: const EdgeInsets.all(20.0),
      //     child: Container(
      //       height: 35,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(20),
      //             color: primaryColor,
      //       ),
      //       child: Center(child: Text('Send Feedback',
      //         style: TextStyle(color: Colors.white,fontFamily: font,fontSize: 12),
      //       ),),
      //     ),
      //   ),
      // ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text('Enquiry',style: mainHeading2,),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text('Enter Subject',style: headTitle,),
              SizedBox(height: 10,),
              ///1st Text Field
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [new BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4),],
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: titleController,
                  cursorColor: Colors.black,
                  validator: (value){
                    if(value!.isEmpty)
                    {
                      return 'Enter Subject';
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
                      hintText: "Subject",
                      hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Text('Enter Description',style: headTitle,),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [new BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4),],
                  color: Colors.white,
                ),
                child: TextFormField(
                  minLines: 1,//Normal textInputField will be displayed
                  maxLines: 5,// when user presses enter it will adapt to it
                  textAlign: TextAlign.start,
                  controller: messageController,
                  cursorColor: Colors.black,
                  validator: (value){
                    if(value!.isEmpty)
                    {
                      return 'Enter Description';
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
                      hintText: "Description",
                      hintStyle: TextStyle(fontFamily: 'Poppins',fontSize: 18)
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: primaryColor),
                    child: TextButton(
                        child: Text(
                          'Send Now',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),onPressed: ()=>{
                      if(formKey.currentState!.validate())
                        {
                          title=titleController.text,
                          message=messageController.text,
                          isApiCallingProcess=true,
                          setFeedback(),
                          //Navigator.push(context, MaterialPageRoute(builder: (_)=>LoadMarket()))
                        },}),
                  ),
                ],
              )
            ],),
        ),
      ),
    );
  }
}
