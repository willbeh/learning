import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/models/vimeo.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/datetime_util.dart';
import 'package:learning/utils/image_util.dart';
import 'package:learning/utils/logger.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

//    currentOrientation = MediaQuery.of(context).orientation;

//    SystemChrome.setPreferredOrientations([
//          DeviceOrientation.portraitUp,
//          DeviceOrientation.landscapeLeft,
//          DeviceOrientation.landscapeRight,
//        ]);

    prefs = Provider.of(context);
    vimeoState = Provider.of<VimeoState>(context);

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
      ..addListener(() {
        _logInfo();
      });

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

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
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
      ),
    );
  }
  
  Widget _buildPage(BuildContext context, Vimeo vimeo){
    double ratio = vimeo.width / vimeo.height;
    double height = (quarterTurns == 0) ? MediaQuery.of(context).size.width / ratio : MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    FadeAnimation imageFadeAnim = FadeAnimation(
      child: VideoPlayerOverlay(_controller, width, height, () => _setOrientation(), quarterTurns, () => _playVideo(), _isCompleted),
      duration: Duration(seconds: 1),
      controller: _controller,
    );
    
    return Column(
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
                  ),
                ),
              ),
//              _controller.value.isPlaying ?
//              imageFadeAnim :
//                  VideoPlayerOverlay(_controller, width, height, () => _setOrientation(), quarterTurns, () => _playVideo(), _isCompleted),
            ],
          ),
        ),
        if(quarterTurns == 0)
          Column(
            children: <Widget>[
              ListTile(
                leading: ImageUtil.showCircularImage(
                    25, vimeo.user.pictures.sizes[2].link),
                title: Text(vimeo.name, style: ThemeData.dark().textTheme.display1),
                subtitle: Text(
                  vimeo.user.name,
                  style: ThemeData.dark().textTheme.display3,
                ),
                trailing: Column(
                  children: <Widget>[
                    Icon(Icons.thumb_up),
                    Text('123')
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(vimeo.description),
              )
            ],
          )

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
      log.d('update Pref position');
      if(_controller.value.position.inSeconds - _prefPosition > 1) {
        _controller.seekTo(Duration(seconds: _prefPosition)).then((_) {
          _controller.pause();
          setState(() {});
        });
        CommonUI.alertBox(context, title: 'Cannot skip', msg: 'Cannot skip to front', onPress: () {
          Navigator.pop(context);
        });
      } else {
        _prefPosition = _controller.value.position.inSeconds;
        prefs.setInt(vimeoState.selectedVideoId, _prefPosition);
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
//      setState(() {});
//      _controller.pause().then((_) {
//        if (quarterTurns != 0) {
//          _setOrientation();
//        }
//        setState(() {});
//      });
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

  AppVideoControl(this.controller, {this.width, this.height, this.playVideo, this.changeOrientation, this.quarterTurns, this.isCompleted, this.cancelTimer, this.restartTimer});

  @override
  _AppVideoControlState createState() => _AppVideoControlState();
}

class _AppVideoControlState extends State<AppVideoControl> {
  bool _dragging = false;
  bool _isPlaying = false;
  VideoPlayerController _controller;

  var log = getLogger('_AppVideoControlState');

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {

    if(!_controller.value.initialized)
      return Container();

    return Center(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 36, color: Colors.white,),
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
                      child: (_controller.value.position == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(_controller.value.position)}'),
                    ),
                    Expanded(
                      child: AppVideoProgressBar(controller: widget.controller,
                        onDragStart: () {
                          log.d('onDragStart ${_controller.value.isPlaying}');
                          setState(() {
                            _isPlaying = _controller.value.isPlaying;
                            _dragging = true;
                          });
                          widget.cancelTimer();
                        },
                        onDragEnd: () {
                          log.d('onDragEnd $_isPlaying');
                          widget.restartTimer();
                          setState(() {
                            _dragging = false;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          (_controller.value.duration == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(_controller.value.duration)}'),
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
                  child: Text('Completed'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class VideoPlayerOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final double width;
  final double height;
  final Function changeOrientation;
  final int quarterTurns;
  final Function playVideo;
  final bool isCompleted;

  VideoPlayerOverlay(this.controller, this.width, this.height, this.changeOrientation, this.quarterTurns, this.playVideo, this.isCompleted);
  @override
  _VideoPlayerOverlayState createState() => _VideoPlayerOverlayState();
}

class _VideoPlayerOverlayState extends State<VideoPlayerOverlay> {
  VideoPlayerController _controller;
  double _iconSize = 36;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Color(0x77000000),
          height: widget.height,
          width: widget.width,
          child: Center(
              child: IconButton(
                icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: _iconSize,),
                onPressed: widget.playVideo,
              ),
          ),
        ),
        Container(
          width: widget.width,
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: (_controller.value.position == null) ? Text('0') :Text('${DateTimeUtil.formatDurationHMMSS(_controller.value.position)}'),
              ),
              if(widget.quarterTurns == 1)
                Expanded(
                  child: VideoProgressIndicator(_controller,
                    colors: VideoProgressColors(
                        playedColor: Colors.red,
                        backgroundColor: Colors.grey.shade200
                    ),
                    allowScrubbing: true,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    (_controller.value.duration == null) ? Text('0') :Text('${DateTimeUtil.formatDurationHMMSS(_controller.value.duration)}'),
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

        if(widget.quarterTurns == 0)
        Align(
          alignment: Alignment.bottomCenter,
          child: VideoProgressIndicator(_controller,
            colors: VideoProgressColors(
                playedColor: Colors.red,
                backgroundColor: Colors.grey.shade200
            ),
            allowScrubbing: true,
          ),
        ),

        if (widget.isCompleted)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('Completed'),
            ),
          ),
      ],
    );
  }
}

class FadeAnimation extends StatefulWidget {
  FadeAnimation(
      {this.child, this.duration = const Duration(milliseconds: 500), this.controller});

  final Widget child;
  final Duration duration;
  VideoPlayerController controller;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with TickerProviderStateMixin { // SingleTickerProviderStateMixin {
  AnimationController animationController;
  AnimationController inAnimationController;

  bool _showWidget = true;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    inAnimationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    inAnimationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    Future.delayed(Duration(seconds: 1), () {
      _showWidget = false;
//      _isLoaded = true;
      if (mounted)
        animationController.forward(from: 0.0);
    });
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _showWidget = true;
      inAnimationController.forward(from: 0.0);
      Future.delayed(Duration(seconds: 1), () {
        _showWidget = false;
        if (mounted)
          animationController.forward(from: 0.0);
      });
//      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    inAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _controllerWasPlaying = false;
    return GestureDetector(
      onLongPress: () {
        _isLoaded = true;
      },
      onLongPressEnd: (_) {
        _isLoaded = false;
        animationController.forward(from: 0.0);
      },
      child: _buildWidget(context),
    );
  }
  
  Widget _buildWidget(BuildContext context) {
    if (_showWidget) {
      return inAnimationController.isAnimating ? Opacity(opacity: 0.0 + inAnimationController.value,child: widget.child) : widget.child;
    }
    if (_isLoaded) {
      return widget.child;
    }

    return animationController.isAnimating
        ? Opacity(
      opacity: 1.0 - animationController.value,
      child: widget.child,
    )
        : Container();
  }
}