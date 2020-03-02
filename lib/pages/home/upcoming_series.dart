import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/series.dart';
import 'package:learning/models/series.service.dart';
import 'package:learning/widgets/app_series_authors.dart';
import 'package:learning/widgets/app_stream_builder.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/widgets/app_container.dart';
import 'package:learning/widgets/common_ui.dart';

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
        return UpcomingSeriesCard(series[i]);
      },
    );
  }
}

class UpcomingSeriesCard extends StatefulWidget {
  final Series series;

  const UpcomingSeriesCard(this.series);

  @override
  _UpcomingSeriesCardState createState() => _UpcomingSeriesCardState();
}

class _UpcomingSeriesCardState extends State<UpcomingSeriesCard> with SingleTickerProviderStateMixin  {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controller.value = 0;
        _controller.forward();
      },
      child: AppContainerCard(
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.series.thumb,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                    child: Lottie.asset(
                      'assets/lottie/locked_v2.json',
                      controller: _controller,
                      onLoaded: (composition) {
                        // Configure the AnimationController with the duration of the
                        // Lottie file and start the animation.
                        _controller
                            .duration = composition.duration;
                      },
                    ),
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
                        child: Text(widget.series.name,
                          style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppSeriesAuthors(widget.series.authors)
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}


