import 'package:flutter/material.dart';
import 'package:learning/models/series.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';

class VideoState with ChangeNotifier {
  Video selectedVideo;
  Watch selectedWatch;
  SeriesWatch selectedSeriesWatch;
  Series _selectedSeries;

  Series get selectedSeries => _selectedSeries;

  set selectedSeries(Series value) {
    _selectedSeries = value;
    notifyListeners();
  }

  selectVideo(Video video, Watch watch){
    selectedVideo = video;
    selectedWatch = watch;
    notifyListeners();
  }
}
