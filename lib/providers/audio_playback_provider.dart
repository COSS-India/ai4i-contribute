import 'package:flutter/material.dart';

class AudioPlaybackProvider extends ChangeNotifier {
  static final AudioPlaybackProvider _instance = AudioPlaybackProvider._internal();
  factory AudioPlaybackProvider() => _instance;
  AudioPlaybackProvider._internal();

  double _playbackSpeed = 1.0;

  double get playbackSpeed => _playbackSpeed;

  void setPlaybackSpeed(double speed) {
    _playbackSpeed = speed;
    notifyListeners();
  }
}