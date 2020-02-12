import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning/models/series.dart';
import 'package:learning/pages/video/video_series_list.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class VideoSeriesDetail extends StatelessWidget {
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
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        onTap: (i) {
                          if(i == 2) {
                            AppRouter.navigator.pushNamed(AppRouter.examPage);
                          }
                        },
                        tabs: [
                          const Tab(text: 'LESSONS'),
                          const Tab(text: 'MATERIALS'),
                          Tab(child: Row(
                            children: <Widget>[
                              Icon(Icons.lock, size: 12, color: Theme.of(context).primaryColor,),
                              const Text('TEST')
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
            height: (topHeight < 0) ? 0 : topHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if(topHeight > 80)
                Text('${videoState.selectedSeries.name}', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.bold),),
                if(topHeight > 60)
                CommonUI.heightPadding(height: 10),
                if(topHeight > 50)
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