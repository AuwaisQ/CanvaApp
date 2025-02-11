import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CanvaCustomFrame extends StatefulWidget {
  const CanvaCustomFrame({Key? key}) : super(key: key);

  @override
  _CanvaCustomFrameState createState() => _CanvaCustomFrameState();
}

class _CanvaCustomFrameState extends State<CanvaCustomFrame> {
  XFile? _image1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSelectImageDialog();
        },
        child: Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child:GridView.count(
    mainAxisSpacing: 10.0,
    crossAxisSpacing: 10.0,
    crossAxisCount: 4,children: [
    customFrame1(context),
    customFrame2(context),
    customFrame3(context),
    customFrame4(context),
    customFrame5(context),
    customFrame6(context),
    customFrame7(context),
    customFrame8(context),
    customFrame9(context),

    customFrame10(context),

    customFrame11(context),

    customFrame12(context),

    customFrame13(context),

    customFrame14(context),

    customFrame15(context),

    customFrame16(context),

    customFrame17(context),

    customFrame18(context),

    customFrame19(context),

    customFrame20(context),
    ],
            // Column(
            //   children: [
            //     customFrame1(context),
            //     SizedBox(height: 20.h),
            //     customFrame2(context),
            //     SizedBox(height: 20.h),
            //     customFrame3(context),
            //     SizedBox(height: 20.h),
            //     customFrame4(context),
            //     SizedBox(height: 20.h),
            //     customFrame5(context),
            //     SizedBox(height: 20.h),
            //     customFrame6(context),
            //     SizedBox(height: 20.h),
            //     customFrame7(context),
            //     SizedBox(height: 20.h),
            //     customFrame8(context),
            //     SizedBox(height: 20.h),
            //     customFrame9(context),
            //     SizedBox(height: 20.h),
            //     customFrame10(context),
            //     SizedBox(height: 20.h),
            //     customFrame11(context),
            //     SizedBox(height: 20.h),
            //     customFrame12(context),
            //     SizedBox(height: 20.h),
            //     customFrame13(context),
            //     SizedBox(height: 20.h),
            //     customFrame14(context),
            //     SizedBox(height: 20.h),
            //     customFrame15(context),
            //     SizedBox(height: 20.h),
            //     customFrame16(context),
            //     SizedBox(height: 20.h),
            //     customFrame17(context),
            //     SizedBox(height: 20.h),
            //     customFrame18(context),
            //     SizedBox(height: 20.h),
            //     customFrame19(context),
            //     SizedBox(height: 20.h),
            //     customFrame20(context),
            //     SizedBox(height: 20.h),
            //   ],
            // ),
          )),
    ));
  }

  void _showSelectImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Add A Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Take A Photo'),
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
    XFile? image2 = await ImagePicker().pickImage(source: source);
    if (image2 != null) {
      image2 = await _cropImage(imageFile: image2);
      setState(() {
        _image1 = image2;
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

  ///Custom Frame 1
  Widget customFrame1(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 195,
        ),
        child:_image1 ==null ? Container(): Image(
          image: FileImage(
            File(_image1!.path),
          ),
          height: 160,
          width: 180,
          fit: BoxFit.cover,
        ),
        // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
      ),
      Image.asset(
        'images/getwellsoon1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 2
  Widget customFrame2(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 125,
          left: 50,
        ),
        child: _image1 ==null ? Container():Image(
          image: FileImage(
            File(_image1!.path),
          ),
          height: 180,
          width: 315,
          fit: BoxFit.cover,
        ),
        // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
      ),
      Image.asset(
        'images/thankyou1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 3
  Widget customFrame3(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 143,
          left: 65,
        ),
        child: _image1 ==null ? Container():Image(
          image: FileImage(
            File(_image1!.path),
          ),
          height: 160,
          width: 130,
          fit: BoxFit.cover,
        ),
        // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
      ),
      Image.asset(
        'images/getwellsoon2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 4
  Widget customFrame4(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 108,
          left: 110,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(500),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 190,
            width: 190,
            fit: BoxFit.cover,
          ),
        ),
        // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
      ),
      Image.asset(
        'images/itsgirl1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 5
  Widget customFrame5(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 55,
          left: 45,
        ),
        child: RotationTransition(
          turns: new AlwaysStoppedAnimation(-6 / 360),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 265,
            width: 265,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/congratulations1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 6
  Widget customFrame6(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 110,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 190,
            width: 190,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/happyanniversary1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 7
  Widget customFrame7(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 110,
          left: 51,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100)),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 180,
            width: 150,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/happyanniversary2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 8
  Widget customFrame8(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 63,
          left: 140,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 130,
            width: 130,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/shadhanjali1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 9
  Widget customFrame9(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 120,
        ),
        child: _image1 ==null ? Container():Image(
          image: FileImage(
            File(_image1!.path),
          ),
          height: 195,
          width: 178,
          fit: BoxFit.cover,
        ),
      ),
      Image.asset(
        'images/congratulations2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 10
  Widget customFrame10(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 55,
          left: 185,
        ),
        child:_image1 ==null ? Container(): Image(
          image: FileImage(
            File(_image1!.path),
          ),
          height: 260,
          width: 215,
          fit: BoxFit.cover,
        ),
      ),
      Image.asset(
        'images/sale1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 11
  Widget customFrame11(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 85,
          left: 95,
        ),
        child:_image1 ==null ? Container(): Image(
          image: FileImage(
            File(_image1!.path),
          ),
          height: 190,
          width: 180,
          fit: BoxFit.cover,
        ),
      ),
      Image.asset(
        'images/happybirthday1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 12
  Widget customFrame12(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 110,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: _image1 ==null ? Container():Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/happybirthday2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 13
  Widget customFrame13(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 150,
          left: 125,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 145,
            width: 170,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/itsboy1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 14
  Widget customFrame14(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 140,
          left: 50,
        ),
        child: RotationTransition(
          turns: new AlwaysStoppedAnimation(8 / 360),
          child: _image1 ==null ? Container():Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 133,
            width: 145,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/itsboy2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 15
  Widget customFrame15(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 122,
          left: 190,
        ),
        child: RotationTransition(
          turns: new AlwaysStoppedAnimation(15 / 360),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child:_image1 ==null ? Container(): Image(
              image: FileImage(
                File(_image1!.path),
              ),
              height: 148,
              width: 195,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Image.asset(
        'images/congratulations3.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 16
  Widget customFrame16(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 65,
          left: 150,
        ),
        child: _image1 ==null ? Container():Image(
          image: FileImage(
            File(_image1!.path),
          ),
          height: 120,
          width: 110,
          fit: BoxFit.cover,
        ),
      ),
      Image.asset(
        'images/shrashanjali2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 17
  Widget customFrame17(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 118,
          left: 205,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/thankyou2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame18
  Widget customFrame18(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 70,
          left: 210,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child:_image1 ==null ? Container(): Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 178,
            width: 180,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/wedding1.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 19
  Widget customFrame19(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 85,
          left: 210.5,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: _image1 ==null ? Container():Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 198,
            width: 195,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/wedding2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );

  ///Custom Frame 20
  Widget customFrame20(context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 45,
          left: 200,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _image1 ==null ? Container():Image(
            image: FileImage(
              File(_image1!.path),
            ),
            height: 335,
            width: 220,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Image.asset(
        'images/sale2.png',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ],
  );
}