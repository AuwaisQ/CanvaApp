import 'package:canvas_365/others/constant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({Key? key}) : super(key: key);

  @override
  _ReferEarnState createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(child: Text('Reffer and Earn',
          style: TextStyle(fontFamily: 'Poppins',color: primaryColor),
        ),),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'How to',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    decoration: TextDecoration.underline),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.info_outlined,
                color: primaryColor,
              ),
            )
          ],
      ),
      // appBar: AppBar(
      //   backgroundColor: backgroundColor,
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.black,
      //     ),
      //   ),
      //   actions: [
      //     TextButton(
      //       onPressed: () {},
      //       child: Text(
      //         'How to',
      //         style: TextStyle(
      //             color: Colors.black,
      //             fontFamily: 'Poppins',
      //             decoration: TextDecoration.underline),
      //       ),
      //     ),
      //     IconButton(
      //       onPressed: () {},
      //       icon: Icon(
      //         Icons.info_outlined,
      //         color: primaryColor,
      //       ),
      //     )
      //   ],
      // ),
      body: Center(child: Container(
        height: 250,
        padding: EdgeInsets.all(10),
        child: Card(
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
                    Image.asset('assets/images/undermain.png',height: 100,),
                    Text('This Feature will be Available soon!',style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'Poppins',),),
                    SizedBox(height: 20,),
                    Container(

                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(onPressed: ()
                      {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => SelectPlan())
                        // );
                      },
                        child: Text('Coming Soon',style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: 'Poopins'),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      //SafeArea(
      //   child: Padding(
      //     padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      //     child: SingleChildScrollView(
      //       child:
      //       Column(
      //         children: [
      //           ///1st Container
      //           Container(
      //             height: 70,
      //             width: 320,
      //             decoration: BoxDecoration(
      //                 color: primaryColor,
      //                 borderRadius: BorderRadius.circular(5),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.grey,
      //                     blurRadius: 5.0,
      //                   )
      //                 ]),
      //             child: Row(
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.only(left: 10),
      //                   child: Icon(
      //                     Icons.emoji_events,
      //                     color: Colors.white,
      //                     size: 50,
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(top: 15),
      //                   child: Column(
      //                     children: [
      //                       Padding(
      //                         padding: const EdgeInsets.only(right: 47),
      //                         child: Text(
      //                           '100',
      //                           style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                               fontFamily: 'Poppins',
      //                               fontWeight: FontWeight.bold),
      //                         ),
      //                       ),
      //                       Text(
      //                         'Total Rewards Coins',
      //                         style: TextStyle(
      //                             color: Colors.white,
      //                             fontFamily: 'Poppins',
      //                             fontSize: 8),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(width: 55),
      //                 Container(
      //                   height: 25,
      //                   width: 95,
      //                   decoration: BoxDecoration(
      //                       color: Colors.black,
      //                       borderRadius: BorderRadius.circular(50)),
      //                   child: Center(
      //                     child: TextButton(
      //                       onPressed: () {},
      //                       child: Text(
      //                         'Redeem now',
      //                         style:
      //                             TextStyle(color: Colors.white, fontSize: 9),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //
      //           SizedBox(
      //             height: 10,
      //           ),
      //
      //           ///2nd Container
      //           Container(
      //               height: 140,
      //               width: double.infinity,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(7),
      //                   image: DecorationImage(
      //                       image: NetworkImage(
      //                           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb1blJ9wt8JOhoHT_5UKIqy86pGtEiTuiWCw&usqp=CAU'),
      //                       fit: BoxFit.cover)),
      //               child: Center(
      //                 child: Text(
      //                   'You Have Refered Your 0 Friend \n refer more to earn reward',
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                       color: Colors.white,
      //                       fontFamily: font,
      //                       fontSize: 15),
      //                 ),
      //               )),
      //
      //           SizedBox(
      //             height: 10,
      //           ),
      //
      //           Text(
      //             'Earn upto 1000 Coins per friend.',
      //             style:
      //                 TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
      //           ),
      //
      //           Text(
      //             'You get 1000 coins when your friend subscribe 1 year \n package',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //                 color: Colors.grey, fontFamily: font, fontSize: 10),
      //           ),
      //
      //           SizedBox(
      //             height: 30,
      //           ),
      //
      //           Text(
      //             'How It Works?',
      //             style: TextStyle(
      //                 fontFamily: font,
      //                 color: primaryColor,
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 12,
      //                 decoration: TextDecoration.underline),
      //           ),
      //
      //           DottedBorder(
      //             color: Colors.black,
      //             strokeWidth: 1.5,
      //             strokeCap: StrokeCap.round,
      //             dashPattern: [6, 6],
      //             radius: Radius.circular(10),
      //             child: Container(
      //               height: 35,
      //               width: 380,
      //               child: TextFormField(
      //                 cursorColor: Colors.black,
      //                 decoration: new InputDecoration(
      //                   border: InputBorder.none,
      //                   focusedBorder: InputBorder.none,
      //                   enabledBorder: InputBorder.none,
      //                   errorBorder: InputBorder.none,
      //                   disabledBorder: InputBorder.none,
      //                   suffix: Text(
      //                     'copy',
      //                     style: TextStyle(
      //                         color: primaryColor,
      //                         fontFamily: font,
      //                         fontSize: 14),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Container(
      //             height: 40,
      //             width: double.infinity,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(25),
      //                 color: primaryColor),
      //             child: TextButton(
      //                 onPressed: () {},
      //                 child: Center(
      //                   child: Text(
      //                     'Refer friends now',
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontFamily: font,
      //                         fontSize: 13),
      //                   ),
      //                 )),
      //           ),
      //         ],
      //       ),
//          ),
  //      ),
      ),
    );
  }
}
