import 'dart:async';
import 'dart:io';
import 'package:canvas_365/collageframe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  XFile? _image;
  XFile? _image1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CollageFrames()));
          }),
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Row(
              children: [
                ///1st Image Picker
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _showSelectImageDialog();
                    },
                    child: Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        height: 300,
                        width: screenWidth,
                        color: Colors.grey.shade400,
                        child: _image == null
                            ? const Icon(
                                Icons.add_a_photo,
                                color: Colors.white70,
                                size: 100,
                              )
                            : Image(
                                image: FileImage(
                                  File(_image!.path),
                                ),
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ),

                ///2nd Image Picker
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _showSelectImageDialog();
                    },
                    child: Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        height: 300,
                        width: screenWidth,
                        color: Colors.grey.shade400,
                        child: _image1 == null
                            ? const Icon(
                                Icons.add_a_photo,
                                color: Colors.white70,
                                size: 100,
                              )
                            : Image(
                                image: FileImage(
                                  File(_image1!.path),
                                ),
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Add Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Take Photo'),
              onPressed: () => _handleImage(source: ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: const Text('Choose From Gallery'),
              onPressed: () => _handleImage(source: ImageSource.gallery),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  void _handleImage({required ImageSource source}) async {
    Navigator.pop(context);
    XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile: imageFile);
      setState(() {
        _image = imageFile;
      });
    }

    XFile? imageFile2 = await ImagePicker().pickImage(source: source);
    if (imageFile2 != null) {
      imageFile2 = await _cropImage(imageFile: imageFile2);
      setState(() {
        _image1 = imageFile2;
      });
    }
  }

  Future<XFile?> _cropImage({required XFile imageFile}) async {
    File? croppedImage =
        (await ImageCropper().cropImage(sourcePath: imageFile.path)) as File?;

    if (croppedImage == null) {
      return null;
    }

    return XFile(croppedImage.path);
  }
}
