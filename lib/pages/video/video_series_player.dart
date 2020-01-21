import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/pages/video/video_series_detail.dart';
import 'package:learning/widgets/app_loading_container.dart';

class VideoSeriesPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  Future<bool> _onWillPop(Orientation orientation) async {
    _setOrientation(orientation);
    return false;
  }

  _setOrientation(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }

  _buildPage(BuildContext context, Orientation orientation){
    double height = (orientation == Orientation.portrait) ? MediaQuery.of(context).size.width / 1.7777777 : MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        _buildPlayer(context, orientation),
        if(orientation == Orientation.portrait)
          Container(
            height: MediaQuery.of(context).size.height - height - 24,
            child: VideoSeriesDetail(),
          )
      ],
    );
  }

  _buildPlayer(BuildContext context, Orientation orientation){
    double height = (orientation == Orientation.portrait) ? MediaQuery.of(context).size.width / 1.7777777 : MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        AppLoadingContainer(
          height: height,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon((orientation == Orientation.portrait) ? Icons.fullscreen : Icons.fullscreen_exit, color: Colors.white,),
            onPressed: () => _setOrientation(orientation),
          ),
        )
      ],
    );
  }
}

class VideoSeriesPlayer extends StatefulWidget {
  @override
  _VideoSeriesPlayerState createState() => _VideoSeriesPlayerState();
}

class _VideoSeriesPlayerState extends State<VideoSeriesPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

