import 'package:flutter/material.dart';
import 'package:learning/pages/video/video_detail.dart';

class TempPage extends StatefulWidget {
  @override
  _TempPageState createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width / 1.7777777777777777;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: height,
              color: Colors.red,
            ),
            Container(
              height: MediaQuery.of(context).size.height - height - 24,
              child: VideoDetail(),
            )
          ],
        ),
      ),
    );
  }
}
