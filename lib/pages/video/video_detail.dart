import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/image_util.dart';
import 'package:provider/provider.dart';

class VideoDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Vimeo vimeo = Provider.of<VimeoState>(context).selectedVideo;
    return Column(
      children: <Widget>[
        ListTile(
          leading: ImageUtil.showCircularImage(
              25, vimeo.user.pictures.sizes[2].link),
          title: Text(vimeo.name, style: ThemeData.dark().textTheme.display1),
          subtitle: Text(
            vimeo.user.name,
            style: ThemeData.dark().textTheme.display3,
          ),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.thumb_up),
              Text('123')
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(vimeo.description),
        )
      ],
    );
  }
}
