import 'package:flutter/material.dart';
import 'package:learning/models/series.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/widgets/app_carousel.dart';
import 'package:learning/widgets/app_drawer.dart';
import 'package:learning/states/theme_state.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
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
    List<Series> series = Provider.of(context) ?? [];
    VideoState videoState = Provider.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

class MyWatchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        _buildVideoCard(context),
        _buildVideoCard(context),
        _buildVideoCard(context),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context){
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
                Expanded(child: Text('Marketing 101', style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),)),
                Text('someone', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),)
              ],
            ),
          )

        ],
      ),
    );
  }
}

