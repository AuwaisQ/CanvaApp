import 'package:canvas_365/others/constant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class VisitingCardWallet extends StatefulWidget {
  const VisitingCardWallet({Key? key}) : super(key: key);

  @override
  _VisitingCardWalletState createState() => _VisitingCardWalletState();
}

class _VisitingCardWalletState extends State<VisitingCardWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: font),
                ),
              ),
            ),
          )),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Visiting Card & wallet',
          style: mainHeading2,
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DottedBorder(
                  color: primaryColor,
                  strokeWidth: 1.5,
                  strokeCap: StrokeCap.round,
                  dashPattern: [6, 6],
                  radius: Radius.circular(10),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Take Photos of your visiting Cards or \n choose existing photos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: font,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                ///Text Fields
                Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.wallet_travel,
                          color: Colors.grey,
                          size: 20,
                        ),
                        hintText: "Bussiness Name",
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Text Fields
                Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.account_box_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        hintText: "Full Name",
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Text Fields
                Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.phone_android_sharp,
                          color: Colors.grey,
                          size: 20,
                        ),
                        hintText: "Mobile Number",
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Text Fields
                Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextFormField(
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
                          size: 20,
                        ),
                        hintText: "Email",
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Text Fields
                Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.language,
                          color: Colors.grey,
                          size: 20,
                        ),
                        hintText: "Website",
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Text Fields
                Container(
                  height: 100,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        hintText: "Address",
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
