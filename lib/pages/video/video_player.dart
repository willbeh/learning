import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/app_routes.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/pages/video/video_question.dart';
import 'package:learning/services/firestore/watch_service.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/datetime_util.dart';
import 'package:learning/utils/image_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/widgets/app_video_progress_bar.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerPage extends StatefulWidget {
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  final log = getLogger('_VideoPlayerPageState');
  VimeoState vimeoState;
  SharedPreferences prefs;
  int _prefPosition = 0;
  int quarterTurns = 0;
  bool _isCompleted = false;
  bool _isPlaying = false;
  Timer _hideTimer;
  bool _hideStuff = false;
//  Orientation currentOrientation = Orientation.portrait;

  List<bool> _taken = [false];
  bool _showInVideoQuestion = false;

  Watch _watch;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    prefs = Provider.of(context);
    vimeoState = Provider.of<VimeoState>(context);
    getWatch(context);

    _controller = VideoPlayerController.network(vimeoState.selectedVideo.files[1].link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        int position = prefs.getInt(vimeoState.selectedVideoId);
        // if no prefs then set a 0
        if (position == null){
          prefs.setInt(vimeoState.selectedVideoId, 0);
        } else if(position > 0){
          _prefPosition = position;
          // if prefs position > 0 then seek to the position
          if(position < vimeoState.selectedVideo.duration){
            _controller.seekTo(Duration(seconds: position)).then((_) {
              setState(() {});
            });
          } else if(position == vimeoState.selectedVideo.duration) {
            _isCompleted = true;
          }
        }
        setState(() {});
      }).catchError((error) {
        log.w('load video error $error');
      })
      ..addListener(_logInfo);

  }

  getWatch(BuildContext context) async {
    FirebaseUser user = Provider.of(context);
    _watch = await WatchService.getById(id: vimeoState.selectedVideoId, uid: user.uid);
    
    if(_watch == null){
      log.d('no watch');
      _watch = Watch(
        vid: vimeoState.selectedVideoId,
        uid: user.uid,
        data: vimeoState.selectedVideo
      );
      log.d('watch ${_watch.toJson()}');

//      WatchService.insert(_watch.toJson());
    } else {
      log.d('watch ${_watch.toJson()}');
    }

  }

  @override
  void dispose() {
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
  Widget build(BuildContext context) {
    Vimeo vimeo = vimeoState.selectedVideo;

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: (quarterTurns == 0) ? SafeArea(
              child: _buildPage(context, vimeo),
            ) :
            // overwrite back button if shown on vertical
            WillPopScope(
              onWillPop: () => _onWillPop(),
              child: _buildPage(context, vimeo),
            ),
          );
        }
      ),
    );
  }
  
  Widget _buildPage(BuildContext context, Vimeo vimeo){
    double ratio = vimeo.width / vimeo.height;
    double height = (quarterTurns == 0) ? MediaQuery.of(context).size.width / ratio : MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: height,
              width: width,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    child: _controller.value.initialized
                        ? Center(
                          child: AspectRatio(
                      aspectRatio: ratio, //_controller.value.aspectRatio,
                      child: GestureDetector(
                            child: VideoPlayer(_controller),
                          onTap: () {
                              if(_controller.value.isPlaying){
                                setState(() {});
                              }
                          },
                      ),
                    ),
                        )
                        : Container(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.value.isPlaying)
                        _restartTimer();
                    },
                    child: AnimatedOpacity(
                      opacity: _hideStuff ? 0 : 1,
                      duration: Duration(seconds: _hideStuff ? 1 : 0, milliseconds: _hideStuff ? 0: 300),
                      child: AppVideoControl(_controller, width: width, height: height, playVideo: () => _playVideo(),
                        changeOrientation: () => _setOrientation(),
                        quarterTurns: quarterTurns,
                        isCompleted: _isCompleted,
                        cancelTimer: () => _cancelTimer(),
                        restartTimer: () => _restartTimer(),
                        isHide: _hideStuff,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(quarterTurns == 0)
              Column(
                children: <Widget>[
                  ListTile(
                    leading: ImageUtil.showCircularImage(
                        25, vimeo.user.pictures.sizes[2].link),
                    title: Text(vimeo.name, style: Theme.of(context).textTheme.display1),
                    subtitle: Text(
                      vimeo.user.name,
                      style: Theme.of(context).textTheme.display3,
                    ),
                    trailing: Column(
                      children: <Widget>[
                        Icon(Icons.thumb_up),
                        Text('123')
                      ],
                    ),
                  ),
                  if(_isCompleted)
                    AppButton.roundedButton(context,
                      text: 'Take Exam',
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.routeExam)
                    ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(vimeo.description),
                  )
                ],
              )

          ],
        ),
        if (_showInVideoQuestion)
          Container(
            height: (quarterTurns == 0) ? MediaQuery.of(context).size.height - 20 : height,
            padding: EdgeInsets.all((quarterTurns == 0) ? 20 : 40),
            width: width,
            child: VideoQuestion(
              orientation: quarterTurns,
              continueVideo: (){
                setState(() {
                  _showInVideoQuestion = false;
                });
                _playVideo();
              },
            ),
          ),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    _setOrientation();
    return false;
  }

  _playVideo(){
    _controller.value.isPlaying ? Wakelock.disable() : Wakelock.enable();
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
    _isPlaying = _controller.value.isPlaying;
    _isPlaying ? _startHideTimer() : _cancelTimer();
    setState(() {});
  }

  _setOrientation(){
    if(quarterTurns == 0) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIOverlays([]);
    }else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
    setState(() {
      quarterTurns = (quarterTurns == 0) ? 1 : 0;
    });
  }

  _logInfo() async {
    if(_controller.value.position.inSeconds > _prefPosition){
      if(_controller.value.position.inSeconds - _prefPosition > 1) {
        _controller.removeListener(_logInfo);
        _controller.seekTo(Duration(seconds: _prefPosition)).then((_) {
          if(_controller.value.isPlaying)
            _playVideo();
          _controller.addListener(_logInfo);
//            _controller.pause();
          setState(() {});
        });

        CommonUI.alertBox(context, title: 'Cannot skip', msg: 'Cannot skip to front', closeText: 'Continue');
      } else {
        if(_controller.value.isPlaying){
          _prefPosition = _controller.value.position.inSeconds;
          prefs.setInt(vimeoState.selectedVideoId, _prefPosition);
        }
      }
    }
    if(_controller.value.duration == _controller.value.position){
      log.d('end ${_controller.value.isPlaying}');
      Wakelock.disable();
      _isCompleted = true;
      _cancelTimer();
      if (quarterTurns != 0) {
        _setOrientation();
      }
      _controller.seekTo(Duration(seconds: 0)).then((_) {
        _controller.pause().then((_) {
          if (quarterTurns != 0) {
            _setOrientation();
          }
          setState(() {});
        });
      });
    }
    if(_isPlaying != _controller.value.isPlaying){
      _isPlaying = _controller.value.isPlaying;
      setState(() {});
    }
    _showQuestion();
  }

  _showQuestion(){
    if(_taken[0] == false && _controller.value.position.inSeconds == 22 && _controller.value.isPlaying){
      _playVideo();
      setState(() {
        _taken[0] = true;
        _showInVideoQuestion = true;
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

    if(_controller.value.isPlaying) {
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
}

class AppVideoControl extends StatefulWidget {
  final VideoPlayerController controller;
  final double width;
  final double height;
  final Function changeOrientation;
  final int quarterTurns;
  final Function playVideo;
  final bool isCompleted;
  final Function cancelTimer;
  final Function restartTimer;
  final bool isHide;

  AppVideoControl(this.controller, {this.width, this.height, this.playVideo, this.changeOrientation, this.quarterTurns, this.isCompleted, this.cancelTimer, this.restartTimer, this.isHide});

  @override
  _AppVideoControlState createState() => _AppVideoControlState();
}

class _AppVideoControlState extends State<AppVideoControl> {
//  bool _dragging = false;
//  VideoPlayerController _controller;

  var log = getLogger('_AppVideoControlState');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!widget.controller.value.initialized)
      return Container();

    return AbsorbPointer(
      absorbing: widget.isHide,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 36, color: Colors.white,),
                onPressed: widget.playVideo,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: AppVideoPosition(widget.controller), // (widget.controller.value.position == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(widget.controller.value.position)}'),
                    ),
                    Expanded(
                      child: AppVideoProgressBar(controller: widget.controller,
                        onDragStart: () {
                          widget.cancelTimer();
                        },
                        onDragEnd: () {
                          widget.restartTimer();
                        },
                        onTapDown: () {
                          widget.restartTimer();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          (widget.controller.value.duration == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(widget.controller.value.duration)}', style: TextStyle(color: Colors.white),),
                          IconButton(
                            icon: Icon((widget.quarterTurns == 0) ? Icons.fullscreen : Icons.fullscreen_exit, color: Colors.white,),
                            onPressed: widget.changeOrientation,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (widget.isCompleted)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Completed', style: TextStyle(color: Colors.white),),
                ),
              ),

            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(){
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(widget.quarterTurns == 0 ? Icons.keyboard_arrow_left :Icons.keyboard_arrow_down, color: Colors.white,),
        onPressed: () {
          if(widget.quarterTurns == 0) {
            Navigator.of(context).pop();
          } else {
            widget.changeOrientation();
          }
        },
      ),
    );
  }
}

class AppVideoPosition extends StatefulWidget {
  final VideoPlayerController controller;

  AppVideoPosition(this.controller);
  @override
  _AppVideoPositionState createState() => _AppVideoPositionState();
}

class _AppVideoPositionState extends State<AppVideoPosition> {
  _AppVideoPositionState() {
    listener = () {
      if(_displayDuration.inSeconds != controller.value.position.inSeconds){
        _displayDuration = controller.value.position;
        if(mounted)
          setState(() {});
      }
    };
  }

  VoidCallback listener;
  Duration _displayDuration = Duration(seconds: 0);

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return (_displayDuration == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(_displayDuration)}', style: TextStyle(color: Colors.white),);
//    return (controller.value.position == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(controller.value.position)}');
  }
}
