import 'dart:io';
import 'dart:typed_data';
import 'package:canvas_365/others/constant.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lecle_downloads_path_provider/constants/downloads_directory_type.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:open_file_safe/open_file_safe.dart';
// import 'package:path_download/path_download.dart';
import 'package:path_provider/path_provider.dart';

List<String> trace=[];
String trac="";
List<String> uniqueNumbers=[];
int selectLanguage=0;
class LanguageTest extends StatelessWidget
{
  const LanguageTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text("it is a testign page"),centerTitle: true,),
      body: Center(
        child: Column(children: [Container(
          height: 50,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          child: TextButton(
            onPressed:()
            {
              //openFile(url:"https://manalsoftech.in/canva_365/img/bprofile/471632729479.jpg",fileName:'aaa.jpg');
              //openFile(url:"https://manalsoftech.in/canva_365/img/bprofile/471632729479.jpg");
              //writeFile()
              _save();
            },
            child: Text('Download Image',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),],),
      ),
    );
  }
  Future openFile({required String url,String? fileName}) async
  {
    final name=fileName ??url.split('/').last;
    final file= await downloadFile(url,name);
    //final file= await downloadFile(url,fileName!);
   if(file==null) return;
     print('Path:${file.path}');
     OpenFile.open(file.path);
  }

  Future<File?> pickFile() async
  {
    final result=await FilePicker.platform.pickFiles();
    if(result==null)return null;
    return File(result.files.first.path!);
  }

  Future<File?> downloadFile(String url,String fileName) async
  {
    final appStorage = await getApplicationDocumentsDirectory();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory? downloadsDirectory = await
    // PathDownload().pathDownload(TypeFileDirectory.pictures);
    DownloadsPath.downloadsDirectory(dirType: DownloadDirectoryTypes.pictures);

    String dir="";
    if(Platform.isAndroid) {
      dir = (await getExternalStorageDirectory())!.path;
    } else if(Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    print("Now it is downloader$downloadsDirectory");

    print("temperory Path is:$tempPath");
    final file = File('${downloadsDirectory}/$fileName');
    try {
      final response = await Dio().get(url, options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    }catch(e)
    {

    }
    return null;
  }

  Future<File> writeFile(Uint8List data, String name) async
  {
    // storage permission ask
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    // the downloads folder path
    Directory? tempDir = await
    // PathDownload().pathDownload(TypeFileDirectory.pictures);
    DownloadsPath.downloadsDirectory(dirType: DownloadDirectoryTypes.pictures);
    String tempPath = tempDir!.path;
    var filePath = tempPath + '/$name';
    //

    // the data
    var bytes = ByteData.view(data.buffer);
    final buffer = bytes.buffer;
    // save the data in the path
    return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void _save() async {
    String path ='https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    GallerySaver.saveImage(path,albumName: "Download").then((value) => null);
    // GallerySaver.saveImage(path, albumName: "canva").then((bool success)
    // {
    //
    // });
  }


// _save() async {
  //   var response = await Dio().get
  //     (
  //       "https://manalsoftech.in/canva_365/img/bprofile/471632729479.jpg",
  //       options: Options(responseType: ResponseType.bytes));
  //   final result = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(response.data),
  //       quality: 60,
  //       name: "hello");
  //   print(result);
  // }
}