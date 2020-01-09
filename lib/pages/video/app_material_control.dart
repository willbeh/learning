import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:chewie/src/material_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:learning/utils/logger.dart';
import 'package:video_player/video_player.dart';

class AppMaterialControl extends StatefulWidget {
  @override
  _AppMaterialControlState createState() => _AppMaterialControlState();
}

class _AppMaterialControlState extends State<AppMaterialControl> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  var log = getLogger('_AppMaterialControlState');

  final barHeight = 48.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  ChewieController chewieController;

  @override
  Widget build(BuildContext context) {
    if(chewieController == null)
      return Container();

    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
        context,
        chewieController.videoPlayerController.value.errorDescription,
      )
          : Center(
        child: Icon(
          Icons.error,
          color: Colors.white,
          size: 42,
        ),
      );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: Container(
        child: GestureDetector(
          onTap: () => _cancelAndRestartTimer(),
          child: AbsorbPointer(
            absorbing: _hideStuff,
            child: Column(
              children: <Widget>[
                _latestValue != null &&
                    !_latestValue.isPlaying &&
                    _latestValue.duration == null ||
                    _latestValue.isBuffering
                    ? const Expanded(
                  child: const Center(
                    child: const CircularProgressIndicator(),
                  ),
                )
                    : _buildHitArea(),
                _buildBottomBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController?.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
      BuildContext context,
      ) {
    final iconColor = Colors.white; Theme.of(context).textTheme.button.color;

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        color: Colors.black.withOpacity(0.5), //Theme.of(context).dialogBackgroundColor.withOpacity(0.5),
        child: Row(
          children: <Widget>[
//            _buildPlayPause(controller),
            chewieController.isLive
                ? Expanded(child: const Text('LIVE'))
                : _buildPosition(iconColor, true),
            chewieController.isLive ? const SizedBox() : _buildProgressBar(),
//            chewieController.allowMuting
//                ? _buildMuteButton(controller)
//                : Container(),
            if(!chewieController.isLive)
              _buildPosition(iconColor, false),
            chewieController.allowFullScreen
                ? _buildExpandButton()
                : Container(),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
//    log.d('${_latestValue.isPlaying} $_dragging');
    return Expanded(
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Center(
          child: InkWell(
            onTap: _playPause,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(48.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(_latestValue.isPlaying ? Icons.pause : Icons.play_arrow, size: 32.0, color: Colors.white,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosition(Color iconColor, bool isStart) {
    Duration position;
    if(isStart){
      position = _latestValue != null && _latestValue.position != null
          ? _latestValue.position
          : Duration.zero;
    } else {
      position = _latestValue != null && _latestValue.duration != null
          ? _latestValue.duration
          : Duration.zero;
    }

    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Text(
        '${formatDuration(position)}',
        style: TextStyle(
          fontSize: 14.0,
          color: iconColor,
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    bool isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration(seconds: 0));
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController.materialProgressColors ??
              ChewieProgressColors(
                  playedColor: Colors.red, // Theme.of(context).accentColor,
                  handleColor: Colors.red, // Theme.of(context).accentColor,
                  bufferedColor: Colors.grey, // Theme.of(context).backgroundColor,
                  backgroundColor: Colors.grey), // Theme.of(context).disabledColor),
        ),
      ),
    );
  }
}

String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

  final minutesString =
  minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

  final secondsString =
  seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

  return formattedTime;
}
