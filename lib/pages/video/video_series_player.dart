import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/pages/video/video_series_detail.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_loading_container.dart';
import 'package:learning/widgets/app_video_controller.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:learning/models/watch.service.dart';

class VideoSeriesPlayerPage extends StatefulWidget {
  @override
  _VideoSeriesPlayerPageState createState() => _VideoSeriesPlayerPageState();
}

class _VideoSeriesPlayerPageState extends State<VideoSeriesPlayerPage> {
  final Logger log = getLogger('VideoSeriesPlayerPage');
  bool _isLoaded = false;
  VideoState videoState;
  Video _currentVideo;
  VideoPlayerController _controller;
  List<Video> videos;
  SharedPreferences prefs;
  Watch _watch;
  bool _isCompleted = false;
  bool _hideStuff = false;
  Timer _hideTimer;
  Orientation _orientation = Orientation.portrait;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    videoState = Provider.of<VideoState>(context);
    videos = Provider.of(context);

    // if change video reset _controller
    if(videoState?.selectedVideo != null && _currentVideo?.vid != videoState.selectedVideo.vid){
      if(_controller != null){
        _currentVideo = videoState.selectedVideo;
        _controller.dispose();
        _setupController(context);
      }
    }

    if(!_isLoaded){
      if(videos == null || videos.isEmpty){
        return;
      }

      if(videoState.selectedSeries.id != videos[0].sid){
        return;
      }

      prefs = Provider.of(context);

      _setSelectedVideo(context);
      _currentVideo = videoState.selectedVideo;

      _setupController(context);

      _isLoaded = true;
    }
  }

  @override
  void dispose() {
    if (_controller.value.isPlaying) _updateWatchDocument(_watch.toJson());
    _controller.dispose();
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Wakelock.disable();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Color(0xffFCFCFC), //or set color with: Color(0xFF0000FF)
//      statusBarIconBrightness:Brightness.light
//    ));
  }

  @override
  Widget build(BuildContext context) {
    if(videoState?.selectedVideo == null){
      return const Scaffold(
      );
    }

    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return (orientation == Orientation.portrait)
            ? SafeArea(
          child: _buildPage(context, orientation),
        )
            :
        // overwrite back button if shown on vertical
        WillPopScope(
          onWillPop: () => _onWillPop(orientation),
          child: _buildPage(context, orientation),
        );
      }),
    );
  }

  // if full screen landscape when click back will go back to portrait
  Future<bool> _onWillPop(Orientation orientation) async {
    _setOrientation(orientation);
    return false;
  }

  void _setupController(BuildContext context){
    _isCompleted = false;
    _initWatch(context);

    int fileIndex = 0;
    // if file with height 360 exist select it
    for (int i = 0; i < videoState.selectedVideo.data.files.length; i++) {
      if (videoState.selectedVideo.data.files[i].height == 360) {
        fileIndex = i;
        break;
      }
    }

    _controller = VideoPlayerController.network(
        videoState.selectedVideo.data.files[fileIndex].link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        if (_watch != null) {
          if (_watch.position > 0 &&
              _watch.furthest != videoState.selectedVideo.data.duration) {
            _controller.seekTo(Duration(seconds: _watch.position)).then((_) {
              setState(() {});
            });
          }
          // set is completed if true
          if (_watch.furthest == videoState.selectedVideo.data.duration ||
              _watch.status == 'completed') {
            _isCompleted = true;
          }
        }
        setState(() {});
      }).catchError((error) {
        log.w('load video error $error');
        CommonUI.alertBox(context, title: 'Error', msg: 'Load video error $error', closeText: 'Close');
      })
      ..addListener(_logInfo);
  }

  Function _setOrientation(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIOverlays([]);
      _orientation = Orientation.landscape;
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      _orientation = Orientation.portrait;
    }
    return null;
  }

  Widget _buildPage(BuildContext context, Orientation orientation){
    final double height = (orientation == Orientation.portrait) ? MediaQuery.of(context).size.width / 1.7777777 : MediaQuery.of(context).size.height;
    bool haveSelectedVideo = false;
    if(videos != null && videos.isNotEmpty && videos[0].sid == videoState.selectedSeries.id) {
      haveSelectedVideo = true;
    }

//    log.d('height ${MediaQuery.of(context).size.height} - ${MediaQuery.of(context).size.height - height - 24}');

    return Column(
      children: <Widget>[
        _buildPlayer(context, orientation),
        if(haveSelectedVideo && orientation == Orientation.portrait)
          Container(
            height: MediaQuery.of(context).size.height - height - 24,
            child: VideoSeriesDetail(),
          )
      ],
    );
  }

  Widget _buildPlayer(BuildContext context, Orientation orientation) {
    final double ratio = videoState.selectedVideo.data.width / videoState.selectedVideo.data.height;
    final double height = (orientation == Orientation.portrait)
        ? MediaQuery.of(context).size.width / ratio
        : MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    if(_controller == null){
      return Container();
    }

    return Stack(
      children: <Widget>[
        if (_controller.value.initialized) Container(
          height: height,
          width: width,
          child: AspectRatio(
            aspectRatio: ratio,
            child: VideoPlayer(_controller),
          ),
        ) else AppLoadingContainer(height: height,),
        GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying) _restartTimer();
          },
          child: AnimatedOpacity(
            opacity: _hideStuff ? 0 : 1,
            duration: Duration(
                seconds: _hideStuff ? 1 : 0,
                milliseconds: _hideStuff ? 0 : 300),
            child: AppVideoControl(
              _controller,
              width: width,
              height: height,
              playVideo: _playVideo,
              changeOrientation: _setOrientation,
              isCompleted: _isCompleted,
              cancelTimer: () => _cancelTimer(),
              restartTimer: () => _restartTimer(),
              isHide: _hideStuff,
              orientation: orientation,
              seekVideo: _seekVideo,
              replayVideo: () => _seekVideo(second: -10, forward: false),
              forwardVideo: () => _seekVideo(second: 10, forward: true),
            ),
          ),
        ),
      ],
    );
  }

  void _setSelectedVideo(BuildContext context){
    final List<Watch> watchs = Provider.of(context);
    final List<Video> videos = Provider.of(context);
    videoState = Provider.of(context);

    if(watchs == null || watchs.isEmpty){
      videoState.selectedWatch = null;
      videoState.selectedVideo = videos[0];
//      setState(() {});
      return;
    }

    for(int i=0; i<watchs.length; i++){
      for(int j=0; j<videos.length; j++) {
        if(videos[j].vid == watchs[i].vid){
          videoState.selectedVideo = videos[j];
          videoState.selectedWatch = watchs[i];
//          setState(() {});
          return;
        }
      }
      videoState.selectedWatch = null;
      videoState.selectedVideo = videos[0];
    }
  }

  void _initWatch(BuildContext context){
    if (videoState.selectedWatch != null) {
      Watch wp; // preference watch
      if (prefs.getString(videoState.selectedVideo.vid) != null) {
        wp = Watch.fromJson(jsonDecode(prefs.getString(videoState.selectedVideo.vid)) as Map<String, dynamic>);
      }
      // preference watch is further than firestore
      if (wp != null && wp.furthest > videoState.selectedWatch.furthest) {
        _watch = wp;
      } else {
        _watch = videoState.selectedWatch;
      }
    } else {
      log.d('create watch');
      // insert a new document if not exist
      final FirebaseUser user = Provider.of(context);

      final Watch newWatch = Watch(
        vid: videoState.selectedVideo.vid,
        vname: videoState.selectedVideo.data.name,
        vpicture: videoState.selectedVideo.data.pictures.sizes[0].link,
        vduration: videoState.selectedVideo.data.duration,
        uid: user.uid,
        position: 0,
        furthest: 0,
        status: '',
        date: DateTime.now(),
        created: DateTime.now(),
        sid: videoState.selectedSeries.id
      );

      watchFirebaseService.insert(data: newWatch.toJson()).then((w) {
        newWatch.id = w.documentID;
        _watch = newWatch;
        videoState.selectedWatch = _watch;
        prefs.setString(w.documentID, jsonEncode(_watch.toJson()));
      }).catchError((error) {
        log.w('Insert watch error $error');
      });
    }
  }

  void _cancelTimer() {
    _hideTimer?.cancel();
//    _startHideTimer();

    setState(() {
      _hideStuff = false;
    });
  }

  void _restartTimer() {
    _hideTimer?.cancel();

    setState(() {
      _hideStuff = false;
    });

    if (_controller.value.isPlaying) {
      _startHideTimer();
    }
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  Function _playVideo() {
    if (_controller.value.isPlaying) {
      Wakelock.disable();
      _controller.pause();
      _cancelTimer();
      _updateWatchDocument(_watch.toJson());
    } else {
      Wakelock.enable();
      _controller.play();
      _startHideTimer();
    }
    setState(() {});
    return null;
  }

  Function _seekVideo({int second = -10, bool forward = false}){
    int newPosition = _controller.value.position.inSeconds + second;
    if(forward && newPosition > _controller.value.duration.inSeconds){
      newPosition = _controller.value.duration.inSeconds;
    } else if(!forward && newPosition < 0){
      newPosition = 0;
    }
    final bool isPlaying = _controller.value.isPlaying;

    if(isPlaying) _controller.pause();

    _controller.seekTo(Duration(seconds: newPosition));

    if(isPlaying) _controller.play();
    return null;
  }

  void _updateWatchDocument(Map<String, dynamic> data) {
    data['date'] = DateTime.now();
    if (_watch != null && _watch.id != '') {
      watchFirebaseService.update(id: _watch.id, data: data).catchError((error) {
        log.w('Update error $error');
      });
    }
  }

  void _logInfo(){
    if (_watch != null) {
      if (_controller.value.position.inSeconds > _watch.furthest + 1) {
        // if try to scroll further than 1 second, prevent the user
        _controller.removeListener(_logInfo);
        _controller.seekTo(Duration(seconds: _watch.furthest)).then((_) {
          if (_controller.value.isPlaying) _playVideo();
          _controller.addListener(_logInfo);
          setState(() {});
        });
        CommonUI.alertBox(context,
            title: 'Cannot skip',
            msg: 'Cannot skip to front',
            closeText: 'Continue');
      } else if (_controller.value.isPlaying &&
          _controller.value.position.inSeconds != _watch.position) {
        _watch.position = _controller.value.position.inSeconds;
        if (_watch != null &&
            _watch.status != 'completed' &&
            _watch.position > _watch.furthest) {
          _watch.furthest = _watch.position;
        }
        prefs.setString(_watch.id, jsonEncode(_watch.toJson()));
      }

      if (_controller.value.duration == _controller.value.position) {
        _watch.status = 'completed';
        _watch.position = _watch.vduration;
        _watch.furthest = _watch.vduration;
        _updateWatchDocument(_watch.toJson());

        Wakelock.disable();
        _isCompleted = true;
        _cancelTimer();

        // if full screen then switch back to small screen
        if (_orientation == Orientation.landscape) {
          _setOrientation(_orientation);
        }
        _controller.removeListener(_logInfo);
        _controller.seekTo(const Duration(seconds: 0)).then((_) {
          _controller.pause().then((_) {
            _controller.addListener(_logInfo);
            setState(() {});
          });
        });
      }
    }
  }
}