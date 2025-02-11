import 'package:canvas_365/others/constant.dart';
import 'package:canvas_365/pages/changecollage.dart';
import 'package:flutter/material.dart';
// import 'package:testproject/ChangeCollage.dart';
// import 'package:testproject/changecollage.dart';

class CollageFrames extends StatefulWidget {
  const CollageFrames({Key? key}) : super(key: key);

  @override
  _CollageFramesState createState() => _CollageFramesState();
}

class _CollageFramesState extends State<CollageFrames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text('Select Collage',style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: GridView.count(
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              crossAxisCount: 4,
              children: [
                collage1(context),
                collage2(context),
                collage3(context),
                collage4(context),
                collage5(context),
                collage6(context),
                collage7(context),
                collage8(context),
                // collage5(context),
              ],
            ),
          )),
    );
  }

  Widget collage1(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("1",2)));
      },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                height: 300,
                color: Colors.grey.shade400,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                height: 300,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget collage2(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("2",2)));
      },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                width: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                width: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget collage3(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("3",3)));
      },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                width: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget collage4(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("4",3)));
      },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                width: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget collage5(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("5",4)));
      },
      child: Container(
        height: 120,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget collage6(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("6",3)));
      },
      child: Container(
        height: 120,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                height: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget collage7(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("7",3)));
      },
      child: Container(
        height: 120,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                height: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget collage8(context) => Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChangeCollage("8",4)));
      },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(1),
                width: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
