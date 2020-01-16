import 'package:flutter/material.dart';
import 'package:learning/utils/image_util.dart';

class AppAvatar extends StatelessWidget {
  final double radius;
  final String image;
  final String text;
  final double fontSize;
  AppAvatar({@required this.image, this.radius = 30, this.text = '', this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return (image != null && image != '')
        ? ImageUtil.showCircularImage(radius, image)
        : CircleAvatar(
      child: Text('$text', style: TextStyle(fontSize: fontSize),), //Icon(Icons.person, size: 32,),
      radius: radius,
    );
  }
}
