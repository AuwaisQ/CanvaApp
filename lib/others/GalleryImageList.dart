// import 'package:flutter/material.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// class GalleryImageList extends StatefulWidget
// {
//   @override
//   State<GalleryImageList> createState() => _GalleryImageListState();
// }
//
// class _GalleryImageListState extends State<GalleryImageList>
// {
//   late List<Album> imageAlbums;
//   @override
//   void initState() async
//   {
//     getGalleryImage();
//     super.initState();
//   }
//
//   Future<void> getGalleryImage()async
//   {
//     imageAlbums = await PhotoGallery.listAlbums(mediumType: MediumType.image,);
//     print("Number of Album is:$imageAlbums.length");
//   }
//
//   @override
//   Widget build(BuildContext context)
//   {
//     return Scaffold(body: Container(child:
//     LayoutBuilder(
//       builder: (context, constraints) {
//         double gridWidth = (constraints.maxWidth - 20) / 3;
//         double gridHeight = gridWidth + 33;
//         double ratio = gridWidth / gridHeight;
//         return Container(
//           padding: EdgeInsets.all(5),
//           child: GridView.count(
//             childAspectRatio: ratio,
//             crossAxisCount: 3,
//             mainAxisSpacing: 5.0,
//             crossAxisSpacing: 5.0,
//             children: <Widget>[
//               ...?imageAlbums?.map(
//                     (album) => Column(
//                       children: <Widget>[
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(5.0),
//                           child: Container(
//                             color: Colors.grey[300],
//                             height: gridWidth,
//                             width: gridWidth,
//                             child: FadeInImage(
//                               fit: BoxFit.cover,
//                               placeholder:
//                               NetworkImage("https://canva365.com/img/none.png"),
//                               image: AlbumThumbnailProvider(
//                                 albumId: album.id,
//                                 mediumType: album.mediumType,
//                                 highQuality: true,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           alignment: Alignment.topLeft,
//                           padding: EdgeInsets.only(left: 2.0),
//                           child: Text(
//                             album.name ?? "Unnamed Album",
//                             maxLines: 1,
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               height: 1.2,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           alignment: Alignment.topLeft,
//                           padding: EdgeInsets.only(left: 2.0),
//                           child: Text(
//                             album.count.toString(),
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               height: 1.2,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//               ),
//             ],
//           ),
//         );
//       },
//     ),
//     ),);
//   }
// }