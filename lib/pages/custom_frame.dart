import 'dart:io';

import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/EditBusinessPage.dart';
import 'package:canvas_365/pages/changeLetterHead.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanvaCustomFrame extends StatefulWidget {
  const CanvaCustomFrame({Key? key}) : super(key: key);

  @override
  _CanvaCustomFrameState createState() => _CanvaCustomFrameState();
}

class _CanvaCustomFrameState extends State<CanvaCustomFrame> {
  XFile? _image1;

  @override
  void initState()
  {
    super.initState();
    getProfileStatus(true);
  }

  bool profileStatus = false;

  void getProfileStatus(bool isSet) async {
    //WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    profileStatus = prefs.getBool("isProfileUpdate")!;
    print("profile status is:${profileStatus}");
//     if (isSet) {
// //      getGreetingImage();
//     }
    setState(() {});
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Custom Letter Head',style: TextStyle(fontFamily: 'Varela',fontSize: 22),),
      ),

      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 0.7,
                  crossAxisCount: 2),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("1", 1)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd1.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("2", 2)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd2.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("3", 3)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd3.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("4", 4)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd4.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("5", 5)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd5.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("6", 6)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd6.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("7", 7)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd7.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("8", 8)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd8.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("9", 9)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd9.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("10", 10)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd10.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("11", 11)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd11.png',
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeLetterHead("12", 12)));
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      'assets/images/Lehd12.png',
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
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
  // Widget customFrame1(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 60,
  //         left: 195,
  //       ),
  //       child:_image1 ==null ? Container(): Image(
  //         image: FileImage(
  //           File(_image1!.path),
  //         ),
  //         height: 160,
  //         width: 180,
  //         fit: BoxFit.cover,
  //       ),
  //       // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/getwellsoon1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 2
  // Widget customFrame2(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 125,
  //         left: 50,
  //       ),
  //       child: _image1 ==null ? Container():Image(
  //         image: FileImage(
  //           File(_image1!.path),
  //         ),
  //         height: 180,
  //         width: 315,
  //         fit: BoxFit.cover,
  //       ),
  //       // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/thankyou1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 3
  // Widget customFrame3(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 143,
  //         left: 65,
  //       ),
  //       child: _image1 ==null ? Container():Image(
  //         image: FileImage(
  //           File(_image1!.path),
  //         ),
  //         height: 160,
  //         width: 130,
  //         fit: BoxFit.cover,
  //       ),
  //       // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/getwellsoon2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 4
  // Widget customFrame4(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 108,
  //         left: 110,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(500),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 190,
  //           width: 190,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       // child: Container(height: 160,width: 180,color: Colors.black.withOpacity(0.4),),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/itsgirl1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 5
  // Widget customFrame5(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 55,
  //         left: 45,
  //       ),
  //       child: RotationTransition(
  //         turns: new AlwaysStoppedAnimation(-6 / 360),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 265,
  //           width: 265,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/congratulations1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 6
  // Widget customFrame6(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 60,
  //         left: 110,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(200),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 190,
  //           width: 190,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/happyanniversary1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 7
  // Widget customFrame7(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 110,
  //         left: 51,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(100),
  //             topRight: Radius.circular(100),
  //             bottomLeft: Radius.circular(100),
  //             bottomRight: Radius.circular(100)),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 180,
  //           width: 150,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/happyanniversary2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 8
  // Widget customFrame8(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 63,
  //         left: 140,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(200),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 130,
  //           width: 130,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/shadhanjali1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 9
  // Widget customFrame9(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 60,
  //         left: 120,
  //       ),
  //       child: _image1 ==null ? Container():Image(
  //         image: FileImage(
  //           File(_image1!.path),
  //         ),
  //         height: 195,
  //         width: 178,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/congratulations2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 10
  // Widget customFrame10(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 55,
  //         left: 185,
  //       ),
  //       child:_image1 ==null ? Container(): Image(
  //         image: FileImage(
  //           File(_image1!.path),
  //         ),
  //         height: 260,
  //         width: 215,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/sale1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 11
  // Widget customFrame11(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 85,
  //         left: 95,
  //       ),
  //       child:_image1 ==null ? Container(): Image(
  //         image: FileImage(
  //           File(_image1!.path),
  //         ),
  //         height: 190,
  //         width: 180,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/happybirthday1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 12
  // Widget customFrame12(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 60,
  //         left: 110,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(200),
  //         child: _image1 ==null ? Container():Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 200,
  //           width: 200,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/happybirthday2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 13
  // Widget customFrame13(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 150,
  //         left: 125,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(200),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 145,
  //           width: 170,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/itsboy1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 14
  // Widget customFrame14(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 140,
  //         left: 50,
  //       ),
  //       child: RotationTransition(
  //         turns: new AlwaysStoppedAnimation(8 / 360),
  //         child: _image1 ==null ? Container():Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 133,
  //           width: 145,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/itsboy2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 15
  // Widget customFrame15(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 122,
  //         left: 190,
  //       ),
  //       child: RotationTransition(
  //         turns: new AlwaysStoppedAnimation(15 / 360),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(200),
  //           child:_image1 ==null ? Container(): Image(
  //             image: FileImage(
  //               File(_image1!.path),
  //             ),
  //             height: 148,
  //             width: 195,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/congratulations3.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 16
  // Widget customFrame16(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 65,
  //         left: 150,
  //       ),
  //       child: _image1 ==null ? Container():Image(
  //         image: FileImage(
  //           File(_image1!.path),
  //         ),
  //         height: 120,
  //         width: 110,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/shrashanjali2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 17
  // Widget customFrame17(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 118,
  //         left: 205,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(200),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 180,
  //           width: 180,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/thankyou2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame18
  // Widget customFrame18(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 70,
  //         left: 210,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(200),
  //         child:_image1 ==null ? Container(): Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 178,
  //           width: 180,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/wedding1.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 19
  // Widget customFrame19(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 85,
  //         left: 210.5,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(200),
  //         child: _image1 ==null ? Container():Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 198,
  //           width: 195,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/wedding2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );
  //
  // ///Custom Frame 20
  // Widget customFrame20(context) => Stack(
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(
  //         top: 45,
  //         left: 200,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: _image1 ==null ? Container():Image(
  //           image: FileImage(
  //             File(_image1!.path),
  //           ),
  //           height: 335,
  //           width: 220,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     Image.asset(
  //       'assets/assets/images/sale2.png',
  //       height: 400,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   ],
  // );

  registratinConfirmation(BuildContext context) {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Column(
              children: [
                Text(
                  'Update Business Profile',
                  style: TextStyle(fontSize: 20, fontFamily: "Varela"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            content: Text(
              "Please update your profile first! do you want to update it?",
              style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
            ),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () => {Navigator.pop(context)},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.amber),
                          child: Text(
                            "Not this time!",
                            style:
                            TextStyle(fontFamily: 'Varela', fontSize: 15),
                          ),
                          padding: EdgeInsets.all(8),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () => {
                          Navigator.pop(context),
                          _navigateAndDisplaySelection(context)
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor),
                          child: Text(
                            "Update Now",
                            style: TextStyle(
                                fontFamily: 'Varela',
                                color: Colors.white,
                                fontSize: 15),
                          ),
                          padding: EdgeInsets.all(8),
                        )),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    //Navigator.pop(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBusinessPage()),
    );
    //Navigator.push(context, MaterialPageRoute(builder: (_)=>EditBusinessPage()))
    //capImage=result.toString();
    if (result == true)
    {
      getProfileStatus(false);
      setState(() {});
    }
  }
}