import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/series.dart';
import 'package:learning/models/series.service.dart';
import 'package:learning/states/home_page_state.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_const.dart';
import 'package:learning/widgets/app_stream_builder.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_carousel.dart';
import 'package:learning/widgets/app_container.dart';
import 'package:learning/widgets/app_loading_container.dart';
import 'package:learning/widgets/common_ui.dart';


class HomeInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          AppCarousel(),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${AppTranslate.text(context, 'home_title')}', style: Theme.of(context).textTheme.headline,),
                    InkWell(
                      onTap: () => Provider.of<HomePageState>(context, listen: false).selectedIndex = 1,
                      child: Text('${AppTranslate.text(context, 'home_all')}', style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor),),
                    )
                  ],
                ),
                CommonUI.heightPadding(height: 5),
                Text('${AppTranslate.text(context, 'home_taken')}', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            height: 270,
            child: MyWatchList(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
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
  final Logger log = getLogger('MyWatchList');

  @override
  Widget build(BuildContext context) {
    final List<SeriesWatch> seriesWatchs = Provider.of<List<SeriesWatch>>(context);

    if(seriesWatchs == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AppContainerCard(
              shadowColor: Theme.of(context).primaryColor,
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: 226,
              height: 250,
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  const AppLoadingContainer(
                    height: 127,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    if(seriesWatchs.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 20),
        child: const Center(
          child: Text('No series'),
        ),
      );
    }

    final int maxSeries = Provider.of<RemoteConfig>(context).getInt('home_series_watch');

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      // if there are more series than max, then only show the max number
      itemCount: (seriesWatchs.length > maxSeries) ? maxSeries : seriesWatchs.length + 1,
      itemBuilder: (context, i) {
        //show more
        if(i == seriesWatchs.length) {
          return _buildMoreCard(context);
        }
        // show series card
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: _buildVideoCard(context, seriesWatchs[i]),
        );
      },
    );
  }

  Widget _buildVideoCard(BuildContext context, SeriesWatch seriesWatch){
    Color shadowColor = Colors.black26;

    if(seriesWatch.status == constCompleted){
      shadowColor = Theme.of(context).primaryColor;
    }

    return InkWell(
      onTap: () {
        Provider.of<VideoState>(context, listen: false).selectedSeriesWatch = seriesWatch;
        Provider.of<VideoState>(context, listen: false).selectedSeries = seriesWatch.sdata;
        AppRouter.navigator.pushNamed(AppRouter.videoSeriesPlayerPage);
      },
      child: AppContainerCard(
        shadowColor: shadowColor,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        width: 226,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: const BorderRadius.only(
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
              ],
            ),
            Container(
              height: 123,
              width: 226,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
      width: 226,
      margin: const EdgeInsets.only(left:20, top: 5, bottom: 5, right: 20),
      child: InkWell(
        onTap: () => Provider.of<HomePageState>(context, listen: false).selectedIndex = 1,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${AppTranslate.text(context, 'home_all')}', style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
                CommonUI.heightPadding(),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpcomingSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<SeriesWatch> seriesWatchs = Provider.of(context);

    if(seriesWatchs != null && seriesWatchs.isNotEmpty){
      return AppStreamBuilder(
        stream: seriesFirebaseService.find(
          limit: Provider.of<RemoteConfig>(context).getInt('home_upcoming'),
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: series.length,
      separatorBuilder: (context, i) => CommonUI.heightPadding(),
      itemBuilder: (context, i) {
        final Series s = series[i];
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
                      margin: const EdgeInsets.all(8),
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
                    padding: const EdgeInsets.all(15),
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

