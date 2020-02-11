import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/utils/app_traslation_util.dart';
import 'package:learning/widgets/app_container.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class MyCoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<SeriesWatch> seriesWatchs = Provider.of(context);
    final List<SeriesWatch> ongoing = seriesWatchs.where((s) => s.status != 'completed').toList();
//    List<SeriesWatch> completed = seriesWatchs.where((s) => s.status == 'completed').toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppTranslate.text(context, 'my_courses_title')}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if(ongoing.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ongoing.length,
                separatorBuilder: (context, i) => Container(),
                itemBuilder: (context, i) {
                  return _buildSeriesCard(context, seriesWatch: ongoing[i], color: Theme.of(context).primaryColor);
                },
              ),
            CommonUI.heightPadding(),
            // TODO change to completed
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('${AppTranslate.text(context, 'my_courses_achievement')}', style: Theme.of(context).textTheme.headline,),
                ),
                CommonUI.heightPadding(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('${AppTranslate.text(context, 'my_courses_taken')}', style: Theme.of(context).textTheme.display3,),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: seriesWatchs.length,
                  separatorBuilder: (context, i) => Container(),
                  itemBuilder: (context, i) {
                    return _buildSeriesCard(context, seriesWatch: ongoing[i]);
                  },
                )
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget _buildSeriesCard(BuildContext context, {SeriesWatch seriesWatch, Color color}) {
    return AppContainerCard(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      shadowColor: color,
      height: 120,
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: seriesWatch.sdata.thumb,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text('${seriesWatch.sdata.name}',
                      style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 3,
                    ),
                  ),
                  Text('something', style: Theme.of(context).textTheme.display3.copyWith(color: Colors.grey),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
