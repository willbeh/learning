import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/models/vimeo.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/image_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

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

    _controller = VideoPlayerController.network(vimeoState.selectedVideo.files[0].link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        int position = prefs.getInt(vimeoState.selectedVideoId);
        // if no prefs then set a 0
        if (position == null){
          prefs.setInt(vimeoState.selectedVideoId, 0);
        } else if(position > 0){
          _prefPosition = position;
          log.d('position $position');
          // if prefs position > 0 then seek to the position
          _controller.seekTo(Duration(seconds: position));
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

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
            switch (quarterTurns) {
              case 0:
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                break;

              case 1:
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                ]);
            }

            return SingleChildScrollView(
              child: (quarterTurns == 0) ? SafeArea(
                child: _buildPage(context, vimeo),
              ) : _buildPage(context, vimeo),
            );
          }
        ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            setState(() {
//              _controller.value.isPlaying
//                  ? _controller.pause()
//                  : _controller.play();
//            });
//          },
//          child: Icon(
//            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//          ),
//        ),
      ),
    );
  }
  
  Widget _buildPage(BuildContext context, Vimeo vimeo){
    double height = (quarterTurns == 0) ? MediaQuery.of(context).size.width * 0.5625 : MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
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
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              VideoPlayerOverlay(_controller, width, height, () => _setOrientation(), quarterTurns),
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

  _setOrientation(){
    setState(() {
      quarterTurns = (quarterTurns == 0) ? 1 : 0;
    });
  }

  _logInfo() async {
    if(_controller.value.position.inSeconds > _prefPosition){
      if(_controller.value.position.inSeconds - _prefPosition > 1) {
        log.d('${_controller.value.position.inSeconds} - $_prefPosition');
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
      _controller.pause();
      _controller.seekTo(Duration(seconds: 0));
    }
  }
}

class VideoPlayerOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final double width;
  final double height;
  final Function changeOrientation;
  final int quarterTurns;

  VideoPlayerOverlay(this.controller, this.width, this.height, this.changeOrientation, this.quarterTurns);
  @override
  _VideoPlayerOverlayState createState() => _VideoPlayerOverlayState();
}

class _VideoPlayerOverlayState extends State<VideoPlayerOverlay> {
  VideoPlayerController _controller;
  bool _isVisible = true;
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
          child: _controller.value.isPlaying ? _showPause() : _showPlay(),
        ),
        Container(
          width: widget.width,
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(''),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: IconButton(
                  icon: Icon(Icons.fullscreen, color: Colors.white,),
                  onPressed: widget.changeOrientation,
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
        )
      ],
    );
  }

  Widget _showPlay(){
    return Center(
      child: IconButton(
        icon: Icon(Icons.play_arrow, size: _iconSize,),
        onPressed: () {
          setState(() {
            _controller.play();
          });
        },
      ),
    );
  }

  Widget _showPause(){
    return Center(
      child: IconButton(
        icon: Icon(Icons.pause, size: _iconSize,),
        onPressed: () {
          setState(() {
            _controller.pause();
          });
        },
      ),
    );
  }
}