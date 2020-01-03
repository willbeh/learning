import 'package:flutter/material.dart';

class AppHeroWidget extends StatelessWidget {
  final String tag;
  final VoidCallback onTap;
  final Widget child;

  AppHeroWidget({this.tag, this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
