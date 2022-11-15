import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer advancedPlayer;
  AudioProvider({
    Key? key,
    required this.advancedPlayer,
  });

  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _audioList = [];
  bool _isPLaying = false;
  bool get isPlaying => _isPLaying;
  set isPlaying(bool value) {
    _isPLaying = value;
    notifyListeners();
  }

  int _currentSongIndex = 0;

  int get currentSongIndex => _currentSongIndex;
  set currentSongIndex(int index) {
    _currentSongIndex = index;
    log("Current index  = $index");
    playAudio();
    notifyListeners();
  }

  List<SongModel> get audioList => _audioList;

  void get fetchAudioList async {
    try {
      _audioList = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      log('message');
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  changeSong(int songindex) {
    if (_currentSongIndex == _audioList.length - 1) {
      _currentSongIndex = 0;
      log("Chnage song index  = $_currentSongIndex");
      log('No songs left');
    } else {
      _currentSongIndex = songindex + 1;
      log("Chnage song index  = $songindex");
      log("Current song index  = $_currentSongIndex");
      log("_audioList.length = ${_audioList.length}");
    }

    playAudio();
    notifyListeners();
  }

  playAudio() async {
    await advancedPlayer.play(
      UrlSource(_audioList[_currentSongIndex].data),
    );
    _isPLaying = true;
  }
}
