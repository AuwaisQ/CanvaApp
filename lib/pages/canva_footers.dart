import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Footers extends StatefulWidget {
  const Footers({Key? key}) : super(key: key);

  @override
  _FootersState createState() => _FootersState();
}

class _FootersState extends State<Footers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              ///1st Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.w, right: 10.w, bottom: 5.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            // Text(
                            //   'Canva@gmail.com',
                            //   style: TextStyle(
                            //       color: Colors.white, fontSize: 15.sp),
                            // ),
                            // Text(
                            //   '+91 0000 0000 00',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 14.sp,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.h),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.r),
                                topLeft: Radius.circular(5.r))),
                        height: 25.h,
                        width: 80.w,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///2nd Footer
              Container(
                height: 350.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ///left Line
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, bottom: 40.h),
                      child: Container(
                        height: double.infinity,
                        width: 3.w,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                        ),
                      ),
                    ),

                    ///Bottom Line
                    Container(
                      margin: EdgeInsets.only(left: 10.w, bottom: 15.h),
                      height: 3.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(50.r)),
                    ),

                    ///Main Container
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 7.w, bottom: 10.h),
                          height: 80.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(50.r)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.mail,
                                size: 20,
                              ),
                              Icon(
                                Icons.phone,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.w, bottom: 10.h),
                          height: 80.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.r)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Canva@gmail.com',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                              Text(
                                '+91 0000 0000 00',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///3rd Footer
              Container(
                height: 350.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 55.h,
                      width: 350.w,
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(200.r))),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 34.h, left: 50.w),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              '+91 0000 0000 00',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 35.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(200.r))),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'City, Address Line, State-Pincode',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              ///4th Footer
              Container(
                height: 350.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child:

                    ///4th Footer
                    Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 100.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.red,
                          width: 2.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120.h,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            height: 25.h,
                            width: 180.w,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50.r)),
                            child: Center(
                              child: Text(
                                'User Name',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.sp),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 15,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                '+91 0000 00 0000',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 15.sp),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.mail,
                                size: 15,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'Canva@gmail.com',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 13.sp),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 15,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'City, Address Line, State-Pincode',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              ///5th Footer
              Container(
                  height: 350.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      border: Border.all(color: Colors.black)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 60.h,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.mail,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  Text(
                                    'Canva@gmail.com',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    '+91 0000 00 0000',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 40.h,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  Text(
                                    'City, Address Line,\nState-Pincode',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                  height: 350.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      border: Border.all(color: Colors.black)),
                  child:

                      ///6th Footer
                      Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        child: Container(
                          height: 40.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Colors.red),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.mail,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    Text(
                                      'Canva@gmail.com',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Text(
                                      '+91 0000 00 0000',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 50.h,
                            width: 100.w,
                            decoration: const BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    bottomLeft: Radius.circular(40))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 7.w,
                                ),
                                Text(
                                  'City\nAddress Line\nState-Pincode',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 11.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),

              ///7th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 80.h,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 5.0, color: Colors.red),
                          left: BorderSide(width: 5.0, color: Colors.red),
                          bottom: BorderSide(width: 5.0, color: Colors.red),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 3.h,
                                width: 15.w,
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                              ),
                              Image.asset(
                                'images/phone.png',
                                color: Colors.red,
                                height: 20.h,
                                width: 20.w,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '1234567890',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.sp),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Text(
                                  '||',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '1234567890',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.sp),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 4.h,
                                width: 15.w,
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                              ),
                              Image.asset(
                                'images/mail.png',
                                color: Colors.red,
                                height: 21.h,
                                width: 21.w,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Canva@gmail.com',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.sp),
                              ),
                              const Spacer(),
                              Container(
                                height: 20.h,
                                width: 150.w,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                        topLeft: Radius.circular(30))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/web.png',
                                      height: 20.h,
                                      width: 20.w,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'www.canva.com',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 4.h,
                                width: 15.w,
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                              ),
                              Image.asset(
                                'images/location.png',
                                color: Colors.red,
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'City Address Line State-Pincode',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              ///8th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffA7A75A),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'City Address Line State-Pincode',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 31.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff666633),
                                borderRadius: BorderRadius.circular(30)),
                            height: 25.h,
                            width: 95.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 11,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  '1234567890',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff666633),
                                borderRadius: BorderRadius.circular(30)),
                            height: 25.h,
                            width: 130.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  'canva@gmail.com',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff666633),
                                borderRadius: BorderRadius.circular(30)),
                            height: 25.h,
                            width: 130.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'images/web.png',
                                  color: Colors.white,
                                  height: 13,
                                  width: 13,
                                ),
                                // const SizedBox(
                                //   width: 2,
                                // ),
                                Text(
                                  'www.canva.com',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///9th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 25.h,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            color: const Color(0xff666633),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.r),
                              bottomLeft: Radius.circular(7.r),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/phone.png',
                              color: Colors.white,
                              height: 18,
                              width: 18,
                            ),
                            SizedBox(width: 7.w),
                            Text(
                              '123457890',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Container(
                      height: 25.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xffA7A75A),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'images/mail.png',
                                  color: Colors.white,
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'canva@gmail.com',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  height: double.infinity,
                                  width: 2.w,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Container(
                                  height: double.infinity,
                                  width: 2.w,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'images/web.png',
                                  color: Colors.white,
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'www.canva.com',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff666633),
                      ),
                      height: 25.h,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'City Address Line State-Pincode',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///10th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 25.h,
                          width: 119,
                          decoration:
                              BoxDecoration(color: Colors.yellow.shade900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/mail.png',
                                color: Colors.white,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'canva@gmail.com',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 119,
                          decoration:
                              BoxDecoration(color: Colors.blue.shade900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/web.png',
                                color: Colors.white,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'www.canva.com',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 119,
                          decoration:
                              BoxDecoration(color: Colors.green.shade900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/phone.png',
                                color: Colors.white,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '1234567890',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.pink,
                      ),
                      height: 25.h,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'City Address Line State-Pincode',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///11th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0.2.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 25.h,
                            width: 115,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/mail.png',
                                  color: Colors.black,
                                  height: 15,
                                  width: 15,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'canva@gmail.com',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 11.sp),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 25.h,
                            width: 115,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/web.png',
                                  color: Colors.black,
                                  height: 15,
                                  width: 15,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'www.canva.com',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 25.h,
                            width: 115,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/phone.png',
                                  color: Colors.black,
                                  height: 15,
                                  width: 15,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  '1234567890',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.pink)),
                          height: 25.h,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_pin,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'City Address Line State-Pincode',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///12th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 3.h,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 25.h,
                          width: 118.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/mail.png',
                                color: Colors.black,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'canva@gmail.com',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 118.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/web.png',
                                color: Colors.black,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'www.canva.com',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 118.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/phone.png',
                                color: Colors.black,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '1234567890',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Text(
                            'City Address Line State-Pincode',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///13th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            bottomRight: Radius.circular(40.r)),
                        color: Colors.deepOrange,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'City Address Line State-Pincode',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 31.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff666633),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    bottomRight: Radius.circular(20.r))),
                            height: 25.h,
                            width: 95.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 11,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  '1234567890',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff666633),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    bottomRight: Radius.circular(20.r))),
                            height: 25.h,
                            width: 130.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  'canva@gmail.com',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff666633),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    bottomRight: Radius.circular(20.r))),
                            height: 25.h,
                            width: 130.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'images/web.png',
                                  color: Colors.white,
                                  height: 13,
                                  width: 13,
                                ),
                                // const SizedBox(
                                //   width: 2,
                                // ),
                                Text(
                                  'www.canva.com',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///14th Footer
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 25.h,
                          width: 175.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepOrange, width: 2.w),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'images/web.png',
                                color: Colors.black,
                                height: 15,
                                width: 15,
                              ),
                              Text(
                                'www.canva.com',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 175.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepOrange, width: 2.w),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(40),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/phone.png',
                                color: Colors.black,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                '123567890',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 25.h,
                          width: 175.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepOrange, width: 2.w),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40.r))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/mail.png',
                                color: Colors.black,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'canva@gamil.com',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 175.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepOrange, width: 2.w),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(40),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/location.png',
                                color: Colors.black,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'Location',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
