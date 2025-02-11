// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// class videoToImage extends StatefulWidget
// {
//   String videoUrl="";
//   videoToImage(this.videoUrl);
//   @override
//   State<videoToImage> createState() => _videoToImageState(videoUrl);
// }
//
// class _videoToImageState extends State<videoToImage>
// {
//   String videoUrl="";
//   Uint8List ?uint8list;
//
//
//   _videoToImageState(this.videoUrl);
//   @override
//   Widget build(BuildContext context)
//   {
//     // TODO: implement build
//     return Image.memory(getIt("https://canva365.com/videos/SampleVideo_1280x720_1mb.mp4"));
//   }
//
//   getIt(String videoPath) async
//   {
//     uint8list = await VideoThumbnail.thumbnailData(
//       video: videoPath,
//       imageFormat: ImageFormat.JPEG,
//       maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
//       quality: 25,
//     );
//   }
//
//   getIimage(String videoPath) async
//   {
//     uint8list=(VideoThumbnail.thumbnailData(
//   video: videoPath,
//   imageFormat: ImageFormat.JPEG,
//   maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
//   quality: 25,
//   )) as Uint8List?;
// }
// }