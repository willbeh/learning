import 'package:flutter/material.dart';

class AppLoadingContainer extends StatefulWidget {
  final double height;
  final double width;
  final Color bgColor1;
  final Color bgColor2;
  final bool showLoadingIndicator;
  final Color loadingIndicatorColor;

  AppLoadingContainer({this.height, this.width,
    this.bgColor1 = Colors.black,
    this.bgColor2 = Colors.black54,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor = Colors.grey
  });

  @override
  _AppLoadingContainerState createState() => _AppLoadingContainerState();
}

class _AppLoadingContainerState extends State<AppLoadingContainer> with SingleTickerProviderStateMixin {
  AnimationController _animation;
  double val = 0;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..repeat(
        reverse: true,
      )
      ..addListener(() {
        setState(() {
          val = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.bgColor1,
            widget.bgColor2,
          ],
          stops: [0, val],
        ),
      ),
      child: Center(child: (widget.showLoadingIndicator) ? CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
        ) : Container(),
      ),
    );
  }
}
