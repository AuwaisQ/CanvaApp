import 'dart:convert';
import 'dart:typed_data';

import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
class getVideoList extends StatefulWidget
{
  @override
  State<getVideoList> createState() => _getVideoListState();
}

class _getVideoListState extends State<getVideoList>
{
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isApiCallingProcess=false;
  var  url=Uri.parse(webUrl+"displayVideos");
  var data;
  List<dynamic> dta=[];
  List<NameIdBean> posterList=[];
  bool issubscribed=true;
  late String displayVideo;
  @override
  void initState()
  {
    isApiCallingProcess=true;
    getVideoData();

    // _controller = VideoPlayerController.network("https://canva365.com/videos/SampleVideo_1280x720_1mb.mp4")
    //   ..setLooping(true)
    //   ..play()
    //   ..setVolume(0);
    // _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  VideoPlayerController setData(String vUrl)
  {
    print(vUrl);
    _controller = VideoPlayerController.network(vUrl)
      ..setLooping(true)
      ..setVolume(0);
    _initializeVideoPlayerFuture = _controller.initialize();
    return _controller;
  }

  void getVideoData() async
  {
    print(url);
    var response = await http.get
    (url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //print(response.body);
    data = jsonDecode(response.body);
    //data=jsonDecode('{"data":[{"id":1,"name":"Software Industry","image":"1629201605.jpg"}],"status":true,"msg":"success"}');
    print(data);
    var status = data['status'];
    var msg = data['msg'];
    print(status);
    if (status)
    {
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["data"];
      displayVideo=vdoUrl+dta[0]["videopath"];
      // for(int i=0;i<dta.length;i++)
      // {
      //   bool stts=false;
      //   dta[i]["paid"]=="Free"?stts=true:stts=false;
      //   posterList.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["title"], dta[i]["imgpath"], stts));
      // }
      setState(()
      {

      });

      print(dta.length.toString());
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
    }
    isApiCallingProcess=false;
    setState(()
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }


  @override
  Widget build(BuildContext context)
  {
    return ProgressHud(build_ui(context), isApiCallingProcess);
    //return ProgressHud(child: build_ui(context), isAsyncCall: isApiCallingProcess);
  }

  @override
  Widget build_ui(BuildContext context)
  {
    VideoPlayerController vpc=setData(displayVideo);
    vpc.play();
    Uint8List ?uint8list;

    // @override
    // void initState()
    // {
    //   getVideoImage(vdoUrl+dta[index]["videopath"]);
    //   super.initState();
    // }


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.black,
        //     size: 20,
        //   ),
        // ),
        title: Text('Videos', style: mainHeading2),
      ),
      body: Container(
          child:
          //images != null ?
          Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
height: 300,
                  margin: EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [BoxShadow(
                  //         blurRadius: 5,
                  //         color: Colors.grey
                  //     )
                  //     ]
                  // ),
                  //child: Text(dta[index]["videopath"]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: VideoPlayer(vpc),
                        ),
                      )
                  )),
              GridView.builder(scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //mainAxisSpacing: 15,
                    crossAxisSpacing: .5,
                    mainAxisSpacing: .5,

                    crossAxisCount: 3),
                itemBuilder: (context, index)
                {
                  //print(imgUrl+categoryList[index].image);
                  VideoPlayerController contro=setData(vdoUrl+dta[index]["videopath"]);
                  return Stack(
                    children: [
                        Container(
                        height: 150,

                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey
                            )
                            ]
                        ),
                        //child: Image.memory(uint8list),
                      //   child: ClipRRect(
                      //       borderRadius: BorderRadius.circular(15),
                      //       child:
                      //       FittedBox(
                      //         fit: BoxFit.cover,
                      //         child: SizedBox(
                      //           height: 50,
                      //           width: 50,
                      //           child: VideoPlayer(contro),
                      //         ),
                      //       )
                      // )
                        //),
                    //   Container(
                    //   height: 150,
                    //
                    //   margin: EdgeInsets.all(10),
                    //   // decoration: BoxDecoration(
                    //   //     color: Colors.white,
                    //   //     borderRadius: BorderRadius.circular(20),
                    //   //     boxShadow: [BoxShadow(
                    //   //         blurRadius: 5,
                    //   //         color: Colors.grey
                    //   //     )
                    //   //     ]
                    //   // ),
                    //   //child: Text(dta[index]["videopath"]),
                      child: InkWell(
                        onTap: ()=>
                        {
                        displayVideo=vdoUrl+dta[index]["videopath"],
                              setState((){

                              })
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child:
                            FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: VideoPlayer(contro),//contro.value.isInitialized?VideoPlayer(contro):Center(child: SizedBox(height: 10,width: 10, child: CircularProgressIndicator())),
                              ),
                            )
                    ),
                      )),
                      // Align(alignment: Alignment.center,
                      //   child: RawMaterialButton(
                      //     elevation: 0.0,
                      //     child: Icon(
                      //       Icons.arrow_right,
                      //       color: Colors.white,
                      //       size: 60,
                      //     ),
                      //     onPressed: ()
                      //     {
                      //     // setState(() {
                      //     // // If the video is playing, pause it.
                      //     // if (contro.value.isPlaying) {
                      //     //   contro.pause();
                      //     // } else {
                      //     // // If the video is paused, play it.
                      //     // contro.play();
                      //     // }
                      //     // });
                      //       displayVideo=vdoUrl+dta[index]["videopath"];
                      //       setState((){
                      //
                      //       });
                      //     },
                      //   ),
                      // )
                  ],
                  );
                },
                itemCount:dta.length,physics:  NeverScrollableScrollPhysics(),),
            ],
          )
      ),
    );
    //   FutureBuilder(
    //   future: _initializeVideoPlayerFuture,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done)
    //     {
    //       return AspectRatio(
    //           aspectRatio: _controller.value.aspectRatio,
    //           child: VideoPlayer(_controller));
    //     } else {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );

  }

//   Widget getIimage(String videoPath) async
//   {
//     uint8list=Image.memory((VideoThumbnail.thumbnailData(
//   video: videoPath,
//   imageFormat: ImageFormat.JPEG,
//   maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
//   quality: 25,
//   )));
// }
}