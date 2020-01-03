import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final double radius;
  final String image;
  AppAvatar({@required this.image, this.radius = 30});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: radius * 2,
          child: Image.asset(image, fit: BoxFit.cover, height: radius*2,),
      ),
    );
  }
}
