import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:canvas_365/beans/NameIdBean.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/ProgressHud.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Downloads extends StatefulWidget
{
  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  bool isProfileUpdate=false;
  String ?imageData;
  bool dataLoaded = false;
  String ?userId;
  String ?displayImage="";
  bool isApiCallingProcess=false;
  GlobalKey ?globalkey;

  var data;

  List<dynamic> dta=[];

  List<NameIdBean> posterList=[];

  var url = Uri.parse(webUrl+"getMyimage");
  Uint8List ?bytes;
  getUserData() async
  {
    final prefs = await SharedPreferences.getInstance();
    isProfileUpdate = prefs.getBool("isProfileUpdate")!;
    userId=prefs.getString("user_id")!;
    getBusinessCategory();
  }

  void getBusinessCategory() async
  {
    print(url);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String, String>
        {
          //'categoryId': categoryId.toString(),
          'userId': userId!,
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
      Map<String, dynamic> map = json.decode(response.body);
      dta = map["myimage"];
      for(int i=0;i<dta.length;i++)
      {
        displayImage=dta[0]["imagename"];
        print("First image is:$displayImage!");
        posterList.add(new NameIdBean(dta[i]["id"].toString(), dta[i]["imagename"], dta[i]["imagename"], true));
      }
      setState(() {
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
  }

  @override
  void initState()
  {
    getUserData();
    isApiCallingProcess=true;
    super.initState();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: IconButton(onPressed: ()
        // {
        //   //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomBar()));
        //   Navigator.pop(context);
        // },
        // icon: Icon(Icons.arrow_back_ios,),
        // ),
        title: Text('Your downloads',style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [            IconButton(
          onPressed: () async
          {
            final chalega=await Utils.capture(globalkey!,context);

          },
          icon: Icon(
            Icons.share,
            size: 20,
          ),
        ),
          IconButton(
            onPressed: () async
            {
              String path =imageUrl +displayImage!;
              GallerySaver.saveImage(path,albumName: "Download").then((value) => null);
              Fluttertoast.showToast(
                  msg: "Image download in gallery",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: successColor,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              //downloadAndSavePhoto();
              // var request = await HttpClient().getUrl(Uri.parse(imageUrl+displayImage!));
              // var response = await request.close();
              // bytes = await consolidateHttpClientResponseBytes(response);
              // setState((){
              //
              // });
              //await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
            },
            icon: Icon(
              Icons.file_download_outlined,
              color: Colors.white,
            ),
          ),],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //buildImage(bytes),
          if(displayImage!=null)
            widgetToImage(
          builder: (key) {
            this.globalkey = key;
            return Container(
              margin: EdgeInsets.all(5),
              height: MediaQuery
                  .of(context)
                  .size
                  .width,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(
                          imageUrl +
                              displayImage!),
                      fit: BoxFit.contain)),);
          }
            )
          else Image.asset('assets/images/noposter.png'),
          Container(
            height: MediaQuery.of(context).size.height/3,
            child: GridView.builder(scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisCount: 3),
              itemBuilder: (context, index)=>getCatImage(posterList[index].id,posterList[index].image)//posterList[index].status)
              ,itemCount: posterList.length
              )

          )
        ],),
      ),
    );
  }
  Widget getCatImage(String id,String name)
  {
    //print("https://manalsoftech.in/canva_365/img/"+name);
    return InkWell(
        onTap: ()=>
        {
        displayImage=name,
        setState((){

    })

    // if(isProfileUpdate)
    //   {
    //     displayImage=posterList[index].image,
    //     //sStatus=false,
    //     setState((){})
    //   }else
    //   {
    //     //sStatus=true,
    //     Navigator.push(context, MaterialPageRoute(builder: (_)=>Account())),
    //   }
    },
    child: Container(
    margin: EdgeInsets.all(5),
  height: 120,
  width: 120,
  decoration: BoxDecoration(
  color: Colors.white,
  image: DecorationImage(
  image: NetworkImage(
  imageUrl+name),fit: BoxFit.cover),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)]),),
    );
  }

  Widget buildImage(Uint8List? byteOne)
  {
    return byteOne!=null?Image.memory(byteOne,width: 50,):Container(child: Image.asset('assets/images/noposter.png'),);
  }

  downloadAndSavePhoto() async {
    // Get file from internet
    //var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; //%%%
    var url = Uri.parse(imageUrl + displayImage!);
    print(url.toString);
    var response = await get(url); //%%%
    print("11$response.toString");
    // documentDirectory is the unique device path to the area you'll be saving in
    var documentDirectory = await getApplicationDocumentsDirectory();
    print("22$documentDirectory");
    var firstPath = documentDirectory.path + "/images"; //%%%
    print("33$firstPath.toString");
    //You'll have to manually create subdirectories
    await Directory(firstPath).create(recursive: true); //%%%
    // Name the file, create the file, and save in byte form.
    var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    print("44$filePathAndName");
    File file2 = new File(filePathAndName); //%%%
    file2.writeAsBytesSync(response.bodyBytes); //%%%
    setState(() {
      // When the data is available, display it
      imageData = filePathAndName;
      dataLoaded = true;
    });
  }


}
