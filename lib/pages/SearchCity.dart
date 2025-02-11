import 'package:canvas_365/others/BottomBar.dart';
import 'package:canvas_365/others/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CitySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Center(child: Text('Search City',style: mainHeading2,)),
        actions: [IconButton(onPressed: (){},
            icon: Icon(Icons.arrow_forward_ios,color: Colors.black,)),],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 60,right: 60,bottom: 20),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30.0))
            ),
            child: TextButton(
              onPressed:() {Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomBar()));
              },
              child: Text('Submit',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CupertinoSearchTextField(
                prefixInsets: EdgeInsets.all(10.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),


          ],),
        ),
      ),
    );
  }
}
