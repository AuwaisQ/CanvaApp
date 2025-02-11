import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget
{
  String url;
  //WebViewPage({required Key key,required this.url}):super(key: key);
  WebViewPage(this.url);
@override
WebViewExampleState createState() => WebViewExampleState(url);
}

class WebViewExampleState extends State<WebViewPage>
{
  String url;
  WebViewExampleState(this.url);
  @override
  void initState()
  {
    super.initState();
    print(url);
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      javascriptMode:JavascriptMode.unrestricted,
    );
  }
}