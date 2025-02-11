import 'package:flutter/material.dart';
//import 'package:reviews_slider/reviews_slider.dart';

class reviewRating extends StatefulWidget
{
  @override
  _reviewRatingState createState() => _reviewRatingState();
}

class _reviewRatingState extends State<reviewRating> {
  @override
  Widget build(BuildContext context)
  {
    int selectedValue1=0;
    int selectedValue2=1;

    void onChange1(int value) {
      setState(() {
        selectedValue1 = value;
      });
    }

    void onChange2(int value) {
      setState(() {
        selectedValue2 = value;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'How was the help you received?',
              style: TextStyle(color: Color(0xFF6f7478), fontSize: 18),
            ),
            SizedBox(height: 20),
            // ReviewSlider(
            //   onChange: onChange1,
            // ),
            // Text(selectedValue1.toString()),
            // SizedBox(height: 20),
            // Text(
            //   '¿Cómo fue la ayuda que recibiste?',
            //   style: TextStyle(color: Color(0xFF6f7478), fontSize: 18),
            // ),
            // SizedBox(height: 20),
            // ReviewSlider(
            //     optionStyle: TextStyle(
            //       color: Colors.red,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     onChange: onChange2,
            //     initialValue: 1,
            //     options: ['Terrible', 'Malo', 'Bien', 'Vale', 'Genial']),
            // Text(selectedValue2.toString()),
          ],
        ),
      ),
    );
  }
}