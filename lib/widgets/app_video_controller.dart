import 'package:flutter/material.dart';
import 'package:learning/utils/datetime_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_video_progress_bar.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:video_player/video_player.dart';

class AppVideoControl extends StatefulWidget {
  final VideoPlayerController controller;
  final double width;
  final double height;
  final Function changeOrientation;
  final Function playVideo;
  final bool isCompleted;
  final Function cancelTimer;
  final Function restartTimer;
  final bool isHide;
  final Orientation orientation;
  final Function replayVideo;
  final Function forwardVideo;

  AppVideoControl(this.controller,
      {this.width,
        this.height,
        this.playVideo,
        this.changeOrientation,
        this.isCompleted,
        this.cancelTimer,
        this.restartTimer,
        this.isHide,
        this.orientation,
        this.replayVideo,
        this.forwardVideo,
      });

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
    if (!widget.controller.value.initialized) return Container();

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
              child: Container(
                width: 210,
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.replay_10,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: widget.replayVideo,
                    ),
                    IconButton(
                      icon: Icon(
                        widget.controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_circle_filled,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: widget.playVideo,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.forward_10,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: widget.forwardVideo,
                    ),
                  ],
                ),
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
                      child: AppVideoPosition(widget
                          .controller), // (widget.controller.value.position == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(widget.controller.value.position)}'),
                    ),
                    Expanded(
                      child: AppVideoProgressBar(
                        controller: widget.controller,
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
                          (widget.controller.value.duration == null)
                              ? Text('0')
                              : Text(
                            '${DateTimeUtil.formatDuration(widget.controller.value.duration)}',
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(
                              (widget.orientation == Orientation.portrait)
                                  ? Icons.fullscreen
                                  : Icons.fullscreen_exit,
                              color: Colors.white,
                            ),
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
                  child: Text(
                    'Completed',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(
          widget.orientation == Orientation.portrait
              ? Icons.keyboard_arrow_left
              : Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        onPressed: () {
          if (widget.orientation == Orientation.portrait) {
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
      if (_displayDuration.inSeconds != controller.value.position.inSeconds) {
        _displayDuration = controller.value.position;
        if (mounted) setState(() {});
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
    return (_displayDuration == null)
        ? Text('0')
        : Text(
      '${DateTimeUtil.formatDuration(_displayDuration)}',
      style: TextStyle(color: Colors.white),
    );
//    return (controller.value.position == null) ? Text('0') :Text('${DateTimeUtil.formatDuration(controller.value.position)}');
  }
}