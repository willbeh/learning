import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learning/app_routes.dart';
import 'package:learning/models/vimeo.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/image_util.dart';
import 'package:learning/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoPage extends StatelessWidget {
//  final List<String> videoId = ['379049079', '379879805', '378753132'];
  final List<String> videoId = ['382521859', '382353755', '382117382', '382248454'];
  final log = getLogger('VideoPage');

  final Map<String, String> headers = {
    'Accept': 'application/vnd.vimeo.*+json;version=3.4',
//    'Authorization': 'Bearer db9504925660ccc4e741b2ba339658fa',
    'Authorization': 'Bearer 1e75ca442f1666bf534893e2cd923f83',

  };

  @override
  Widget build(BuildContext context) {
    VimeoState vimeoState = Provider.of(context);

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Video'),
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (int result) {
                if(result == 0) {
                  SharedPreferences prefs = Provider.of<SharedPreferences>(context, listen: false);
                  videoId.forEach((id) {
                    prefs.setInt(id, 0);
                  });
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
        body: ListView.separated(
          itemCount: videoId.length,
          separatorBuilder: (context, i) => Divider(),
          itemBuilder: (context, i) {
            if (vimeoState.videos.containsKey(videoId[i])) {
              return _buildVideoContainer(
                  context, vimeoState.videos[videoId[i]], videoId[i]);
            }

            return FutureBuilder(
              future: http.get('https://api.vimeo.com/videos/${videoId[i]}',
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
                      height: (MediaQuery.of(context).size.width * 0.5625) + 80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    break;

                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      if (snapshot.data.statusCode == 200) {
                        Vimeo vimeo = Vimeo.fromJson(json.decode(snapshot.data.body));
                        vimeoState.videos[videoId[i]] = vimeo;
                        return _buildVideoContainer(context, vimeo, videoId[i]);
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
        ),
      ),
    );
  }

  Widget _buildVideoContainer(BuildContext context, Vimeo vimeo, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            Provider.of<VimeoState>(context, listen: false).selectedVideo = vimeo;
            Provider.of<VimeoState>(context, listen: false).selectedVideoId = id;
            Navigator.of(context).pushNamed(AppRoutes.routeVideoPlayer);
          },
          child: CachedNetworkImage(
            imageUrl: vimeo.pictures.sizes[3].link,
            fit: BoxFit.fitWidth,
            placeholder: (context, i) => Container(
              height: MediaQuery.of(context).size.width * 0.5625,
            ),
          ),
        ),
        ListTile(
          leading: ImageUtil.showCircularImage(
              25, vimeo.user.pictures.sizes[2].link),
          title: Text(vimeo.name, style: ThemeData.dark().textTheme.display1),
          subtitle: Text(
            vimeo.user.name,
            style: ThemeData.dark().textTheme.display3,
          ),
        )
      ],
    );
  }
}
