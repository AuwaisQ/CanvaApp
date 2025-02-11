import 'dart:convert';

import 'package:canvas_365/beans/FeedBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class Feeds extends StatefulWidget
{
  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds>
{
  String userId="",feedId="";
  var url = Uri.parse(webUrl+"brandfeed");
  var likedImageUrl = Uri.parse(webUrl+"brandLikedByUser");
  bool isApiCallingProcess=false;
  var data;
  List<dynamic> dta=[];
  List<FeedBean> feedList=[];
  GlobalKey ?globalkey;
  @override
  void initState()
  {
    getUserData();
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
        onPressed: () {
            Navigator.pop(context);
    },
    icon: Icon(
    Icons.arrow_back,
    ),
    ),
    title: Text(
    'Brand Feeds',
    style: TextStyle(fontFamily: font),
    )
    ),body: Container(margin: EdgeInsets.all(10), child: SingleChildScrollView(
  child: Column(
    children: List.generate( feedList.length, (index) =>
    feedList[index].type=="image"?Card(
      elevation: 5,
      child: Container(margin: EdgeInsets.only(top: 10),child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          widgetToImage(
          builder: (key) {
      this.globalkey = key;
      return
      Center(child: Container(child: Image.network("https://canva365.com/img/"+feedList[index].url,)));}),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 5,top: 5),child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(feedList[index].title.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Text(feedList[index].dattime.toString()),
            Row(children:[Text(feedList[index].likes.toString()),TextButton.icon(onPressed: ()=>setLikePoster(feedList[index].id), icon: FaIcon(FontAwesomeIcons.heart,color: Colors.grey,size: 20,), label: Text("Likes")),TextButton.icon(onPressed: () async
            {
              final chalega=await Utils.capturewWithText(globalkey!,context,feedList[index].title.toString());
             // final imgUrl="https://canva365.com/img/"+feedList[index].url;
             // print("Image url: $imgUrl");
             // final url=Uri.parse(imgUrl);
             // final response=await http.get(url);
             // final bytes=response.bodyBytes;
             // final temp=await getTemporaryDirectory();
             // final path='${temp.path}/image.jpg';
             // File(path).writeAsBytes(bytes);
             // await Share.shareFiles([path],text:"This app is really wonderfull");
            }, icon: FaIcon(FontAwesomeIcons.share,color: Colors.grey,size: 20,), label: Text("Share"))],)
          ],),),
      ],
  ),),
    ):Card(
      elevation: 5,
    child: Container(padding: EdgeInsets.only(left: 5,right: 5,top: 5),
      child: Column(
      children: [
        YoutubePlayer(
            controller: YoutubePlayerController(initialVideoId: feedList[index].url,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),),
            progressIndicatorColor: Colors.red,
            showVideoProgressIndicator: true,
            // videoPro
            // videoProgressIndicatorColor: Colors.amber,
            // progressColors: ProgressColors(
            //   playedColor: Colors.amber,
            //   handleColor: Colors.amberAccent,
            // ),
          //   onReady ()
          //   {
          // _controller.addListener(listener);
          //   },
          ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 5,top: 5),child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(feedList[index].title.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text(feedList[index].dattime.toString()),
            Row(children:[Text(feedList[index].likes.toString()),TextButton.icon(onPressed: ()=>setLikePoster(feedList[index].id), icon: FaIcon(FontAwesomeIcons.heart,color: Colors.grey,size: 20,), label: Text("Likes")),TextButton.icon(onPressed: () async
                {
                  // final imgUrl="https://canva365.com/img/"+feedList[index].url;
                  // print("Image url: $imgUrl");
                  // final url=Uri.parse(imgUrl);
                  // final response=await http.get(url);
                  // final bytes=response.bodyBytes;
                  // final temp=await getTemporaryDirectory();
                  // final path='${temp.path}/image.jpg';
                  // File(path).writeAsBytes(bytes);
                  String youUrl="https://www.youtube.com/watch?v="+feedList[index].url+"       "+feedList[index].title;
                  await Share.share(youUrl);
                  //Share.shareFiles([path],text:"This app is really wonderfull");
                }, icon: FaIcon(FontAwesomeIcons.share,color: Colors.grey,size: 20,), label: Text("Share"))],)
        ],),)
      ],
    ),),
  )

  ),
  ),)));
  }

  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("user_id")!;
    setState((){

    });
    getFeeds();
  }

  void getFeeds() async
  {
    var response = await http.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
        // ,body: jsonEncode(<String, String>
        // {
        //   //'categoryId': categoryId.toString(),
        //   'userId': userId.toString(),
        // }
        );
    print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"status":true,"msg":"success","data":[{"id":"1","title":"VBraning","datatime":"23-8-2020 3:40:00 PM","url":"video","type":"video"},{"id":"2","title":"All in one","datatime":"04-9-2020 1:20:00 PM","url":"video","type":"image"},{"id":"3","title":"How to use","datatime":"27-11-2021 5:40:00 PM","url":"video","type":"video"},{"id":"4","title":"New Feature","datatime":"1-10-2021 5:40:00 PM","url":"video","type":"video"}]}');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["feeds"];
      //
      for(int i=0;i<dta.length;i++)
      {
        feedList.add(new FeedBean(dta[i]["id"].toString(), dta[i]["title"].toString(), dta[i]["path"].toString(), dta[i]["type"],dta[i]["created_at"], dta[i]["likes"].toString()));//dta[i]["likes"]));
      }
      //
      setState(()
      {

      });
      //
      // print(dta.length.toString());
      // setState(()
      // {
      //
      // });
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
    }
    isApiCallingProcess=false;
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }

  void setLikePoster(feedId) async
  {
    print(userId);
    print(feedId);
    var response = await http.post(likedImageUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
          //'categoryId': categoryId.toString(),
          'userId': userId.toString(),
          'feedId': feedId,
        }));
    //print(response.body);
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
    }
    else
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
    }
    isApiCallingProcess=false;
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'DDHohjyXhuA',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );
}
