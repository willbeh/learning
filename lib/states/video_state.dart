import 'package:flutter/material.dart';
import 'package:learning/models/series.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';

class VideoState with ChangeNotifier {
  Video selectedVideo;
  String selectedVideoId;
  Watch selectedWatch;
  Series selectedSeries;
}
