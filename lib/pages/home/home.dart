import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/series.dart';
import 'package:learning/models/series.service.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/pages/home/bottom_nav_video.dart';
import 'package:learning/pages/profile/my_courses.dart';
import 'package:learning/pages/profile/profile.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/widgets/app_carousel.dart';
import 'package:learning/widgets/app_container.dart';
import 'package:learning/widgets/app_loading_container.dart';
import 'package:learning/widgets/app_stream_builder.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeInfo(),
    MyCoursesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _widgetOptions.elementAt(_selectedIndex),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavVideo(),
            )
          ],
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('${AppTranslate.text(context, 'bottom_home')}', style: Theme.of(context).textTheme.display3,),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('${AppTranslate.text(context, 'bottom_course')}', style: Theme.of(context).textTheme.display3,),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('${AppTranslate.text(context, 'bottom_account')}', style: Theme.of(context).textTheme.display3,),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
    );
  }
}

class HomeInfo extends StatelessWidget {
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'Video',
      'routeName': AppRouter.videoPage,
      'icon': Icons.video_library,
    },
    {
      'title': 'History',
      'routeName': AppRouter.myVideosPage,
      'icon': Icons.playlist_add_check,
    },
    {
      'title': 'Temp',
      'routeName': AppRouter.tempPage,
      'icon': Icons.playlist_add_check,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          AppCarousel(),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${AppTranslate.text(context, 'home_title')}', style: Theme.of(context).textTheme.headline,),
                CommonUI.heightPadding(height: 5),
                Text('${AppTranslate.text(context, 'home_taken')}', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            height: 270,
            child: MyWatchList(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${AppTranslate.text(context, 'home_next')}', style: Theme.of(context).textTheme.headline,),
                CommonUI.heightPadding(height: 5),
                Text('${AppTranslate.text(context, 'home_new')}', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),),
                CommonUI.heightPadding(),
                UpcomingSeries(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyWatchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SeriesWatch> seriesWatchs = Provider.of(context);

    if(seriesWatchs == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AppContainerCard(
              shadowColor: Theme.of(context).primaryColor,
              margin: EdgeInsets.only(top: 5, bottom: 5),
              width: 226,
              height: 250,
              child: Column(
                children: <Widget>[
                  AppLoadingContainer(
                    height: 127,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    if(seriesWatchs.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20),
        child: Center(
          child: Text('No series'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: seriesWatchs.length + 1,
      itemBuilder: (context, i) {
        //show more
        if(i == seriesWatchs.length) {
          return _buildMoreCard(context);
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: _buildVideoCard(context, seriesWatchs[i]),
        );
      },
    );
  }

  Widget _buildVideoCard(BuildContext context, SeriesWatch seriesWatch){
    return InkWell(
      onTap: () {
        Provider.of<VideoState>(context, listen: false).selectedSeries = seriesWatch.sdata;
        AppRouter.navigator.pushNamed(AppRouter.videoSeriesPlayerPage);
      },
      child: AppContainerCard(
        shadowColor: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: 226,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            seriesWatch.sdata.image
                        )
                    )
                ),
                height: 127,
                width: 226,
              ),
              Container(
                height: 123,
                width: 226,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text('${seriesWatch.sdata.name}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text('someone', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),),
                  ],
                ),
              )

            ],
          ),
      ),
    );
  }

  Widget _buildMoreCard(BuildContext context) {
    return AppContainerCard(
      width: 150,
      margin: EdgeInsets.only(left:20, top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Center(child: Text('View more')),
      ),
    );
  }
}

class UpcomingSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SeriesWatch> seriesWatchs = Provider.of(context);

    if(seriesWatchs != null && seriesWatchs.length > 0){
      return AppStreamBuilder(
        stream: seriesFirebaseService.find(
          limit: 5,
          query: seriesFirebaseService.colRef.where('order', isGreaterThan: seriesWatchs[0].sdata.order),
        ),
        fn: _buildPage,
      );
    } else {
      return Container();
    }
  }

  Widget _buildPage(BuildContext context, List<Series> series){
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: series.length,
      separatorBuilder: (context, i) => CommonUI.heightPadding(),
      itemBuilder: (context, i) {
        Series s = series[i];
        return AppContainerCard(
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: s.thumb,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 30,
                    width: 30,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                    ),
                    child: Center(child: Icon(Icons.lock, size: 18,)),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(s.name,
                          style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('someone', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),),
                    ],
                  ),
                ),
              )
            ],
          )
        );
      },
    );
  }
}


