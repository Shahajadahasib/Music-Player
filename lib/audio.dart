import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/provider.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Audio extends StatefulWidget {
  // final SongModel song;
  // final AudioPlayer advancedPlayer;
  // final VoidCallback ontap;
  const Audio({
    Key? key,
    // required this.advancedPlayer,
    // required this.song,
    // required this.ontap,
  }) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool isPlaying = false;
  bool isPaused = false;
  bool isRepeat = false;
  Color color = Colors.black;
  bool isSourceSet = false;

  Future<void> setSource(Source source) async {
    setState(() => isSourceSet = false);
    await context.read<AudioProvider>().advancedPlayer.setSource(source);
    setState(() => isSourceSet = true);
  }

  @override
  void initState() {
    super.initState();

    context.read<AudioProvider>().advancedPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    context.read<AudioProvider>().advancedPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    context
        .read<AudioProvider>()
        .advancedPlayer
        .onPlayerComplete
        .listen((event) {
      setState(() {
        _position = const Duration(seconds: 0);
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

  @override
  void dispose() {
    context.read<AudioProvider>().advancedPlayer.dispose();
    context.read<AudioProvider>().advancedPlayer.release();
    super.dispose();
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    context.read<AudioProvider>().advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    // context.read<AudioProvider>().playAudio(advancedPlayer);
    var song = context
        .watch<AudioProvider>()
        .audioList[context.watch<AudioProvider>().currentSongIndex];
    SongModel songurl = song;
    // final songdata = song.data;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFfdee7fa),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight / 3,
            child: Container(
              color: const Color(0xFF04abe7),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.2,
            left: 0,
            right: 0,
            height: screenHeight * 0.40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Text(
                    songurl.title,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Avenir'),
                  ),
                  Text(
                    songurl.artist!,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Avenir'),
                  ),
                  Column(
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
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              _duration.toString().split(".")[0],
                              style: const TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      slider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (isRepeat == false) {
                                context
                                    .read<AudioProvider>()
                                    .advancedPlayer
                                    .setReleaseMode(ReleaseMode.loop);
                                setState(() {
                                  isRepeat = true;
                                  color = Colors.blue;
                                });
                              } else if (isRepeat == true) {
                                context
                                    .read<AudioProvider>()
                                    .advancedPlayer
                                    .setReleaseMode(ReleaseMode.release);
                                color = Colors.blue;
                                isRepeat = false;
                              }
                            },
                            icon: const Icon(
                              Icons.repeat_one,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<AudioProvider>()
                                  .advancedPlayer
                                  .setPlaybackRate(1);
                            },
                            icon: const Icon(
                              Icons.slow_motion_video_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isPlaying == false) {
                                log(songurl.data);
                                context.read<AudioProvider>().playAudio();
                                // await advancedPlayer.play(UrlSource(songdata));
                                setState(
                                  () {
                                    isPlaying = true;
                                  },
                                );
                              } else if (isPlaying == true) {
                                context
                                    .read<AudioProvider>()
                                    .advancedPlayer
                                    .pause();
                                setState(
                                  () {
                                    isPlaying = false;
                                  },
                                );
                              }
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // widget.advancedPlayer.audioCache;
                              context.read<AudioProvider>().changeSong(context
                                  .read<AudioProvider>()
                                  .currentSongIndex);
                              // widget.advancedPlayer.play(
                              //   UrlSource(),
                              // );
                            },
                            icon: const Icon(
                              Icons.forward_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.loop_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.12,
            left: (screenWidth - 150) / 2,
            right: (screenWidth - 150) / 2,
            height: screenHeight * 0.16,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFf2f2f2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    image: const DecorationImage(
                        image: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShyQTVUKweEjyekXS8dOcHmXOtmqOFBEPUKQ&usqp=CAU',
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
