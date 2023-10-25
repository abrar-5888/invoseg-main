import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  
      final String url = 'https://www.example.com'; // Replace with the URL you want to open.

  @override
  Widget build(BuildContext context) {
    return  WebviewScaffold(
        url: 'https://console.firebase.google.com/project/usman-a51d1/firestore/data/~2Fconsultation~2F1F67xj6gQ7N2EIOQQHso', // Replace with the URL you want to open.
        appBar: AppBar(
          title: Text('Webview Example'),
        ),
      );
  }
}