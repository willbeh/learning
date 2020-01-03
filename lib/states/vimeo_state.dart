import 'package:flutter/material.dart';
import 'package:learning/models/vimeo.dart';

class VimeoState with ChangeNotifier {
  Map<String, Vimeo> videos = {};
  Vimeo selectedVideo;
  String selectedVideoId;
}
