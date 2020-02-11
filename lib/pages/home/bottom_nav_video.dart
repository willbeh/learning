import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class BottomNavVideo extends StatelessWidget {
  final Logger log = getLogger('BottomNavVideo');

  @override
  Widget build(BuildContext context) {
    final List<Watch> watchs = Provider.of(context);

    // hide bottom play if no current watch
    if(watchs == null || watchs.isEmpty) {
      return Container();
    }

    final Watch watch = watchs[0];
    // hide bottom play if watch completed
    if(watch.position >= watch.vduration) {
      return Container();
    }

    final List<SeriesWatch> seriesWatchs = Provider.of(context);
    final SeriesWatch seriesWatch = seriesWatchs.firstWhere((s) => s.sid == watch.sid);

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AnimatedScrollText(title: seriesWatch.sdata.name, sub: watch.vname,),
            ),
          ),
          IconButton(
            icon: Icon(Icons.play_circle_filled, color: Colors.white, size: 27,),
            onPressed: () {
              final VideoState videoState = Provider.of(context, listen: false);
              videoState.selectedWatch = watch;
              videoState.selectedSeries = seriesWatch.sdata;
              AppRouter.navigator.pushNamed(AppRouter.videoSeriesPlayerPage);
            },
          )
        ],
      ),
    );
  }
}

class AnimatedScrollText extends StatefulWidget {
  final String title;
  final String sub;

  const AnimatedScrollText({this.title, this.sub});

  @override
  _AnimatedScrollTextState createState() => _AnimatedScrollTextState();
}

class _AnimatedScrollTextState extends State<AnimatedScrollText> {
  ScrollController _scrollController;
  int speedFactor = 20;
  double _duration = 0;
  Logger log = getLogger('_AnimatedScrollTextState');
  Timer _timer;

  void _scroll({bool forward = true}) {
    if(_duration == 0){
      final double maxExtent = _scrollController.position.maxScrollExtent;
      final double distanceDifference = maxExtent - _scrollController.offset;
      _duration = distanceDifference / speedFactor;
    }

    _scrollController?.animateTo(forward ? _scrollController.position.maxScrollExtent : 0,
        duration: Duration(seconds: _duration.toInt()),
        curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent) {
        _timer.cancel();
        _timer = Timer(const Duration(seconds: 2), () {
          _scroll(forward: false);
        });
      }
      if(_scrollController.offset == 0) {
        _timer.cancel();
        _timer = Timer(const Duration(seconds: 2), () {
          _scroll(forward: true);
        });
      }
    });
    _timer = Timer(const Duration(seconds: 2), () {
      _scroll(forward: true);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
  }
}