import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/datetime_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class VideoSeriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Video> videos = Provider.of(context);
    final VideoState videoState = Provider.of(context);

    if(videos == null || videos.isEmpty){
      return Container();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length + 1,
      separatorBuilder: (context, i) => const Divider(height: 0,),
      itemBuilder: (context, i) {
        if(i == videos.length){
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: AppButton.roundedButton(context,
              onPressed: (videoState.selectedSeriesWatch.enableTest != null && videoState.selectedSeriesWatch.enableTest) ? () {
                AppRouter.navigator.pushNamed(AppRouter.examPage);
              } : null,
              text: '${AppTranslate.text(context, 'video_test')}',
              height: 48
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
  final Logger log = getLogger('VideoSeriesListTile');
  final double iconSize = 16;

  VideoSeriesListTile({this.video, this.i, this.previousVideo});
  @override
  Widget build(BuildContext context) {
    final VideoState videoState = Provider.of(context);
    final List<Watch> watchs = Provider.of(context);
    final bool depend = _checkDependancy(watchs);

    Watch cWatch;
    if(watchs != null) {
      cWatch = watchs.firstWhere((w) => w.vid == video.vid, orElse: () => null);
    }

    return InkWell(
      onTap: () {
        if (depend) {
          _selectVideo(context, cWatch, depend, videoState.selectedVideo.vid);
        }
      },
      child: Container(
        height: 80,
        color: (video.vid == videoState.selectedVideo.vid) ? Colors.grey.shade200 : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      Icon(depend ? Icons.play_arrow : Icons.lock, size: iconSize, color: Colors.grey,),
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
      backgroundColor: const Color(0xffF1F1F1),
    );
  }

  Widget _buildLeading(BuildContext context, Video video, int i, List<Watch> watchs) {
    Watch watch;
    if(watchs.any((watch) => watch.vid == video.vid)) {
      watch = watchs.firstWhere((watch) => watch.vid == video.vid, orElse: () => null);
    }
    if(watch != null && watch.status == 'completed') {
      return Container(
        width: 35,
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.check, color: Colors.grey,),
      );
    } else {
      return Container(
        width: 35,
        alignment: Alignment.centerLeft,
        child: Text('${i+1}', style: const TextStyle(color: Colors.grey),),
      );
    }
  }

  void _selectVideo(BuildContext context, Watch watch, bool depend, String selectedVid){
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
        for(final String vid in video.vlist) {
          if(watchs.any((w) => w.vid == vid && w.status == 'completed')){
            contain = true;
            break;
          }
        }
        break;

    // must contain all the video
      case 'all':
        bool exist = true;
        for(final String vid in video.vlist) {
          if(exist && !watchs.any((w) => w.vid == vid && w.status == 'completed')){
            exist = false;
            break;
          }
        }
        contain = exist;
        break;

      default:
        contain = true;
    }
    return contain;
  }
}

