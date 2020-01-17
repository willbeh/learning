import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/services/firestore/video_service.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/datetime_util.dart';
import 'package:learning/utils/image_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:learning/widgets/app_stream_builder.dart';


class VideoPage extends StatelessWidget {
  final List<String> videoId = ['382521859', '382353755', '382117382', '382248454'];
  final log = getLogger('VideoPage');
  DateTime now = DateTime.now();

  final Map<String, String> headers = {
    'Accept': 'application/vnd.vimeo.*+json;version=3.4',
//    'Authorization': 'Bearer db9504925660ccc4e741b2ba339658fa',
    'Authorization': 'Bearer 1e75ca442f1666bf534893e2cd923f83',

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.transparent,
        title: Text('Video'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int result) {
              if(result == 0) {
                SharedPreferences prefs = Provider.of<SharedPreferences>(context, listen: false);
                prefs.clear();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Reset'),
              ),
            ],
          )
        ],
      ),
      body: AppStreamBuilder(
        stream: VideoService.find(),
        fn: _buildPage,
      ),
    );
  }

  _buildPage(BuildContext context, List<Video> videos) {
    List<Watch> watchs = Provider.of<List<Watch>>(context) ?? [];

    return ListView.separated(
      itemCount: videos.length,
      separatorBuilder: (_, __) => Divider(height: 0,),
      itemBuilder: (context, i) {
        Video video = videos[i];

        if (video.data != null) {
          return _buildVideoContainer(context, video, watchs);
        }

        return FutureBuilder(
          future: http.get('https://api.vimeo.com/videos/${video.vid}',
              headers: headers),
          builder: (context, AsyncSnapshot<http.Response> snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Text('${snapshot.error}'),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;

              case ConnectionState.waiting:
                return Container(
                  height: (MediaQuery.of(context).size.width * 0.5625) + 50,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                break;

              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.data.statusCode == 200) {
//                    Vimeo vimeo = Vimeo.fromJson(json.decode(snapshot.data.body));
                    video.data = json.decode(snapshot.data.body);
                    video.date = DateTime.now();
                    log.d('${snapshot.data.body}');
                    VideoService.update(
                      id: video.vid,
                      data: {
                        'data': json.decode(snapshot.data.body),
                        'date': DateTime.now(),
                      },
                    ).catchError((error) {
                      log.d('updateError $error');
                    });
                    return _buildVideoContainer(context, video, watchs);
                  }
                }
                break;

              case ConnectionState.active:
                break;
            }

            return Container();
          },
        );
      },
    );
  }

  Widget _buildVideoContainer(BuildContext context, Video video, List<Watch> watchs) {
    bool contain = _checkDependancy(video, watchs);

    return InkWell(
      onTap: () {
        if (contain) {
          Future.delayed(Duration(milliseconds: 100), () => _openVideo(context, video, watchs));
        }
      },
      splashColor: Theme.of(context).splashColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (contain) ?
          Hero(
            tag: video.vid,
            child: CachedNetworkImage(
              imageUrl: video.data.pictures.sizes[3].link,
              fit: BoxFit.fitWidth,
              placeholder: (context, i) => Container(
                height: MediaQuery.of(context).size.width * 0.5625,
              ),
            ),
          ) :
          Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: video.data.pictures.sizes[3].link,
                fit: BoxFit.fitWidth,
                placeholder: (context, i) => Container(
                  height: MediaQuery.of(context).size.width * 0.5625,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.5625,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Icon(Icons.lock, color: Colors.white,),
                ),
              )
            ],
          ),
          ListTile(
            leading: ImageUtil.showCircularImage(
                18, video.data.user.pictures.sizes[2].link),
            title: Text(video.data.name, style: Theme.of(context).textTheme.display2),
            subtitle: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.display3.copyWith(color: Colors.black54),
                children: [
                  TextSpan(text: '${video.data.user.name} . '),
                  TextSpan(text: '${now.difference(video.date).inDays < 8 ? timeago.format(video.date) : DateTimeUtil.displayDate(video.date)}'),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _checkDependancy(Video video, List<Watch> watchs) {
    bool contain = false;
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

  _openVideo(BuildContext context, Video video, List<Watch> watchs){
    Provider.of<VideoState>(context, listen: false).selectedVideo = video;
    Provider.of<VideoState>(context, listen: false).selectedVideoId = video.vid;

    if(watchs == null || watchs.length == 0) {
      Provider.of<VideoState>(context, listen: false).selectedWatch = null;
    } else {
      List<Watch> getWatch = watchs.where((w) => w.vid == video.vid).toList();
      if(getWatch != null && getWatch.length > 0) {
        Provider.of<VideoState>(context, listen: false).selectedWatch = getWatch.first;
      }
    }
    AppRouter.navigator.pushNamed(AppRouter.videoPlayerPage);
  }
}
