import 'package:canvas_365/others/constant.dart';
import 'package:flutter/material.dart';

class Downloads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: Text(
              'Downloads',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
            ),
            bottom: TabBar(
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              tabs: [
                Tab(
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey,
                          )
                        ]),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'All',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey,
                          )
                        ]),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Festival',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey,
                          )
                        ]),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Custom',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ///All Tab
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        ///Container Row 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuTwxlwuhoj5fVzxDVaADkUYbeDMVN7yeBUA&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl8lQ5NfhbTq9nX1WAuTtI1VIItaUXantP7w&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOvdQZHzlfM7l9LlH98FNCuQbAyzWJGlGxqg&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        ///2nd Row Circle Avtar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPgoGrCfUAbqUhkWuIZTdKg3wQvB-pOrr-1A&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQtadVWEbjayuFFK1dGodPjR5jAUtNmU7Q0Q&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8bagFBwY2dSAR3GmV1l2DfkdwBP3kgad0rA&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

              ///Festival Tab
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        ///Container Row 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuTwxlwuhoj5fVzxDVaADkUYbeDMVN7yeBUA&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl8lQ5NfhbTq9nX1WAuTtI1VIItaUXantP7w&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOvdQZHzlfM7l9LlH98FNCuQbAyzWJGlGxqg&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

              ///Custom Tab
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        ///1nd Row Circle Avtar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPgoGrCfUAbqUhkWuIZTdKg3wQvB-pOrr-1A&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQtadVWEbjayuFFK1dGodPjR5jAUtNmU7Q0Q&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8bagFBwY2dSAR3GmV1l2DfkdwBP3kgad0rA&usqp=CAU'),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
