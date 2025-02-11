import 'package:canvas_365/others/Account.dart';
import 'package:canvas_365/others/CustomePage.dart';
import 'package:canvas_365/others/Downloads.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/BrandFeed.dart';
import 'package:canvas_365/pages/MainPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../pages/Feeds.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var currentTab;
  final List<Widget> screen = [
    CustomPage(),
    Downloads(),
    BrandFeed(categoryId: "14", displayImage: "none"),
    Account(),
  ];
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

  void showNotification() {
    // setState(() {
    //   _counter++;
    // });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/logo')));
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = MainPage();

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              content: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Container(
                      height: 150,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(1.0),
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 95, left: 15),
                    child: Text(
                      'Do you want to exit\nCanva 365?',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 150,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Varela',
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              'Exit App',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Varela',
                                  fontSize: 16),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return new WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        extendBody: true,
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: InkWell(
          onTap: () {
            setState(() {
              currentScreen = MainPage();
            });
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/home.png'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8.0,
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    //1st Button
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = CustomPage();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/custom.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.cover,
                            color: currentTab == 0 ? primaryColor : Colors.grey,
                          ),
                          Text(
                            'Custom',
                            style: TextStyle(
                                color: currentTab == 0
                                    ? primaryColor
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),

                    ///2nd Button
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = Downloads();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/download.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.cover,
                            color: currentTab == 1 ? primaryColor : Colors.grey,
                          ),
                          Text(
                            'Download',
                            style: TextStyle(
                                color: currentTab == 1
                                    ? primaryColor
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ///3rd Button
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              Feeds(); //WebViewPage("www.rfcards.in");//BrandFeed(categoryId: "14",displayImage:"none");
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/feed.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.cover,
                            color: currentTab == 2 ? primaryColor : Colors.grey,
                          ),
                          Text(
                            'Feed\'s',
                            style: TextStyle(
                                color: currentTab == 2
                                    ? primaryColor
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),

                    ///4th Button
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = Account();
                          currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/account.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.cover,
                            color: currentTab == 3 ? primaryColor : Colors.grey,
                          ),
                          Text(
                            'Account',
                            style: TextStyle(
                                color: currentTab == 3
                                    ? primaryColor
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
