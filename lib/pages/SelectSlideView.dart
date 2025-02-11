import 'package:canvas_365/others/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SelectSliderView extends StatefulWidget {
  const SelectSliderView({Key? key}) : super(key: key);

  @override
  _SelectSliderState createState() => _SelectSliderState();
}

class _SelectSliderState extends State<SelectSliderView> {
  String mobile="78485823569";
  String email="a@gmail.com";
  String addres="36, Rishinagar Ujjain";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Select Package',
          style: mainHeading2,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ///Slider
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://evasion-online.com/image-photo/angleterre+photo+image+et+drapeau/(Image)-image-Angleterre-Londres-Tower-Bridge-527-fo_116917227-09032017.jpg'),
                        fit: BoxFit.cover)),
                child: CarouselSlider(
                    items: <Widget>[
                      ///1st Container
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/frame1.png'),
                                      fit: BoxFit.fitWidth)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 25, top: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '123 456 789',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'abcd@gmal.com',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///2nd Row
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 35, top: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'abcd@gmal.com',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      ///2nd Container
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 30,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/frame2.png'),
                                      fit: BoxFit.fitWidth)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 37, bottom: 1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '+91 123 456 7890',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      ///3rd Container
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/frame3.png'),
                                      fit: BoxFit.fitWidth)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 19, top: 9),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '+91 $mobile',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Address',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Ujjain (M.P.)',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                        height: double.infinity,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        viewportFraction: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
