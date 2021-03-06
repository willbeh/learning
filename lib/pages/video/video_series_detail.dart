import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning/models/series.dart';
import 'package:learning/pages/video/video_series_list.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/widgets/app_series_authors.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class VideoSeriesDetail extends StatefulWidget {
  @override
  _VideoSeriesDetailState createState() => _VideoSeriesDetailState();
}

class _VideoSeriesDetailState extends State<VideoSeriesDetail> with SingleTickerProviderStateMixin{
  TabController _tabController;
  VideoState _videoState;

  @override
  void initState() {
    _videoState = Provider.of<VideoState>(context, listen: false);
    super.initState();
    _tabController = TabController(vsync: this, length: 3)
    ..addListener(() {
      if(_tabController.index == 2) {
        _tabController.animateTo(_tabController.previousIndex);
        if(_videoState.selectedSeriesWatch.enableTest) {
          AppRouter.navigator.pushNamed(AppRouter.examPage);
        }
      }

    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverSafeArea(
                  top: false,
                  sliver: SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        tabs: [
                          Tab(text: '${AppTranslate.text(context, 'video_tab_lesson')}'),
                          Tab(text: '${AppTranslate.text(context, 'video_tab_material')}'),
                          Tab(child: Row(
                            children: <Widget>[
                              if(!_videoState.selectedSeriesWatch.enableTest)
                                Icon(Icons.lock, size: 12, color: Theme.of(context).primaryColor,),
                              Text('${AppTranslate.text(context, 'video_tab_test')}')
                            ],
                          ),)
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              VideoSeriesList(),
              _buildSeriesDetail(context),
              Icon(Icons.directions_transit),
            ],
          )
      ),
    );
  }

  Widget _buildSeriesDetail(BuildContext context){
    final Series series = Provider.of<VideoState>(context).selectedSeries;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView(
//        crossAxisAlignment: CrossAxisAlignment.start,
        shrinkWrap: true,
        children: <Widget>[
          CommonUI.heightPadding(),
          if(series.header != null && series.header != '')
            Text('${series.header}', style: Theme.of(context).textTheme.title,),
          if(series.header != null && series.header != '')
            CommonUI.heightPadding(height: 15),

          if(series.subHeader != null && series.subHeader != '')
            Text('${series.subHeader}'),

          const Text('After the class you\'ll be able to:'),
          CommonUI.heightPadding(height: 10),
          if(series.about != null && series.about != '')
            Text('${series.about}', style: Theme.of(context).textTheme.display2,),
          CommonUI.heightPadding(height: 10),
          if(series.about != null && series.about != '')
            Text('${series.about}', style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.display2)),
          CommonUI.heightPadding(height: 10),
          if(series.about != null && series.about != '')
            Text('${series.about}', style: GoogleFonts.roboto(textStyle: Theme.of(context).textTheme.display2)),
          CommonUI.heightPadding(),
        ],
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
  double get maxExtent => 147; //_tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final VideoState videoState = Provider.of(context);

    final double topHeight = maxExtent - shrinkOffset - _tabBar.preferredSize.height;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
          ),
        ]
      ),

      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: (topHeight < 0) ? 0 : topHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if(topHeight > 80)
                  AppSeriesAuthors(videoState.selectedSeries.authors),
                CommonUI.heightPadding(height: 5),
                if(topHeight > 60)
                  Text('${videoState.selectedSeries.name}', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.bold), maxLines: 2,),
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