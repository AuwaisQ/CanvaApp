import 'dart:io';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/FeedbackPage.dart';
import 'package:canvas_365/pages/LanguageSelect.dart';
import 'package:canvas_365/pages/Login.dart';
import 'package:canvas_365/pages/MyBusinessPage.dart';
import 'package:canvas_365/pages/addLogoPage.dart';
import 'package:canvas_365/pages/celebrity_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class Account extends StatefulWidget
{
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account>
{
  String refCode="";
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData()async
  {
    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    refCode=sharedPreferences.getString("refCode")!;
    print("refCode is${refCode}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Account Settings', style: mainHeading2),
        ),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () => Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (_) =>
                  //                   WebViewPage(logoUrl))), //EnquiryPage())),
                  //       child: Container(
                  //         height: 110,
                  //         width: MediaQuery.of(context).size.width / 2.3,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(5),
                  //             image: DecorationImage(
                  //                 image: NetworkImage(imgCreateLogo),
                  //                 fit: BoxFit.cover)),
                  //       ),
                  //     ),
                  //     Spacer(),
                  //     InkWell(
                  //       onTap: () => Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (_) => WebViewPage(businessCardUrl))),
                  //       child: Container(
                  //         height: 110,
                  //         width: MediaQuery.of(context).size.width / 2.3,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(5),
                  //             image: DecorationImage(
                  //                 image: NetworkImage(imgCreateCard),
                  //                 fit: BoxFit.cover)),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  SizedBox(
                    height: 10,
                  ),

                  ///My Business
                  Container(
                      width: 380,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyBusiness()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black,
                              size: 24,
                            ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10
                                ),
                                child: Container(
                                  child: Text(
                                    'My Business',
                                    style: TextStyle(
                                        color: Colors.grey, fontFamily: 'Poppins',fontSize: 15),
                                  ),
                                ),
                              ),],),

                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 15,
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 10),
                  ///Edit Your Brand Frame & Logo
                  Container(
                      width: 380,
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
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addLogoPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10
                                  ),
                                  child: Text(
                                    'Edit Your Brand Frame & Logo',
                                    style: TextStyle(
                                        color: Colors.grey, fontFamily: 'Poppins',fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 15,
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 10),
                  ///Message By celebrity
                  Container(
                      width: 380,
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
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CelebrityList()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10
                                  ),
                                  child: Text(
                                    'Grow Your Business With Celebrity',
                                    style: TextStyle(
                                        color: Colors.grey, fontFamily: 'Poppins',fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 15,
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 10),
                  ///Preferred Language
                  Container(
                      width: 380,
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
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LanguageSelect(from:"account",)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.language,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10
                                  ),
                                  child: Text(
                                    'Preferred Language',
                                    style: TextStyle(
                                        color: Colors.grey, fontFamily: 'Poppins',fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 15,
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 10),
                  ///Help & Support
                  Container(
                      width: 380,
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
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedbackPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.feedback_outlined,
                                  color: Colors.black,
                                  size: 24
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Help & Support',
                                      style: TextStyle(
                                          color: Colors.grey, fontFamily: 'Poppins',fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 15,
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 10),

                  ///Help & Support
                  Container(
                      width: 380,
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
                      child: TextButton(
                        onPressed: () {
                          share();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                    Icons.share,
                                    color: Colors.black,
                                    size: 24
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Share & Earn',
                                      style: TextStyle(
                                          color: Colors.grey, fontFamily: 'Poppins',fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 15,
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 10,),

                  ///Help & Support
                  Container(
                      width: 380,
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
                      child: TextButton(
                        onPressed: () {
                          hiWhatsapp(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                    Icons.mark_unread_chat_alt_outlined,
                                    color: Colors.black,
                                    size: 24
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Contact us',
                                      style: TextStyle(
                                          color: Colors.grey, fontFamily: 'Poppins',fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 15,
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: (){
                showConfirmDialog(context);
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Log out',style: TextStyle(fontSize: 18,color: primaryColor,fontFamily: 'Poopins'),),
                    Lottie.asset('assets/lottieFiles/logOut.json',
                      height: 30,width: 30,fit: BoxFit.cover
                    ),
                  ],
                ),
              ),
            )
                ],
              ),
            ),
          ),
        ));
  }

  exitApp(BuildContext cont) async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    //prefs.setBool("isLogin",false);
    SystemNavigator.pop();
    Navigator.pushReplacement(cont, MaterialPageRoute(builder: (_)=>Login()));
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
        Navigator.pop(contex);
      },
    );
    Widget continueButton = new ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
      child: Text("Logout",style: TextStyle(fontFamily: "Varela",color: Colors.white)),
      onPressed:  () {
        exitApp(contex);
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
      context: contex,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  hiWhatsapp(BuildContext context) async
  {
    var whatsapp = "+919826699990";
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp +
        "&text=I have some query about canva365";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

    Future<void> share() async {
    String msg="Please use this code ${refCode} to get Exciting offer on Canva365";
      await Share.share(msg);
      // await FlutterShare.share(
      //     title: 'Share and Earn',
      //     text: 'Example share text',
      //     linkUrl: 'https://play.google.com/store/apps/details?id=com.zynomatrix.canvaz',
      //     chooserTitle: 'Example Chooser Title'
      // );
    }
}
