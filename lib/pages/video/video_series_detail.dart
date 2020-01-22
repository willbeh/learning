import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/datetime_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class VideoSeriesDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Episodes"),
                      Tab(text: "Tab 2"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              VideoSeriesList(),
              Icon(Icons.directions_transit),
            ],
          )
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => 120; //_tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    VideoState videoState = Provider.of(context);

    double topHeight = (maxExtent - _tabBar.preferredSize.height) * (1- shrinkOffset/(maxExtent - _tabBar.preferredSize.height));
    return new Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: (topHeight < 0) ? 0 : topHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if(topHeight > 50)
                Text('${videoState.selectedSeries.name}', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.bold),),
                if(topHeight > 40)
                CommonUI.heightPadding(height: 10),
                if(topHeight > 20)
                Text('${videoState.selectedSeries.desc}', style: Theme.of(context).textTheme.display2),
              ],
            ),
          ),
          _tabBar,
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

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
      itemCount: videos.length,
      separatorBuilder: (context, i) => Divider(height: 0,),
      itemBuilder: (context, i) {
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

    return Column(
      children: <Widget>[
        Container(
          color: (video.vid == videoState.selectedVideo.vid) ? Colors.grey.shade200 : Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                padding: EdgeInsets.only(left: 20),
                  child: Text('$i'),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(video.data.name, style: Theme.of(context).textTheme.display2,),
                    CommonUI.heightPadding(height: 5),
                    (cWatch == null) ? LinearProgressIndicator(
                      value: 0,
                    ) : LinearProgressIndicator(
                      value: cWatch.position/video.data.duration,
                    )
                  ],
                ),
              ),

              Container(
                width: 50,
                margin: EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () => _selectVideo(context, cWatch, depend, videoState.selectedVideo.vid),
                  child: Column(
                    children: <Widget>[
                      Icon((depend) ? Icons.play_arrow : Icons.lock, size: iconSize,),
                      Text('${DateTimeUtil.formatDuration(Duration(seconds: video.data.duration))}', style: Theme.of(context).textTheme.display3,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        if(video.hastest != null && video.hastest)
          Divider(height: 0,),
        if(video.hastest != null && video.hastest)
          Row(
            children: <Widget>[
              Container(width: 50,
                child: Icon(Icons.library_books, size: iconSize,),
              ),
              Expanded(child: Text('Test - ${video.data.name}', style: Theme.of(context).textTheme.display2,)),
              Container(width: 50, child: _buildTextIcon(cWatch))
            ],
          ),
      ],
    );
  }

  Widget _buildTextIcon(Watch watch){
    if(watch.status == 'completed' && watch.test) {
      return Icon(Icons.done, size: iconSize,);
    } else if(watch.status == 'completed') {
      return IconButton(
        icon: Icon(Icons.edit, size: iconSize),
        onPressed: () => AppRouter.navigator.pushNamed(AppRouter.examPage),
      );
    } else {
      return Icon(Icons.lock, size: iconSize);
    }
  }

  _selectVideo(BuildContext context, Watch watch, bool depend, String selectedVid){
    if(!depend) return;
    if(video.vid == selectedVid) return;
    log.d('_selectVideo');
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
          if(previousVideo.hastest) {
            if(watchs.any((w) => (w.vid == vid && w.test == true))){
              contain = true;
            }
          } else {
            if(watchs.any((w) => (w.vid == vid && w.status == 'completed'))){
              contain = true;
            }
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

