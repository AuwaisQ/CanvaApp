import 'package:flutter/material.dart';

class widgetToImage extends StatefulWidget
{
  final Function(GlobalKey key) builder;

  const widgetToImage({Key? key, required this.builder}) : super(key: key);

  //const widgetToImage({required this.builder,required Key key}):super(key: key);
  @override
  State<widgetToImage> createState() => _widgetToImageState();
}

class _widgetToImageState extends State<widgetToImage>
{
  final globalKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key:globalKey,
        child: widget.builder(globalKey),
    );
  }
}