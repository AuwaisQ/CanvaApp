import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

class Sliders extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Demo App')),
        ),
        body: Test(),
      );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  GlobalKey _globalKey = new GlobalKey();
  Uint8List ?byteOne;
  static _capturePng(GlobalKey _globalKey) async
  {
    try {
      print('inside');
      final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image=await boundary.toImage(pixelRatio: 3);
      final byteData=await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      //print(pngBytes);
      //print(bs64);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Widget To Image demo'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'click below given button to capture iamge',
              ),
              new MaterialButton(
                child: Text('capture Image'),
                onPressed: () async
                {
                  //byteOne=await Utils.capture(_globalKey!);
            setState((){
              this.byteOne=byteOne;
            });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// return Column(children: [
// SizedBox(height: 20,),
// CarouselSlider(items: <Widget> [
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.all(Radius.circular(10.0)),
// color: Colors.red,
// ),
// ),
//
// Container(
// decoration: BoxDecoration(
// color: Colors.green,
// borderRadius: BorderRadius.all(Radius.circular(10.0))
// ),
// ),
//
// Container(
// decoration: BoxDecoration(
// color: Colors.blue,
// borderRadius: BorderRadius.all(Radius.circular(10.0))
// ),
// ),
// ],
// options:CarouselOptions(
// enlargeCenterPage: true,
// viewportFraction: 0.95
// )
// )
// ],);