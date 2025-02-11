import 'dart:io';
import 'dart:convert';
import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/widget/Utils.dart';
import 'package:canvas_365/widget/widgetToImage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Downloads.dart';

class Custom extends StatefulWidget {
  @override
  State<Custom> createState() => _CustomState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _CustomState extends State<Custom> {
  late AppState state;
  File? imageFile;
  List<ColorFilter> clrList = [];
  int slectedFilter = 0;
  GlobalKey? globalkey;
  bool isApiCallingProcess = false;
  bool isProfileUpdate = false;
  String? userId;
  bool? issubscribed;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
    clrList.add(ColorFilter.mode(Colors.black, BlendMode.colorDodge));
    clrList.add(ColorFilter.mode(Colors.black, BlendMode.color));
    clrList.add(ColorFilter.mode(Colors.orange, BlendMode.lighten));
    clrList.add(ColorFilter.mode(Colors.red, BlendMode.difference));
    clrList.add(ColorFilter.mode(Colors.grey, BlendMode.darken));
    clrList.add(ColorFilter.mode(Colors.blue, BlendMode.colorBurn));
    clrList.add(ColorFilter.mode(Colors.black, BlendMode.difference));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Custom Images',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final chalega = await Utils.capture(globalkey!, context);
                //final chal=await Utils.save();
              },
              icon: Icon(
                Icons.share,
                size: 20,
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon:
            //     color: Colors.black,
            //   ),
            // ),
            IconButton(
              onPressed: () async {
                isApiCallingProcess = true;
                setState(() {});
                final bs64 = await Utils.captureBase6(globalkey!);
                //print("Now BS6 id"+bs64);
                sendProductImage(bs64);
                // setState(()
                // {
                //   this.byteOne=byteOne;
                // });
                //Navigator.push(context,MaterialPageRoute(builder: (context) => Downloads()));
              },
              icon: Icon(
                Icons.save,
              ),
            ),
          ]),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                imageFile != null
                    ? widgetToImage(builder: (key) {
                        this.globalkey = key;
                        return Container(
                            child: ColorFiltered(
                                colorFilter: clrList[slectedFilter],
                                child: Image.file(
                                  imageFile!,
                                  height: 400,
                                )));
                      })
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      clrList.length,
                      (index) => imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  //child: ColorFiltered(colorFilter:ColorFilter.mode(Colors.red,BlendMode.colorDodge),child: Image.file(imageFile!,height: 100,width: 100,)) ,
                                  child: ColorFiltered(
                                      colorFilter: clrList[index],
                                      child: InkWell(
                                          onTap: (() => {
                                                slectedFilter = index,
                                                setState(() {
                                                  slectedFilter = index;
                                                })
                                              }),
                                          child: Image.file(
                                            imageFile!,
                                            height: 100,
                                            width: 100,
                                          ))),
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                        onPressed: () => {},
                        label: Text('Add Text'),
                        icon: Icon(
                          Icons.access_alarm,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          textStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                        onPressed: () => {},
                        label: Text('Add Text'),
                        icon: Icon(
                          Icons.access_alarm,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          textStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == AppState.free)
            _pickImage();
          else if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = (await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],)) as File?;
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  sendProductImage(String anShu) async {
    var url = Uri.parse(webUrl + "uploadMyimage");
    print("anshu Imaget Image" + anShu);
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-type": "multipart/form-data",
      },
      encoding: Encoding.getByName("utf-8"),
      body: jsonEncode(<String, dynamic>{
        "image": anShu,
        'userId': userId,
      }),
    );
    var body = jsonDecode(response.body);
    print(response.body);
    //print(body);
    var msg = body['msg'];

    if (body['status'] == true) {
      var imageName = body['imageName'];
      print("it i9s imageName:" + imageName);
      String path = imageUrl + imageName;
      GallerySaver.saveImage(path, albumName: "Download").then((value) => null);
      Fluttertoast.showToast(
          //msg: msg,
          msg: "Poster Download Complete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0);
      // String imageName=body['imageName'];
      // setPrefProfileData(imageName,imageType);
    } else {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    isApiCallingProcess = false;
    setState(() {});
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => Downloads()));
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    isProfileUpdate = prefs.getBool("isProfileUpdate")!;
    userId = prefs.getString("user_id")!;
    if (isProfileUpdate) {
      issubscribed = prefs.getBool("isSubscribed");
    }

    setState(() {});
    print("Is she subscribe$issubscribed");
  }
}
