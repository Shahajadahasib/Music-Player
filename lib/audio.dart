import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class Audio extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  const Audio({Key? key, required this.advancedPlayer}) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  final String path =
      "https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand60.wav";
  bool isPlaying = false;
  bool isPaused = false;
  bool isRepeat = false;
  Color color = Colors.black;
  final List<IconData> _icons = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

  @override
  void initState() {
    super.initState();
    this.widget.advancedPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    this.widget.advancedPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    this.widget.advancedPlayer.setUrl(path);
    this.widget.advancedPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
        if (isRepeat == true) {
          isPlaying = true;
        } else {
          isPlaying = false;
          isRepeat = false;
        }
      });
    });
  }

  Widget slider() {
    return Slider(
        value: _position.inSeconds.toDouble(),
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        });
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    this.widget.advancedPlayer.seek(newDuration);
  }

  Widget btnStart() {
    return IconButton(
      icon: isPlaying == false
          ? Icon(
              _icons[0],
              size: 50,
              color: Colors.blue,
            )
          : Icon(
              _icons[1],
              size: 50,
              color: Colors.blue,
            ),
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      onPressed: () {
        if (isPlaying == false) {
          this.widget.advancedPlayer.play(path);
          setState(
            () {
              isPlaying = true;
            },
          );
        } else if (isPlaying == true) {
          this.widget.advancedPlayer.pause();
          setState(
            () {
              isPlaying = false;
            },
          );
        }
      },
    );
  }

  Widget btnLoop() {
    return IconButton(
      icon: const ImageIcon(
        AssetImage(
            '/Users/mdhasib/Desktop/Project/Music/music/lib/PikPng.com_repeat-icon-png_5001999.png'),
        size: 20,
        color: Colors.black,
      ),
      onPressed: () {},
    );
  }

  Widget btnRepeat() {
    return IconButton(
      icon: const ImageIcon(
        AssetImage(
            '/Users/mdhasib/Desktop/Project/Music/music/lib/PikPng.com_eat-icon-png_4732513.png'),
        size: 20,
        color: Colors.black,
      ),
      onPressed: () {
        if (isRepeat == false) {
          this.widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP);
          setState(() {
            isRepeat = true;
            color = Colors.blue;
          });
        } else if (isRepeat == true) {
          this.widget.advancedPlayer.setReleaseMode(ReleaseMode.RELEASE);
          color = Colors.blue;
          isRepeat = false;
        }
      },
    );
  }

  Widget loadAsset() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          btnRepeat(),
          btnSlow(),
          btnStart(),
          btnFast(),
          btnLoop(),
        ],
      ),
    );
  }

  Widget btnFast() {
    return IconButton(
      icon: const ImageIcon(
        NetworkImage(
          "http://simpleicon.com/wp-content/uploads/forward.png",
        ),
        size: 20,
        color: Colors.black,
      ),
      onPressed: () {
        widget.advancedPlayer.setPlaybackRate(1.5);
      },
    );
  }

  Widget btnSlow() {
    return IconButton(
      icon: const ImageIcon(
        NetworkImage(
          "http://simpleicon.com/wp-content/uploads/reverse.png",
        ),
        size: 20,
        color: Colors.black,
      ),
      onPressed: () {
        widget.advancedPlayer.setPlaybackRate(1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _position.toString().split(".")[0],
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  _duration.toString().split(".")[0],
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          loadAsset(),
          slider(),
        ],
      ),
    );
  }
}
