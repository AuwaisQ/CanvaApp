import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class ProgressHud extends StatelessWidget
{
  final Widget child;
  final bool isAsyncCall;
  //final double opacity;
  //final Color color;
  //final Animation<Color> valueColor;

  //OtpScreen({required this.userId,required this.otp,required this.mobile_no});
  ProgressHud(this.child,this.isAsyncCall);
  // ProgressHud(
  //     {
  //     Key key,@required this.child,@required this.isAsyncCall,this.opacity=0.3,this.color=Colors.grey}):super(key: key);


  @override
  Widget build(BuildContext context)
  {
    List<Widget> widgetList=[];//new List<Widget>();
    widgetList.add(child);
    if(isAsyncCall)
    {
      final model=new Stack(
        children: [
          new Opacity(opacity: 0.3,child: ModalBarrier(dismissible: false,color: Colors.grey,),),new Center(child: Lottie.asset('assets/lottieFiles/loading.json',height: 200,width: 200,fit: BoxFit.cover),)
        ],
      );
      widgetList.add(model);
    }
    return Stack(children: widgetList,);
  }

}