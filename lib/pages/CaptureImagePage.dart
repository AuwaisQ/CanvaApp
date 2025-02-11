import 'dart:io';

import 'package:camera/camera.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:flutter/material.dart';
class CaptureImagePage extends StatefulWidget
{
  @override
  _CaptureImagePageState createState() => _CaptureImagePageState();
}

class _CaptureImagePageState extends State<CaptureImagePage> with WidgetsBindingObserver
{
  CameraController ?_controller;
  Future <void> ?_initController;
  var isCameraReady=false;
  XFile ?imageFile;
  File ?fle;
  List<XFile> images=[];
  List<String> imags=[];
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state==AppLifecycleState.resumed)
      _initController=(_controller!=null?_controller!.initialize():null)!;
    if(!mounted)
      return;
    setState(() {
      isCameraReady=true;
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(body: FutureBuilder(future: _initController,builder: (context,snapshot)
    {
      if(snapshot.connectionState==ConnectionState.done)
      {
        return Stack(children: [cameraWidget(context),Align(alignment: Alignment.bottomCenter,child: Container(padding: EdgeInsets.all(10), color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.center,
                height: 60,
                width: 60,
                // decoration: BoxDecoration(
                //     color: Colors.redAccent,
                //     borderRadius: BorderRadius.all(
                //         Radius.circular(100)
                //     )
                // ),
                  child: images.length>0?Image.file(File(imageFile!.path),fit: BoxFit.contain,):Icon(Icons.image,color: primaryColor,)//Text(images.length.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),),
              ),
              Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(100)
                      )
                  ),child: GestureDetector(onTap: ()=>captureImage(context), child: Icon(Icons.camera,size: 40,color: Colors.white,))
              ),
              //IconButton(icon: Icon(Icons.camera,size: 50,color: Colors.grey,),onPressed:()=>captureImage(context) ,),
              Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(100)
                      )
                  ),child: GestureDetector(onTap: ()=>{
                    Navigator.pop(context,imageFile!.path)
                  //   Navigator.pop(context),
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>
                  // UploadProductCamera(images: images)))
              }
                  , child: Text("Done",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),))
              )
            ],),),)],);
      }else
      {
        return Center(child: CircularProgressIndicator(),);
      }
    },),);
  }

  Widget cameraWidget(context)
  {
    var camera=_controller!.value;
    final size=MediaQuery.of(context).size;
    var scale=size.aspectRatio*camera.aspectRatio;
    if(scale<1)scale=1/scale;
    return Transform.scale(scale: scale,child: CameraPreview(_controller!),);
  }

  initCamera() async
  {
    final cameras=await availableCameras();
    final firstCamera=cameras.first;
    _controller=CameraController(firstCamera,ResolutionPreset.high);
    _initController=_controller!.initialize();
    if(!mounted)
      return;
    setState(() {
      isCameraReady=true;
    });
  }

  captureImage(BuildContext context)
  {
    _controller!.takePicture().then((file) =>
    {
      setState(()
      {
        imageFile=file;
        images.add(file);
        imags.add(file.path);
      }),
      //imageFile:file,
      if(mounted)
        {
          //Navigator.push(context, MaterialPageRoute(builder: (_)=>displayPictureScreen(image: imageFile,)))
        }
    });
  }
}