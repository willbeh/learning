import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/vimeo.dart';
import 'package:learning/pages/video/app_material_control.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/image_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/scheduler.dart';

class VideoPlayer2Page extends StatefulWidget {
  @override
  _VideoPlayer2PageState createState() => _VideoPlayer2PageState();
}

class _VideoPlayer2PageState extends State<VideoPlayer2Page> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  VimeoState vimeoState;
  SharedPreferences prefs;
  int _prefPosition = 0;
  bool hasInit = false;
  bool _isCompleted = false;

  var log = getLogger('_VideoPlayer2PageState');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!hasInit){
      hasInit = true;
      prefs = Provider.of(context);
      vimeoState = Provider.of<VimeoState>(context);

      int videoIndex = 0;
      for(int i=0; i<vimeoState.selectedVideo.files.length; i++) {
        if(vimeoState.selectedVideo.files[i].height == 540) {
          videoIndex = i;
        }
      }

      String videoFile = vimeoState.selectedVideo.files[videoIndex].link;

      int position = prefs.getInt(vimeoState.selectedVideoId);
      // if no prefs then set a 0
      if (position == null){
        position = 0;
        prefs.setInt(vimeoState.selectedVideoId, 0);
      } else if(position > 0){
        _prefPosition = position;
        if(position == vimeoState.selectedVideo.duration) {
          _isCompleted = true;
        }
      }
      log.d('position $position');

      _controller = VideoPlayerController.network(videoFile)
        ..addListener(() => _logInfo());

      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: vimeoState.selectedVideo.width / vimeoState.selectedVideo.height,
        autoPlay: false,
        looping: false,
//        allowMuting: false,
        autoInitialize: true,
        customControls: AppMaterialControl(),
        startAt: Duration(seconds: position),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Vimeo vimeo = vimeoState.selectedVideo;

    double height = (_chewieController.isFullScreen) ? MediaQuery.of(context).size.height :
    MediaQuery.of(context).size.width * (vimeo.height/vimeo.width);

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: height,
                    child: Center(
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  ),
                  _buildOverlay(),
                ],
              ),
              if(!_chewieController.isFullScreen)
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
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(){
    log.d('_chewieController.isFullScreen ${_chewieController?.isFullScreen}');
    return Stack(
      children: <Widget>[
//        if(_chewieController != null && _chewieController.isFullScreen == false)
//          Align(
//            alignment: Alignment.topRight,
//            child: IconButton(
//              icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
//              onPressed: () => Navigator.pop(context),
//            ),
//          ),
        if(_isCompleted)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Text('Completed', style: TextStyle(color: Colors.white),),
            ),
          ),
      ],
    );
  }

  _logInfo(){
    if(_controller.value.position.inSeconds > _prefPosition){
      if(_controller.value.position.inSeconds - _prefPosition > 1) {
//        _chewieController.pause();
        _chewieController.seekTo(Duration(seconds: _prefPosition)).then((_) {
          _chewieController.pause();
          CommonUI.alertBox(context, title: 'Cannot skip', msg: 'Cannot skip to front', onPress: () {
            Navigator.pop(context);
          });
        });

      } else {
        _prefPosition = _controller.value.position.inSeconds;
        prefs.setInt(vimeoState.selectedVideoId, _prefPosition);
      }
    }
    if(_controller.value.duration == _controller.value.position){
      _isCompleted = true;
    }
  }
}

