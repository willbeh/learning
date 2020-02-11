//import 'package:flutter/material.dart';
//
//class VideoDetail extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
////    Vimeo vimeo = Provider.of<VideoState>(context).selectedVideo.data;
//
//    return Scaffold(
//      body: DefaultTabController(
//        length: 2,
//        child: NestedScrollView(
//          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//            return <Widget>[
////              SliverAppBar(
////
////                expandedHeight: 200.0,
////                floating: false,
////                pinned: false,
////                flexibleSpace: FlexibleSpaceBar(
////                    centerTitle: true,
////                    title: Text(vimeo.name, style: Theme.of(context).textTheme.display1,),
////                ),
////              ),
//              SliverPersistentHeader(
//                delegate: _SliverAppBarDelegate(
//                  TabBar(
//                    labelColor: Colors.black87,
//                    unselectedLabelColor: Colors.grey,
//                    tabs: [
//                      Tab(text: "Episodes"),
//                      Tab(text: "Tab 2"),
//                    ],
//                  ),
//                ),
//                pinned: true,
//              ),
//            ];
//          },
//          body: TabBarView(
//            children: [
//              Icon(Icons.directions_car),
//              Icon(Icons.directions_transit),
//            ],
//          )
////          body: ListView.builder(
////            shrinkWrap: true,
////            physics: NeverScrollableScrollPhysics(),
////            itemCount: items.length,
////            itemBuilder: (context, index) {
////              return ListTile(
////                title: Text('${items[index]}'),
////              );
////            },
////          ),
////          body: SliverList(
////            delegate: SliverChildListDelegate(
////              items.map<Widget>((item) {
////                return ListTile(
////                  title: Text('$item'),
////                );
////              }).toList(),
////            ),
////          )
//        ),
//      ),
//    );
//  }
//
//
//}
//
//class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//  _SliverAppBarDelegate(this._tabBar);
//
//  final TabBar _tabBar;
//
//  @override
//  double get minExtent => _tabBar.preferredSize.height;
//  @override
//  double get maxExtent => 150; //_tabBar.preferredSize.height;
//
//  @override
//  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//
//    double topHeight = (150 - _tabBar.preferredSize.height) * (1- shrinkOffset/(150 - _tabBar.preferredSize.height));
//    return new Container(
//      color: Colors.white,
//      child: Column(
//        children: <Widget>[
//          Container(
//            height: (topHeight < 0) ? 0 : topHeight,
//            child: Text('one'),
//          ),
//          _tabBar,
//        ],
//      ),
//    );
//  }
//
//  @override
//  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//    return false;
//  }
//}