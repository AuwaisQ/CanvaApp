import 'package:flutter/material.dart';
class SlideDots extends StatelessWidget
{
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context)
  {
  return AnimatedContainer(duration: Duration(milliseconds: 150),margin: EdgeInsets.symmetric(horizontal: 10),width: isActive?12:8,height: isActive?12:8,
  decoration: BoxDecoration(color: isActive?Colors.white:Colors.white,borderRadius: BorderRadius.all(Radius.circular(12))),);
  //   return Container(width: 10,margin: EdgeInsets.symmetric(horizontal: 10),height: 12,
  //     decoration: BoxDecoration(color: isActive?Colors.blueAccent:Colors.green,borderRadius: BorderRadius.all(Radius.circular(12))),);
  }

}