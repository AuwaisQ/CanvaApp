import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/BottomBar.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/BusinessCatergories.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
int selectLanguage=0;
String selectLanguageName="";
bool __selectLanguage=false;
class LanguageSelect extends StatefulWidget
{
  //const LanguageSelect({Key? key}) : super(key: key);
  String from="";
  LanguageSelect({required this.from});
  @override
  _LanguageSelectState createState() => _LanguageSelectState(from);
}

class _LanguageSelectState extends State<LanguageSelect>
{
  String from="";
  String userId="";
  _LanguageSelectState(this.from);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   color: Colors.transparent,
      //   child: Padding(
      //     padding: const EdgeInsets.only(left: 60,right: 60,bottom: 20),
      //     child: Container(
      //       height: 50,
      //       decoration: BoxDecoration(
      //           color: primaryColor,
      //           borderRadius: BorderRadius.all(Radius.circular(30.0))
      //       ),
      //       child: TextButton(
      //         onPressed:()
      //         {
      //           print("Selected Language is:"+selectLanguage.toString());
      //
      //           //setBusinessCategory();
      //         },
      //         child: Text('Submit',
      //           style: TextStyle(
      //               color: Colors.white,
      //               fontFamily: 'Poppins',
      //               fontSize: 15.0,
      //               fontWeight: FontWeight.bold
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Home(from: from,),
    );
  }
}

class Home extends StatefulWidget
{
  String from="";
  Home({required this.from});
  @override
  _HomeState createState() => _HomeState(from);
  int selectLanguage=0;
}
class _HomeState extends State<Home>
{
  String from="";
  _HomeState(this.from);
  var url = Uri.parse(webUrl+"displayLanguage");
  var data;
  List<dynamic> dta=[];
  String msg="";
  List<NameIdBean> languageListOne=[];
  bool isApiCallingProcess=false;
  String userId="";

  var urlLanguage = Uri.parse(webUrl+"selectLanguage");
  // var data;
  // bool isApiCallingProcess=false;

