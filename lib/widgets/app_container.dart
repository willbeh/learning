import 'package:flutter/material.dart';

class AppContainerCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color color;
  final Color shadowColor;
  final EdgeInsetsGeometry margin;
  const AppContainerCard({this.child, this.width, this.height = 120, this.color, this.shadowColor, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      margin: margin ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(5),
//        border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.grey.shade200,
//              offset: Offset(1, 2),
              blurRadius: 3.0,
              spreadRadius: 1.0,
            )
          ]
      ),
      child: child,
    );
  }
}
