import 'package:canvas_365/others/constant.dart';
import 'package:flutter/material.dart';

class ChangeCategory extends StatefulWidget {
  const ChangeCategory({Key? key}) : super(key: key);

  @override
  _ChangeCategoryState createState() => _ChangeCategoryState();
}

class _ChangeCategoryState extends State<ChangeCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Change Category Request',
          style: TextStyle(color: Colors.black, fontFamily: font, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 25, left: 25, top: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.grey)
                        ]),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Open',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: font,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '00',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: font,
                                fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.grey)
                        ]),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'In Progress',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: font,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '02',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: font,
                                fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.grey)
                        ]),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Completed',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: font,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '05',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: font,
                                fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   height: 40,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(25),
              //       color: primaryColor),
              //   child: TextButton(
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => ChangeCategory2()));
              //       },
              //       child: Center(
              //         child: Text(
              //           'Genarate Ticket',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontFamily: font,
              //               fontSize: 13),
              //         ),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
