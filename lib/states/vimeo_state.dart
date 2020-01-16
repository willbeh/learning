import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';

class VimeoState with ChangeNotifier {
  Map<String, Vimeo> videos = {};
  Vimeo selectedVideo;
  String selectedVideoId;
  Watch selectedWatch;
}
