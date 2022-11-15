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
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  nextSong(int songindex) {
    if (_currentSongIndex == _audioList.length - 1) {
      _currentSongIndex = 0;
    } else {
      _currentSongIndex = songindex + 1;
    }
    _position = Duration.zero;
    _duration = Duration.zero;
    playAudio();
    notifyListeners();
  }

  playAudio() async {
    await advancedPlayer.play(
      UrlSource(_audioList[_currentSongIndex].data),
    );
    _isPLaying = true;
    await playerdurationchanged();
    await playerPositionchanged();
    notifyListeners();
  }

  void seekslider(int second) async {
    Duration newDuration = Duration(seconds: second);
    await advancedPlayer.seek(newDuration);
    _position = newDuration;
    notifyListeners();
  }

  Duration _duration = const Duration();
  Duration get duration => _duration;
  set duration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  Duration _position = const Duration();
  Duration get position => _position;
  set position(Duration duration) {
    _position = duration;
    notifyListeners();
  }

  playerdurationchanged() {
    advancedPlayer.onDurationChanged.listen((event) {
      _duration = event;
      notifyListeners();
    });
  }

  playerPositionchanged() {
    advancedPlayer.onPositionChanged.listen((event) {
      _position = event;
      notifyListeners();
    });
  }
}
