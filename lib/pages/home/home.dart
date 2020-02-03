import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/series.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/pages/profile/profile.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/widgets/app_carousel.dart';
import 'package:learning/states/theme_state.dart';
import 'package:learning/widgets/app_loading_container.dart';
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
    Text(
      'My Course',
      style: optionStyle,
    ),
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
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('My Courses'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        )
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
    ThemeState themeState = Provider.of(context);
//    List<Series> series = Provider.of(context) ?? [];
    VideoState videoState = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppCarousel(),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('TWENTY7 Academy', style: Theme.of(context).textTheme.headline,),
                CommonUI.heightPadding(height: 5),
                Text('These are the courses you\'ve taken so far', style: Theme.of(context).textTheme.display4.copyWith(color: Colors.grey),)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            height: 270,
            child: MyWatchList(),
          ),
        ],
      ),
    );
  }
}

class AnimatedScrollText extends StatefulWidget {
  @override
  _AnimatedScrollTextState createState() => _AnimatedScrollTextState();
}

class _AnimatedScrollTextState extends State<AnimatedScrollText> {
  ScrollController _scrollController;
  bool scroll = false;
  int speedFactor = 20;
  double _duration = 0;
  String _text = 'These are the courses you\'ve taken so far These are the courses you\'ve taken so far';
  List<String> _list = [];

  _scroll({bool forward = true}) {
    if(_duration == 0){
      double maxExtent = _scrollController.position.maxScrollExtent;
      double distanceDifference = maxExtent - _scrollController.offset;
      _duration = distanceDifference / speedFactor;
    }

    _scrollController.animateTo((forward) ? _scrollController.position.maxScrollExtent : 0,
        duration: Duration(seconds: _duration.toInt()),
        curve: Curves.linear);
  }

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  @override
  void initState() {
    super.initState();

    _list.add(_text);
    _scrollController = ScrollController()..addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent) {
//        _list.add(_text);
//        setState(() {});
//        _scroll();
        Future.delayed(Duration(seconds: 2), () {
          _scroll(forward: false);
        });
      }
//      print('${_scrollController.position.maxScrollExtent}');
    });
    Future.delayed(Duration(seconds: 1), () {
      _toggleScrolling();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _list.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) {
        return Text(_list[i]);
      }
    );
  }
}



class MyWatchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SeriesWatch> seriesWatchs = Provider.of(context);

    if(seriesWatchs == null) {
      return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: AppLoadingContainer(
          height: 120,
          width: 120,
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
          padding: const EdgeInsets.only(right: 20),
          child: _buildVideoCard(context, seriesWatchs[i]),
        );
      },
    );
  }

  Widget _buildVideoCard(BuildContext context, SeriesWatch seriesWatch){
    return Container(
      margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
//        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0
          )
        ]
      ),
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
                Text('someone', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),)
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget _buildMoreCard(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Center(child: Text('View more')),
      ),
    );
  }
}

