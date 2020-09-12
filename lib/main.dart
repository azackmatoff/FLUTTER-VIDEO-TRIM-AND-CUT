import 'package:flutter/material.dart';
import 'package:videotrimandcut/screens/upload_trimmed_video.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Trim & Cut by AZ Ackmatoff',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UploadTrimmedCutVideo(),
    );
  }
}
