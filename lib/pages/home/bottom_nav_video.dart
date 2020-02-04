import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/utils/logger.dart';
import 'package:provider/provider.dart';

class BottomNavVideo extends StatelessWidget {
  final log = getLogger('BottomNavVideo');

  @override
  Widget build(BuildContext context) {
    List<Watch> watchs = Provider.of(context);

    // hide bottom play if no current watch
    if(watchs == null || watchs.length == 0) {
      return Container();
    }

    Watch watch = watchs[0];
    // hide bottom play if watch completed
    if(watch.status == 'completed') {
      return Container();
    }

    List<SeriesWatch> seriesWatchs = Provider.of(context);
    SeriesWatch seriesWatch = seriesWatchs.firstWhere((s) => s.sid == watch.sid);

    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 55,
            child: CachedNetworkImage(
              imageUrl: seriesWatch.sdata.thumb,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AnimatedScrollText(title: seriesWatch.sdata.name, sub: watch.vname,),
            ),
          ),
          IconButton(
            icon: Icon(Icons.play_circle_filled, color: Colors.white, size: 27,),
            onPressed: null,
          )
        ],
      ),
    );
  }
}

class AnimatedScrollText extends StatefulWidget {
  final String title;
  final String sub;

  AnimatedScrollText({this.title, this.sub});

  @override
  _AnimatedScrollTextState createState() => _AnimatedScrollTextState();
}

class _AnimatedScrollTextState extends State<AnimatedScrollText> {
  ScrollController _scrollController;
  bool scroll = false;
  int speedFactor = 20;
  double _duration = 0;
  var log = getLogger('_AnimatedScrollTextState');

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
    if(_scrollController.position.maxScrollExtent == 0){
      return;
    }
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

    _scrollController = ScrollController()..addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent) {
        Future.delayed(Duration(seconds: 2), () {
          _scroll(forward: false);
        });
      }
      if(_scrollController.offset == 0) {
        Future.delayed(Duration(seconds: 2), () {
          _scroll(forward: true);
        });
      }
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
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${widget.title}', style: Theme.of(context).textTheme.display2.copyWith(color: Colors.white),),
          Text('${widget.sub}', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.white),),
        ],
      ),
    );
//    return ListView.builder(
//        controller: _scrollController,
//        itemCount: _list.length,
//        scrollDirection: Axis.horizontal,
//        itemBuilder: (context, i) {
//          return Text(_list[i]);
//        }
//    );
  }
}