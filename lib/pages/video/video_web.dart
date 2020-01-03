import 'package:flutter/material.dart';
import 'package:learning/utils/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoWebPage extends StatelessWidget {
  final log = getLogger('VideoWebPage');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildVideo(context),
              _buildListTile(context),
              _buildListTile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideo(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.width * 0.5625),
      child: WebView(
        initialUrl: 'https://player.vimeo.com/video/382117382?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=162814',
//              initialUrl: 'https://flutter.dev',
        debuggingEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          log.d('Page started loading: $url');
        },
        onPageFinished: (String url) {
          log.d('Page finished loading: $url');
        },
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      leading: Container(
        color: Colors.red.shade50,
        height: 50,
        width: 50,
      ),
      title: Text('Lorum Ipsum'),
    );
  }
}
