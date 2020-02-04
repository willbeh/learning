import 'package:flutter/material.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/utils/logger.dart';
import 'package:provider/provider.dart';

class BottomNavVideo extends StatelessWidget {
  final log = getLogger('BottomNavVideo');

  @override
  Widget build(BuildContext context) {
    List<Watch> watchs = Provider.of(context);

//    log.d('${watchs[0].toJson()}');
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),

    );
  }
}

class AnimatedScrollText extends StatefulWidget {
  @override
  _AnimatedScrollTextState createState() => _AnimatedScrollTextState();
}

class _AnimatedScrollTextState extends State<AnimatedScrollText> {
  ScrollController _scrollController;
  bool scroll = false;
  int speedFactor = 20;
  double _duration = 0;
  String _text = 'These are the courses you\'ve taken so far These are the courses you\'ve taken so far';
  List<String> _list = [];

  _scroll({bool forward = true}) {
    if(_duration == 0){
      double maxExtent = _scrollController.position.maxScrollExtent;
      double distanceDifference = maxExtent - _scrollController.offset;
      _duration = distanceDifference / speedFactor;
    }

    _scrollController.animateTo((forward) ? _scrollController.position.maxScrollExtent : 0,
        duration: Duration(seconds: _duration.toInt()),
        curve: Curves.linear);
  }

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  @override
  void initState() {
    super.initState();

    _list.add(_text);
    _scrollController = ScrollController()..addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent) {
//        _list.add(_text);
//        setState(() {});
//        _scroll();
        Future.delayed(Duration(seconds: 2), () {
          _scroll(forward: false);
        });
      }
//      print('${_scrollController.position.maxScrollExtent}');
    });
    Future.delayed(Duration(seconds: 1), () {
      _toggleScrolling();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: _list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Text(_list[i]);
        }
    );
  }
}