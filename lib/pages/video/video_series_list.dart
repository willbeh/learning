import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/datetime_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class VideoSeriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Video> videos = Provider.of(context);

    if(videos == null || videos.length == 0){
      return Container();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: videos.length + 1,
      separatorBuilder: (context, i) => Divider(height: 0,),
      itemBuilder: (context, i) {
        if(i == videos.length){
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: AppButton.roundedButton(context,
                text: '${AppTranslate.text(context, 'video_test')}'

            ),
          );
        }

        return VideoSeriesListTile(
          video:videos[i],
          i:i,
          previousVideo: (i>0) ? videos[i-1] : null,
        );
      },
    );
  }
}

class VideoSeriesListTile extends StatelessWidget {
  final Video video;
  final Video previousVideo;
  final int i;
  final log = getLogger('VideoSeriesListTile');
  final double iconSize = 16;

  VideoSeriesListTile({this.video, this.i, this.previousVideo});
  @override
  Widget build(BuildContext context) {
    VideoState videoState = Provider.of(context);
    List<Watch> watchs = Provider.of(context);
    bool depend = _checkDependancy(watchs);

    Watch cWatch;
    if(watchs != null)
      cWatch = watchs.firstWhere((w) => w.vid == video.vid, orElse: () => null);

    return InkWell(
      onTap: () {
        if (depend) {
          _selectVideo(context, cWatch, depend, videoState.selectedVideo.vid);
        }
      },
      child: Container(
        height: 80,
        color: (video.vid == videoState.selectedVideo.vid) ? Colors.grey.shade200 : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLeading(context, video, i, watchs),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(video.data.name, style: Theme.of(context).textTheme.display2, maxLines: 1,),
                      ),
                      Icon((depend) ? Icons.play_arrow : Icons.lock, size: iconSize, color: Colors.grey,),
                      CommonUI.widthPadding(width: 10),
                      Text('${DateTimeUtil.formatDuration(Duration(seconds: video.data.duration))}', style: Theme.of(context).textTheme.display3,),
                    ],
                  ),
                  CommonUI.heightPadding(height: 10),
                  Container(
                    height: 2,
                    child: (cWatch == null) ? _buildLinearProgress(0) : 
                    _buildLinearProgress(cWatch.position/video.data.duration),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLinearProgress(double val) {
    return LinearProgressIndicator(
      value: val,
      backgroundColor: Color(0xffF1F1F1),
    );
  }

  Widget _buildLeading(BuildContext context, Video video, int i, List<Watch> watchs) {
    Watch watch;
    if(watchs.any((watch) => watch.vid == video.vid)) {
      watch = watchs.firstWhere((watch) => watch.vid == video.vid, orElse: null);
    }
    if(watch != null && watch.status == 'completed') {
      return Container(
        width: 35,
        alignment: Alignment.centerLeft,
        child: Icon(Icons.check, color: Colors.grey,),
      );
    } else {
      return Container(
        width: 35,
        alignment: Alignment.centerLeft,
        child: Text('${i+1}', style: TextStyle(color: Colors.grey),),
      );
    }
  }

  _selectVideo(BuildContext context, Watch watch, bool depend, String selectedVid){
    if(!depend) return;
    if(video.vid == selectedVid) return;
    Provider.of<VideoState>(context, listen: false).selectVideo(video, watch);
  }

  bool _checkDependancy(List<Watch> watchs) {
    bool contain = false;
    if(watchs == null){
      return false;
    }

    switch(video.depend) {
    // contains any of the video
      case 'any':
        video.vlist.forEach((vid) {
          if(watchs.any((w) => (w.vid == vid && w.status == 'completed'))){
            contain = true;
          }
        });
        break;

    // must contain all the video
      case 'all':
        bool exist = true;
        video.vlist.forEach((vid) {
          if(exist && !watchs.any((w) => (w.vid == vid && w.status == 'completed'))){
            exist = false;
          }
        });
        contain = exist;
        break;

      default:
        contain = true;
    }
    return contain;
  }
}

