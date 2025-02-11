import 'dart:convert';

import 'package:canvas_365/others/BottomBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
{
  String contact="",gender="Male",name="",dob="",bloodgroup="Select Blood Group",pincode=" ",address="",mail="",userId="",refferedBy="";

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id")!;
    setState(() {

    });
  }

  @override
  void initState()
  {
    getUserData();
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  bool isApiCallingProcess=false;
  Future<Null> _selectDate(BuildContext context) async
  {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(()
      {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        setState(() {

        });
      });
  }

  TextEditingController contactController=new TextEditingController();
  TextEditingController mailController=new TextEditingController();
  TextEditingController nameController=new TextEditingController();
  TextEditingController dobController=new TextEditingController();
  TextEditingController bloodgroupController=new TextEditingController();
  TextEditingController pincodeController=new TextEditingController();
  TextEditingController addressController=new TextEditingController();
  TextEditingController refferedByController=new TextEditingController();
  final formKey = GlobalKey<FormState>();
  int _radioSelected = 1;
  var url = Uri.parse(webUrl+"userProfile");
  var data;
  void getData() async
  {
    print(webUrl+"url");
    //print("userId:$userId,businessName:$businessName,contact1:$contact1,contact2:$contact2,email:$email,website:$website,businessAddress:$businessAddress,otherInformation:$otherInformation,");
    print("userId:$userId,contact:$contact:,name:$name,dob:$dob:,bloodgroup:$bloodgroup,pincode:$pincode,address:$address,mail:$mail");
    var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>
      {
        'userId':userId,
        'contact':contact,
        'name':name,
        'dob':dob,
        'bloodgroup':bloodgroup,
        'gender':gender,
        'pincode':pincode,
        'address':address,
        'refferedBy':refferedBy,
        'mail':mail,
      }
      ),);
    print("UPdated User Personal Profile:"+jsonEncode(<String, String>
    {
      'userId':userId,
      'contact':contact,
      'name':name,
      'dob':dob,
      'bloodgroup':bloodgroup,
      'gender':gender,
      'pincode':pincode,
      'address':address,
      'refferedBy':refferedBy,
      'mail':mail,
    }
    ));
    print(response.body);
    data = jsonDecode(response.body);
    // //var parsedJson = json.decode(data);
    // //print('$contact');
    // print(data);
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
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_)=>BottomBar()));
      //writePrefUpdateProfile();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text('Update Profile', style: mainHeading2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Column(
                children: [
                  // Container(
                  //   height: 100,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(50),
                  //       image: DecorationImage(
                  //           image: NetworkImage(
                  //               'https://media.istockphoto.com/vectors/profile-icon-vector-user-sign-avatar-symbol-vector-id1309693556?k=6&m=1309693556&s=612x612&w=0&h=-0jEw-RRHfKHqvUne77p_ZFtCs6dvzbDsoFnE8_tqEQ='))),
                  // ),
                  SizedBox(
                    height: 10,
                  ),

                  ///1st Text Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
                      // ],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: nameController,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: Colors.grey,
                            size: 24,
                          ),

                          hintText: "Full Name",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Enter Full Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),

                  ///2nd Text Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade300,
                      //     blurRadius: 1,
                      //   ),
                      // ],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty||value.length<10||value.length>10)
                        {
                          return 'Enter Mobile Number';
                        }
                        return null;
                      },
                      controller: contactController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                          contentPadding:
                              EdgeInsets.only(bottom: 11, top: 11, right: 15),
                          hintText: "Mobile Number",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 10),

                  ///3rd Text Field
                  Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade300,
                      //     blurRadius: 4,
                      //   ),
                      // ],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Enter Mail';
                        }
                        return null;
                      },
                      controller: mailController,
                      cursorColor: Colors.black,

                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                            size: 24,
                          ),
                          hintText: "Mail",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // boxShadow: [
                        //   new BoxShadow(
                        //     color: Colors.grey.shade300,
                        //     blurRadius: 4,
                        //   ),
                        // ],
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft, child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select Your Gender'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: _radioSelected,
                                    activeColor: primaryColor,
                                    onChanged: (value)
                                    {
                                      setState(()
                                      {
                                        _radioSelected = 1;
                                        gender = 'male';
                                      });
                                    },
                                  ),Text('Male'),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: _radioSelected,
                                      activeColor: primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected = 2;
                                          gender = 'female';
                                        });
                                      },
                                    ),
                                    Text('Female',),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: 3,
                                      groupValue: _radioSelected,
                                      activeColor: primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected = 3;
                                          gender = 'others';
                                        });
                                      },
                                    ),
                                    Text('Others'),])
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 10,),
                  ///4th TextField
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade300,
                      //     blurRadius: 4,
                      //   ),
                      // ],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10,top: 10),
                              child: Text('Select Your Date of Birth'),
                            ),
                            Spacer(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.location_city,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(2),
                              child: Text(
                                formattedDate,
                                // style: TextStyle(
                                //   color: primaryColor,
                                // ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(40)),
                              child: IconButton(icon:Icon(Icons.calendar_today,color: Colors.white,size: 14,),
                                onPressed: ()=>{
                                  _selectDate(context)
                                },
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  ///5th TextField
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade300,
                      //     blurRadius: 4,
                      //   ),
                      // ],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Enter Address';
                        }
                        return null;
                      },
                      controller: addressController,
                      cursorColor: Colors.black,

                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Colors.grey,
                            size: 24,
                          ),
                          hintText: "Residence",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade300,
                      //     blurRadius: 4,
                      //   ),
                      // ],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Enter Address';
                        }
                        return null;
                      },
                      controller: refferedByController,
                      cursorColor: Colors.black,

                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Colors.grey,
                            size: 24,
                          ),
                          hintText: "Residence",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 10),

                  ///6th TextField
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade300,
                      //     blurRadius: 4,
                      //   ),
                      // ],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty||value.length<6||value.length>6)
                        {
                          return 'Enter Valid Pin Code';
                        }
                        return null;
                      },
                      controller: pincodeController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                          hintText: "Pincode",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                    ),
                  ),

                  SizedBox(height: 10),

                  ///5th TextField
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade300,
                      //     blurRadius: 4,
                      //   ),
                      // ],
                      color: Colors.white,
                    ),
                    // child: Container(
                    //   alignment: Alignment.bottomLeft,
                    //   padding: EdgeInsets.only(left: 10),
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   height: 50,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text("Blood Group"),
                    //       DropdownButton(
                    //           underline: SizedBox(),
                    //           icon: Icon(Icons.arrow_drop_down),
                    //           iconSize: 28,
                    //           value: bloodgroup,
                    //           items: [
                    //             DropdownMenuItem(
                    //               child: Text("Select Blood Group",style: TextStyle(fontSize: 18),),
                    //               value: "Select Blood Group",
                    //             ),
                    //             DropdownMenuItem(
                    //               child: Text("A+"),
                    //               value: "A+",
                    //             ),
                    //             DropdownMenuItem(
                    //                 child: Text("O+",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                    //                 value: "O+"
                    //             ),
                    //             DropdownMenuItem(
                    //                 child: Text("B+",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                    //                 value: "B+"
                    //             ),
                    //             DropdownMenuItem(
                    //                 child: Text("AB+",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                    //                 value: "AB+"
                    //             ),
                    //             DropdownMenuItem(
                    //               child: Text("A-"),
                    //               value: "A-",
                    //             ),
                    //             DropdownMenuItem(
                    //                 child: Text("O-",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                    //                 value: "O-"
                    //             ),
                    //             DropdownMenuItem(
                    //                 child: Text("B-",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                    //                 value: "B-"
                    //             ),
                    //             DropdownMenuItem(
                    //                 child: Text("AB-",style: TextStyle(fontFamily: 'Heebo')),
                    //                 value: "AB-"
                    //             ),
                    //           ],
                    //           onChanged: (value) {
                    //             setState(() {
                    //               bloodgroup = value.toString();
                    //               print(bloodgroup);
                    //             });
                    //           }),
                    //     ],
                    //   ),
                    // ),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.only(left: 50),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 50,
                      child: DropdownButton(
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 28,
                          value: bloodgroup,
                          items: [
                            DropdownMenuItem(
                              child: Text("Select Blood Group",style: TextStyle(fontSize: 18),),
                              value: "Select Blood Group",
                            ),
                            DropdownMenuItem(
                              child: Text("A+"),
                              value: "A+",
                            ),
                            DropdownMenuItem(
                                child: Text("O+",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                                value: "O+"
                            ),
                            DropdownMenuItem(
                                child: Text("B+",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                                value: "B+"
                            ),
                            DropdownMenuItem(
                                child: Text("AB+",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                                value: "AB+"
                            ),
                            DropdownMenuItem(
                              child: Text("A-"),
                              value: "A-",
                            ),
                            DropdownMenuItem(
                                child: Text("O-",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                                value: "O-"
                            ),
                            DropdownMenuItem(
                                child: Text("B-",style: TextStyle(fontFamily: 'Poppinsregular',fontSize: 18),),
                                value: "B-"
                            ),
                            DropdownMenuItem(
                                child: Text("AB-",style: TextStyle(fontFamily: 'Heebo')),
                                value: "AB-"
                            ),
                          ],
                          onChanged: (value) {
                            bloodgroup = value.toString();
                            print(bloodgroup);
                            setState(() {
                            });
                          }),
                    ),
                    // TextFormField(
                    //   controller: bloodgroupController,
                    //   cursorColor: Colors.black,
                    //   decoration: new InputDecoration(
                    //       border: InputBorder.none,
                    //       focusedBorder: InputBorder.none,
                    //       enabledBorder: InputBorder.none,
                    //       errorBorder: InputBorder.none,
                    //       disabledBorder: InputBorder.none,
                    //       prefixIcon: Icon(
                    //         Icons.bloodtype,
                    //         color: Colors.grey,
                    //         size: 24,
                    //       ),
                    //       hintText: "Blood Group",
                    //       hintStyle:
                    //           TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                    // ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: TextButton(
                          onPressed:()
                          {
                            if(formKey.currentState!.validate())
                            {
                              contact=contactController.text;
                              name=nameController.text;
                              dob=formattedDate.toString();
                              //bloodgroup=bloodgroupController.text;
                              pincode=pincodeController.text;
                              address=addressController.text;
                              mail=mailController.text;
                              refferedBy=refferedByController.text;
                              setState(()
                              {

                              });
                              getData();
                            }
                          },
                          child: Text('Update User Pofile',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      // IconButton(onPressed: ()=>{}, icon: Icon(Icons.send))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageChips extends StatefulWidget {
  final String chipName;
  const LanguageChips({Key? key, required this.chipName}) : super(key: key);

  @override
  _LanguageChipsState createState() => _LanguageChipsState();
}

class _LanguageChipsState extends State<LanguageChips> {
  var _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      elevation: 5,
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: _isSelected ? Colors.white : Colors.black,
          fontFamily: 'Poppins',
          fontSize: 10.0),
      selected: _isSelected,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: primaryColor,
    );
  }
}