  setUserData() async
  {
    //Toast.show("Click", context, duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("language", selectLanguage.toString());
    //prefs.setString("language_array", "{'lang':[{'id':'1','language':'English'},'$selectLanguage':'$selectLanguageName}]}");
    prefs.setString("language_array", '{"lang":[{"id":"1","language":"English"},{"id":"$selectLanguage","language":"$selectLanguageName"}]}');
    //prefs.setString("language_array", '{"lang":[{"id":"1","language":"English"},{"id":"2","language":"Hhindi"}]}');
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomBar()));
    if(from=="OTP")
    {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BusinessCategories(selectedLanguage: selectLanguage.toString(),)));
    }else
    {
      Navigator.pop(context);
    }
  }

  void setBusinessCategory() async
  {
    //print("bcategoryid$selectLanguage");
    String selectedLanguage="1,"+selectLanguage.toString();
    print("userId$userId");
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
    var response = await http.post(urlLanguage,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
          'languageIds': selectedLanguage.toString(),
          'userId': userId,
        }));
    print(urlLanguage);
    print("UserId:$userId languageIds:$selectedLanguage");
    print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status)
    {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setUserData();
    } else
    {
      //Toast.show(data['status'], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: errorColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    isApiCallingProcess=false;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomBar()));
  }

  void getLanguageData() async
  {

    print(url);
    var response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>
      // {
      //   'userId': "userId",
      // }
      );
    //print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"language":"\u0a2a\u0a70\u0a1c\u0a3e\u0a2c\u0a40","defaultlang":"false"},{"id":3,"language":"\u0ba4\u0bae\u0bbf\u0bb4\u0bcd","defaultlang":"false"},{"id":4,"language":"\u0d2e\u0d32\u0d2f\u0d3e\u0d33\u0d02","defaultlang":"false"},{"id":5,"language":"Italia","defaultlang":"false"},{"id":6,"language":"\u0939\u093f\u0902\u0926\u0940","defaultlang":"false"},{"id":7,"language":"English","defaultlang":"true"}],"status":true,"msg":"success"}');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["data"];
      print(dta[0]["language"]);
      print(dta.length.toString());
      for(int i=0;i<dta.length;i++)
      {
        bool b = dta[i]["defaultlang"].toLowerCase()=="true"?true:false;
        languageListOne.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["language"], "", b));
      }
      setState(()
      {

      });
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
      setState(()
      {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      });
    }
  }

  @override
  void initState()
  {
    getUserData();
    isApiCallingProcess=true;
    getLanguageData();
    super.initState();
  }

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("user_id")!;
    print("1111"+userId);
    setState((){
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(      floatingActionButton: new Visibility(
      child: new FloatingActionButton(
        heroTag: "language",
        onPressed: ()=>
        {
          //print("$selectCategory Selected Options:$selectedLanguage"),
          isApiCallingProcess=true,
          setBusinessCategory()
        },
        tooltip: 'Increment',
        child: new Icon(Icons.send),
        backgroundColor: primaryColor,
      ),
      visible: __selectLanguage,
    ),
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(children: [
                Padding(padding: const EdgeInsets.only(left: 30),
                  child: Text('Preferred Languages',
                    style: mainHeading2,
                  ),
                ),
              ],
              ),
              SizedBox(height: 10),
              DelayedDisplay(
                delay: Duration(milliseconds: 500),
                slidingBeginOffset: Offset(-2.0, 0.0),
                child: Padding(padding: EdgeInsets.only(left: 30),
                  child: Text('Choose language in which you want to get Images',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 15.0
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 20.0),
                  child:
                  DelayedDisplay(
                    delay: Duration(milliseconds: 1000),
                    slidingBeginOffset: Offset(-2.0, 0.0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children:
                      List.generate(languageListOne.length, (index) =>
                      //getChip(new NameIdBean(languageList[index]['id'],languageList[index]['language'],"aaa",languageList[index]['status']))
                      getChip(languageListOne[index],index),
                      ),
                    ),
                  ))],
          ),
        ),
      ),
    );
  }

  Widget getChip(NameIdBean nameIdBean,int index)
  {
    //print(nameIdBean.status);
    var _isSelected = nameIdBean.status;
    return ChoiceChip(
      padding: EdgeInsets.symmetric(horizontal: 15),
      elevation: 10,
      label: Padding(padding: EdgeInsets.only(top: 10,bottom: 10), child: Text(nameIdBean.name)),
      labelStyle: TextStyle(
          color:  _isSelected? Colors.white : Colors.black,
          fontFamily:'Poppins',
          fontSize: 15.0
      ),
      selected: _isSelected,
      backgroundColor: Colors.white,//_isSelected? Colors.black : Colors.white,//Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onSelected: (isSelected)
      {
        if(index==0)
        {
          Fluttertoast.showToast(
              msg: "English is a mandatory language",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: successColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }else
        {
          //print(isSelected);
          for(int i=1;i<languageListOne.length;i++)
          {
            if(languageListOne[i].id==languageListOne[index].id)
            {
              _isSelected = isSelected;
              nameIdBean.status=_isSelected;
              selectLanguage=int.parse(languageListOne[index].id);
              selectLanguageName=languageListOne[index].name.toString();
            }else
            {
              languageListOne[i].status=false;
            }
            __selectLanguage=true;
            //isSelect=true;
            setState(()
            {
              // trace.add(nameIdBean.id);
               //print(trace.length.toString()+"::"+nameIdBean.id+","+_isSelected.toString());
            });
          }
        }
      },
      selectedColor: _isSelected ? primaryColor : primaryColor,
    );
  }
}
class LanguageChips extends StatefulWidget {
  final String chipName;
  final String id;
  const LanguageChips({Key? key, required this.chipName,required this.id}) : super(key: key);
  @override
  _LanguageChipsState createState() => _LanguageChipsState(id);
}
class _LanguageChipsState extends State<LanguageChips>
{
  var _isSelected = false;
  String id="";
  List<String> trace=[];
  _LanguageChipsState(this.id);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      padding: EdgeInsets.symmetric(horizontal: 15),
      elevation: 10,
      label: Padding(padding: EdgeInsets.only(top: 10,bottom: 10), child: Text(widget.chipName)),
      labelStyle: TextStyle(
          color: _isSelected ? Colors.white : primaryColor,
          fontFamily:'Poppins',
          fontSize: 15.0
      ),
      selected: _isSelected,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onSelected: (isSelected)
      {
        //print(isSelected);
        if(widget.id==0)
        {

        }else
        {
          setState(()
          {
            trace.add(widget.id);
            _isSelected = isSelected;
            //print(id);
          });
        }
      },
      selectedColor: _isSelected ? primaryColor : Colors.black,
    );
  }
}