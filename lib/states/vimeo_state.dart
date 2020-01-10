import 'package:flutter/material.dart';
import 'package:learning/models/video.dart';

class VimeoState with ChangeNotifier {
  Map<String, Vimeo> videos = {};
  Vimeo selectedVideo;
  String selectedVideoId;
}
