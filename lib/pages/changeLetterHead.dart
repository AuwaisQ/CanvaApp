import 'dart:io';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ChangeLetterHead extends StatefulWidget {
  String id;
  int numberOfImage = 0;
  ChangeLetterHead(this.id, this.numberOfImage, {Key? key}) : super(key: key);
  @override
  State<ChangeLetterHead> createState() =>
      _ChangeLetterHeadState(id, numberOfImage);
}

TextEditingController businessController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController otherTextController = TextEditingController();

class _ChangeLetterHeadState extends State<ChangeLetterHead> {
  GlobalKey? globalkey;
  String id;
  int numberOfImage;
  int currentImage = 0;

  String? mobile, businessName,website;
  String? address;
  String? emailAddress, language_array;
  String? logo;
  bool? issubscribed;
  bool isProfileUpdate = false;
  String? userId;

  _ChangeLetterHeadState(this.id, this.numberOfImage);

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    isProfileUpdate = prefs.getBool("isProfileUpdate")!;
    userId = prefs.getString("user_id")!;
    if (isProfileUpdate) {
      mobile = prefs.getString('contact1');
      address = prefs.getString('businessAddress');
      emailAddress = prefs.getString('email');
      logo = prefs.getString('logo');
      issubscribed = prefs.getBool("isSubscribed");
      language_array = prefs.getString("language_array");
      businessName = prefs.getString('businessName');
      website = prefs.getString('website');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool profileStatus = false;

  void getProfileStatus(bool isSet) async {
    final prefs = await SharedPreferences.getInstance();
    profileStatus = prefs.getBool("isProfileUpdate")!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Letter Head',
            style: TextStyle(fontFamily: 'Varela', fontSize: 22),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                widgetToImage(builder: (key) {
                  this.globalkey = key;
                  return Container(
                    child: getLetterHead(id),
                    alignment: Alignment.bottomCenter,
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primaryColor)
                        ),
                        onPressed: () => {_convertImageToPDF()},
                        child: Text("Download PDF",style: TextStyle(color: Colors.white),)),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primaryColor)
                      ),
                        onPressed: () {
                          _displayDialog(context);
                        },
                        child: Text("Update Content",style: TextStyle(color: Colors.white))),
                  ],
                ),
              ],
            ),
          ),
        )); //getCollage(id),);
  }

  Widget getLetterHead(id) {
    switch (id) {
      case "1":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd1.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 465,
                left: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(otherTextController.text != "" ? otherTextController.text : "",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold,color: Colors.black)),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on,size: 10,),
                            Text(addressController.text != "" ? addressController.text :address!,
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 70,),
                        Row(
                          children: [
                            Icon(Icons.phone,size: 10,),
                            Text(mobileController.text != "" ? mobileController.text :mobile!,
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                      Row(
                        children: [
                          Icon(Icons.phone,color: Colors.white,size: 10,),
                          Text(emailController.text != "" ? emailController.text :emailAddress!,
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white)),
                        ],
                      ),
                        SizedBox(width: 27,),
                      Row(
                        children: [
                          Icon(Icons.language,color: Colors.white,size: 10,),
                          SizedBox(width: 2,),
                          Text(website!,
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white)),
                        ],
                      ),
                    ],),
                  ],
                ),
              ),
              Positioned(
                  top: 15,
                  left: MediaQuery.of(context).size.width / 70,
                  child: Row(
                    children: [
                      Image.network(
                        logo != null
                            ? imageUrl + logo!
                            : imgAddLogo,
                        width: 50,
                      ),
                      SizedBox(
                        width: 120,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25, left: 20),
                        child: Text(
                            businessController.text != ""
                                ? businessController.text
                                : businessName!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "2":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd2.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 415,
                left: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 15,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 15,),
                        SizedBox(
                          width: 2,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.web,
                          size: 15,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(website!),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40,top: 3),
                      child: Text(otherTextController.text != "" ? otherTextController.text : "",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 20,
                  left: MediaQuery.of(context).size.width / 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 36),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 180,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 45,
                        width: 45,
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "3":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd3.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 440,
                left: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 10,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 10,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 10,),
                        SizedBox(
                          width: 2,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.web,
                              size: 10,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(website!,style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            )),
                          ],
                        ),
                        SizedBox(width: 50,),
                        Text(otherTextController.text != "" ? otherTextController.text : "",
                            style: TextStyle(color: Colors.black,fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 5,
                  left: MediaQuery.of(context).size.width / 100,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(
                        width: 200,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,),
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "4":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 440,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 13,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,),
                        SizedBox(
                          width: 2,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 13,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.web,
                              size: 13,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(website!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Text(otherTextController.text != "" ? otherTextController.text : "",
                            style: TextStyle(color: Colors.black,fontSize: 13)),
                      ],
                    ),

                  ],
                ),
              ),
              Positioned(
                  top: 5,
                  left: MediaQuery.of(context).size.width / 4,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 45,
                        width: 45,
                      ),
                    ],
                  )),
              Image.asset(
                'assets/images/Lehd4.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
            ],
          ),
        );
      case "5":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd5.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 440,
                left: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 13,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,),
                        SizedBox(
                          width: 2,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 13,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.web,
                              size: 13,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(website!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Text(otherTextController.text != "" ? otherTextController.text : "",
                            style: TextStyle(color: Colors.black,fontSize: 13)),
                      ],
                    ),

                  ],
                ),
              ),
              Positioned(
                  top: 5,
                  left: MediaQuery.of(context).size.width / 70,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        color: Colors.white,
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(
                        width: 120,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "6":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd6.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 440,
                left: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 13,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,),
                        SizedBox(
                          width: 2,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 13,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.web,
                              size: 13,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(website!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Text(otherTextController.text != "" ? otherTextController.text : "",
                            style: TextStyle(color: Colors.black,fontSize: 13)),
                      ],
                    ),

                  ],
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width / 30,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 140,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        width: 50,
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "7":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd7.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 435,
                left: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,color: Colors.white,),
                        SizedBox(
                          width: 8,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.web,
                              color: Colors.white,
                              size: 13,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(website!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        SizedBox(width: 40,),
                        Text(otherTextController.text != "" ? otherTextController.text : "",
                            style: TextStyle(color: Colors.black,fontSize: 13)),
                      ],
                    ),

                  ],
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width / 15,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 130,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        width: 50,
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "8":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd8.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 435,
                left: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,color: Colors.white,),
                        SizedBox(
                          width: 15,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.web,
                              color: Colors.white,
                              size: 13,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(website!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        SizedBox(width: 40,),
                        Text(otherTextController.text != "" ? otherTextController.text : "",
                            style: TextStyle(color: Colors.black,fontSize: 13)),
                      ],
                    ),

                  ],
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width / 15,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 20),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 105,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        width: 50,
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "9":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd9.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 370,
                left: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 13,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(Icons.phone,size: 13,color: Colors.black,),
                      ],
                    ),

                    Row(
                      children: [
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                          size: 13,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(website!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.web,
                          color: Colors.black,
                          size: 13,
                        ),
                      ],
                    ),
                    SizedBox(width: 40,),
                    Text(otherTextController.text != "" ? otherTextController.text : "",
                        style: TextStyle(color: Colors.black,fontSize: 13)),

                  ],
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width / 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 45,
                        ),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 145,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        width: 50,
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "10":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd10.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 435,
                left: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,color: Colors.black,),
                        SizedBox(
                          width: 8,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.web,
                              color: Colors.black,
                              size: 13,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(website!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        SizedBox(width: 40,),
                        Text(otherTextController.text != "" ? otherTextController.text : "",
                            style: TextStyle(color: Colors.black,fontSize: 13)),
                      ],
                    ),

                  ],
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width / 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 45,
                        ),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 35,
                          width: 35,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "11":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd11.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 420,
                left: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,color: Colors.black,),
                        SizedBox(
                          width: 8,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.web,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(website!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Text(otherTextController.text != "" ? otherTextController.text : "",
                        style: TextStyle(color: Colors.white,fontSize: 13)),
                  ],
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width / 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 170,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.asset(
                          'assets/images/logo.png',
                          color: Colors.white,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      case "12":
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/Lehd12.png',
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 419,
                left: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(addressController.text != "" ? addressController.text :address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 13,color: Colors.black,),
                        SizedBox(
                          width: 8,
                        ),
                        Text(mobileController.text != "" ? mobileController.text :mobile!,style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(emailController.text != "" ? emailController.text :emailAddress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.web,
                          color: Colors.black,
                          size: 13,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(website!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Text(otherTextController.text != "" ? otherTextController.text : "",
                        style: TextStyle(color: Colors.white,fontSize: 13)),
                  ],
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width / 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(businessController.text != "" ? businessController.text : businessName!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 145,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 55,
                          width: 55,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      default:
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          height: 500,
          width: 350,
        );
    }
  }

  /*Convert to PDF function*/
  Future<void> _convertImageToPDF() async {
    //Create the PDF document
    PdfDocument document = PdfDocument();
    //Add the page
    PdfPage page = document.pages.add();
    //Load the image.
    //final PdfImage image = PdfBitmap(await Utils.captureByteData(globalkey!));
    final PdfImage image = PdfBitmap(await _readImageData());
    //draw image to the first page
    page.graphics.drawImage(
        //image, Rect.fromLTWH(0, 0, 500, page.size.height));
        image,
        Rect.fromLTWH(0, 0, 500, 700));
    //Save the document
    List<int> bytes = await document.save();
    //Dispose the document
    document.dispose();
    //Get external storage directory
    Directory directory = (await getApplicationDocumentsDirectory());
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/Output.pdf');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');
  }

  /*Convert to Image function*/
  Future<List<int>> _readImageData() async {
    //final ByteData data = await rootBundle.load('assets/images/Lehd1.png');
    final ByteData data = await Utils.captureByteData(globalkey!);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Make Changes in Letterhead'),
            content:  SizedBox(
              height: MediaQuery.of(context).size.height/ 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /*Edit Business Name*/
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                        controller: businessController,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          alignLabelWithHint: true,
                          hintText: 'Edit Business Name',
                          hintStyle: TextStyle(fontSize: 17)
                        )),
                  ),
                  /*Edit Address*/
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                        controller: addressController,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: 'Edit Address',
                            hintStyle: TextStyle(fontSize: 17)
                        )),
                  ),
                  /*Edit Email*/
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                        controller: emailController,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: 'Edit Email ID',
                            hintStyle: TextStyle(fontSize: 17)
                        )),
                  ),
                  /*Edit Mobile Number*/
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                        controller: mobileController,
                        style: TextStyle(
                            color: Colors.black, fontSize: 20),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: 'Edit Mobile Number',
                            hintStyle: TextStyle(fontSize: 17)
                        )),
                  ),
                  /*Other Text*/
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                        controller: otherTextController,
                        style: TextStyle(
                            color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: 'Add Other Text',
                            hintStyle: TextStyle(fontSize: 17)
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primaryColor),
                        ),
                        onPressed: (){
                      Navigator.pop(context);
                    }, child: Text('SAVE',style: TextStyle(color: Colors.white),))
                  ],)
                ],
              ),
            ),
          );
        });
  }
}
