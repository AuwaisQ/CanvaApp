import 'package:flutter/material.dart';

import 'ChangeCategoryRequestPage.dart';
import 'constant.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text('Settings', style: mainHeading2),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              ///1st Text Field
              Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
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
                              builder: (context) => ChangeCategory()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.feedback_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 40,
                          ),
                          child: Text(
                            'Change Category Request',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 15,
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),

              ///2ndText Field
              Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.support,
                          color: Colors.black,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 120,
                          ),
                          child: Text(
                            'Help 7*24 Support',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 15,
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),

              ///3rdText Field
              Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.question_answer_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 190,
                          ),
                          child: Text(
                            'Faq\'s',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 15,
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),

              ///4thText Field
              Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.black,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 180,
                          ),
                          child: Text(
                            'Policy',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 15,
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),

              ///5thText Field
              Container(
                  height: 35,
                  width: 380,
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.share,
                          color: Colors.black,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 150,
                          ),
                          child: Text(
                            'Share App',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 15,
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),

              ///6thText Field
              Container(
                  height: 35,
                  width: 380,
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.edit_off,
                          color: Colors.black,
                          size: 20,
                        ),
                        Text(
                          'Need Logo Watermark on Image?',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'Poppins'),
                        ),
                        Icon(
                          Icons.live_help_outlined,
                          color: primaryColor,
                          size: 20,
                        )
                      ],
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LanguageChips(chipName: 'Yes'),
                  SizedBox(
                    width: 20,
                  ),
                  LanguageChips(chipName: 'No'),
                ],
              ),
            ],
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
      padding: EdgeInsets.symmetric(horizontal: 20),
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
