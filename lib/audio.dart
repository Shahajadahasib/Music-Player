import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:provider/provider.dart';

class Audio extends StatefulWidget {
  const Audio({
    Key? key,
  }) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  bool isRepeat = false;
  Color color = Colors.black;

  Widget slider() {
    return Slider(
        value: context.watch<AudioProvider>().position.inSeconds.toDouble(),
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        min: 0.0,
        max: context.watch<AudioProvider>().duration.inSeconds.toDouble(),
        onChanged: (double value) {
          context.read<AudioProvider>().seekslider(value.toInt());
        });
  }

  @override
  Widget build(BuildContext context) {
    var songindex = context.watch<AudioProvider>().currentSongIndex;
    var song = context.watch<AudioProvider>().audioList[songindex];

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFfdee7fa),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height / 3,
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
            top: size.height * 0.2,
            left: 0,
            right: 0,
            height: size.height * 0.40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Text(
                    song.title.length > 15
                        ? song.title.substring(0, 15)
                        : song.title.toString(),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Avenir'),
                  ),
                  Text(
                    song.artist.toString().length > 20
                        ? song.artist.toString().substring(0, 20)
                        : song.artist.toString(),
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
                              context
                                  .watch<AudioProvider>()
                                  .position
                                  .toString()
                                  .split(".")[0],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              context
                                  .watch<AudioProvider>()
                                  .duration
                                  .toString()
                                  .split(".")[0],
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
                          // IconButton(
                          //   onPressed: () {
                          //     if (isRepeat == false) {
                          //       context
                          //           .read<AudioProvider>()
                          //           .advancedPlayer
                          //           .setReleaseMode(ReleaseMode.loop);
                          //       setState(() {
                          //         isRepeat = true;
                          //         color = Colors.blue;
                          //       });
                          //     } else if (isRepeat == true) {
                          //       context
                          //           .read<AudioProvider>()
                          //           .advancedPlayer
                          //           .setReleaseMode(ReleaseMode.release);
                          //       color = Colors.blue;
                          //       isRepeat = false;
                          //     }
                          //   },
                          //   icon: const Icon(
                          //     Icons.repeat_one,
                          //   ),
                          // ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<AudioProvider>()
                                  .advancedPlayer
                                  .setPlaybackRate(1);
                            },
                            icon: IconButton(
                              onPressed: () {
                                context.read<AudioProvider>().previousSong(
                                    context
                                        .read<AudioProvider>()
                                        .currentSongIndex);
                              },
                              icon: Icon(
                                Icons.skip_previous_outlined,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (context.read<AudioProvider>().isPlaying) {
                                await context
                                    .read<AudioProvider>()
                                    .advancedPlayer
                                    .pause();

                                context.read<AudioProvider>().isPlaying = false;
                              } else {
                                // log(songurl.data);
                                await context.read<AudioProvider>().playAudio();
                                context.read<AudioProvider>().isPlaying = true;
                              }
                            },
                            icon: Icon(
                              context.watch<AudioProvider>().isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // widget.advancedPlayer.audioCache;
                              context.read<AudioProvider>().nextSong(context
                                  .read<AudioProvider>()
                                  .currentSongIndex);
                              // widget.advancedPlayer.play(
                              //   UrlSource(),
                              // );
                            },
                            icon: const Icon(
                              Icons.skip_next_outlined,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(
                          //     Icons.loop_outlined,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.12,
            left: (size.width - 150) / 2,
            right: (size.width - 150) / 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf2f2f2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amber,
                child: QueryArtworkWidget(
                  id: context
                      .read<AudioProvider>()
                      .audioList[context.read<AudioProvider>().currentSongIndex]
                      .id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: size.width * 0.26,
                  artworkWidth: size.width * 0.26,
                  artworkFit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
