import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer advancedPlayer;
  AudioProvider({
    Key? key,
    required this.advancedPlayer,
    // required this.song,
    // required this.ontap,
  });

  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _audioList = [];
  int _nextSongIndex = 0;

  int get nextSongIndex => _nextSongIndex;
  set nextSongIndex(int index) {
    _nextSongIndex = index;
    log("Next index  = $index");
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

  //  SongModel song =  ;

  changeSong(int songindex) {
    // int heda = _audioList.indexOf(09);
    // nextSongIndex = heda + 1;
    _currentSongIndex = songindex + 1;
    log("Chnage song index  = $_currentSongIndex");
    playAudio();
    notifyListeners();
  }

  playAudio() async {
    await advancedPlayer.play(
      UrlSource(_audioList[_currentSongIndex].data),
    );
  }
}
