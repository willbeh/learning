import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/profile.dart';
import 'package:learning/utils/image_util.dart';
import 'package:provider/provider.dart';

class AppAvatar extends StatelessWidget {
  final double radius;
  final double fontSize;
  AppAvatar({this.radius = 30, this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    Profile profile = Provider.of(context);
    FirebaseUser user = Provider.of(context);

    String photoUrl = '';
    String photoText = '';
    if(profile.photoUrl != null && profile.photoUrl != '') {
      photoUrl = profile.photoUrl;
    } else if(user?.photoUrl != null && user?.photoUrl != '') {
      photoUrl = user.photoUrl;
    } else {
      photoText = user.email.substring(0, 1).toUpperCase();
    }

    return (photoUrl != null && photoUrl != '')
        ? ImageUtil.showCircularImage(radius, photoUrl)
        : CircleAvatar(
      child: Text('$photoText', style: TextStyle(fontSize: fontSize),), //Icon(Icons.person, size: 32,),
      radius: radius,
    );
  }
}
