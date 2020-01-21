import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/states/video_state.dart';
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
    VideoState videoState = Provider.of(context);
    List<Video> videos = Provider.of(context);
    List<Watch> watchs = Provider.of(context);

    if(videos == null || videos.length == 0){
      return Container();
    }

    // put in check in case video is loading and from different series
    if(videos[0].sid != videoState.selectedSeries.id)
      return Container();

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        Video video = videos[i];
        bool depend = _checkDependancy(video, watchs);

        return Column(
          children: <Widget>[
            ListTile(
              leading: IconButton(
                icon: Icon((depend) ? Icons.play_arrow : Icons.lock),
                onPressed: () {

                },
              ),
              title: Text(video.data.name),
            ),
            if(video.hastest != null && video.hastest)
              Divider(),
            if(video.hastest != null && video.hastest)
              ListTile(
                leading: IconButton(
                  icon: Icon((video.status == 'completed') ? Icons.edit : Icons.lock),
                ),
                title: Text('Test - ${video.data.name}'),
              )
          ],
        );
      },
    );
  }

  bool _checkDependancy(Video video, List<Watch> watchs) {
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
