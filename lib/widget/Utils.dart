import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
class Utils {
  // static capture(GlobalKey key)async
  // {
  //   if(key==null)return null;
  //   //RenderRepaintBoundary boundary=key.currentContext.findRenderObject().isRepaintBoundary;
  //   final RenderRepaintBoundary boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  //   final image=await boundary.toImage(pixelRatio: 3);
  //   final byteData=await image.toByteData(format: ui.ImageByteFormat.png);
  //   final pngBytes=byteData!.buffer.asUint8List();
  //   var bs64 = base64Encode(pngBytes);
  //   print(bs64);
  //   return pngBytes;
  // }

  static capture(GlobalKey key, context) async
  {
    if (key == null) return null;
    //RenderRepaintBoundary boundary=key.currentContext.findRenderObject().isRepaintBoundary;
    final RenderRepaintBoundary boundary = key.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);

    final directory = (await getExternalStorageDirectory())!.path;
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();
    // File imgFile = new File('$directory/screenshot.png');
    // imgFile.writeAsBytes(pngBytes);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);

    final RenderBox box = context.findRenderObject();
    List<String> paths = [];
    paths.add('$directory/screenshot.png');
    Share.shareFiles(paths, subject: 'Share ScreenShot',
        text: 'This image is created in Canva365! to download click link https://play.google.com/store/apps/details?id=com.zynomatrix.canvaz',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );

    var bs64 = base64Encode(pngBytes);
    //print(bs64);
    return pngBytes;
  }

  static capturewWithText(GlobalKey key, context,String title)
  async
  {
    if (key == null) return null;
    //RenderRepaintBoundary boundary=key.currentContext.findRenderObject().isRepaintBoundary;
    final RenderRepaintBoundary boundary = key.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);

    final directory = (await getExternalStorageDirectory())!.path;
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();
    // File imgFile = new File('$directory/screenshot.png');
    // imgFile.writeAsBytes(pngBytes);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);

    final RenderBox box = context.findRenderObject();
    List<String> paths = [];
    paths.add('$directory/screenshot.png');
    Share.shareFiles(paths, subject: 'Share ScreenShot',
        text: title,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );

    var bs64 = base64Encode(pngBytes);
    //print(bs64);
    return pngBytes;
  }

  static captureBase6(GlobalKey key) async
  {
    if (key == null) return null;
    //RenderRepaintBoundary boundary=key.currentContext.findRenderObject().isRepaintBoundary;
    final RenderRepaintBoundary boundary = key.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    var bs64 = base64Encode(pngBytes);
    return bs64;
  }

  static captureByteData(GlobalKey key) async
  {
    if (key == null) return null;
    //RenderRepaintBoundary boundary=key.currentContext.findRenderObject().isRepaintBoundary;
    final RenderRepaintBoundary boundary = key.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);

    final directory = (await getExternalStorageDirectory())!.path;
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();
    // File imgFile = new File('$directory/screenshot.png');
    // imgFile.writeAsBytes(pngBytes);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // File imgFile = new File('$directory/screenshot.png');
    // imgFile.writeAsBytes(pngBytes);
    //
    // final RenderBox box = context.findRenderObject();
    // List<String> paths = [];
    // paths.add('$directory/screenshot.png');
    // Share.shareFiles(paths, subject: 'Share ScreenShot',
    //     text: 'This image is created in Canva365! to download click link https://play.google.com/store/apps/details?id=com.zynomatrix.canvaz',
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    // );
    //
    // var bs64 = base64Encode(pngBytes);
    // //print(bs64);
    return byteData;
  }

  // static save() async
  // {
  //   print("aaya");
  //   var response = await Dio().get("https://manalsoftech.in/canva_365/img/bprofile/471632729479.jpg",options: Options(responseType: ResponseType.bytes));
  //   print("B");
  //   final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),quality: 60,
  //       name: "hello.jpg");
  //   print("C");
  //   print(result);
  //   print("D");
  //   // static captureImage(GlobalKey key)async
  //   // {
  //   //   if(key==null)return null;
  //   //   //RenderRepaintBoundary boundary=key.currentContext.findRenderObject().isRepaintBoundary;
  //   //   final RenderRepaintBoundary boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  //   //   final image=await boundary.toImage(pixelRatio: 3);
  //   //   final directory = (await getExternalStorageDirectory())!.path;
  //   //   final byteData=await image.toByteData(format: ui.ImageByteFormat.png);
  //   //   final pngBytes=byteData!.buffer.asUint8List();
  //   //   File imgFile = new File('$directory/screenshot.png');
  //   //   imgFile.writeAsBytes(pngBytes);
  //   //
  //   //   Directory? tempDir = await PathDownload().pathDownload(TypeFileDirectory.pictures);
  //   //   String tempPath = tempDir!.path;
  //   //   var filePath = tempPath + '/
  //   //
  //   //   final result = await ImageGallerySaver.saveImage(
  //   //       Uint8List.fromList(response.data),
  //   //       quality: 60,
  //   //       name: "hello");
  //   //   print(result);
  //   //   //
  //   //   // the data
  //   //   var bytes = ByteData.view(pngBytes.buffer);
  //   //   final buffer = bytes.buffer;
  //   //   // save the data in the path
  //   //   return File(filePath).writeAsBytes(buffer.asUint8List(pngBytes.offsetInBytes, pngBytes.lengthInBytes));
  //   // }
  // }
}