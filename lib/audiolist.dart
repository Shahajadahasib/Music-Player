import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'audio.dart';

class AudioList extends StatelessWidget {
  const AudioList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<AudioProvider>().fetchAudioList;
    return SafeArea(
      child: Consumer<AudioProvider>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: const Color.fromARGB(255, 155, 237, 240),
          body: value.audioList.isNotEmpty // must read
              ? Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      child: Container(
                        height: 64,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/logo.png'))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.audioList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              value.currentSongIndex = index;
                              showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) => const Audio(),
                              );
                            },
                            child: ListTile(
                              title: Text(
                                value.audioList[index].title.length > 20
                                    ? value.audioList[index].title
                                        .substring(0, 20)
                                    : value.audioList[index].displayNameWOExt,
                              ),
                              subtitle: Text(
                                  value.audioList[index].artist ?? "No Artist"),
                              trailing: const Icon(Icons.arrow_forward_rounded),
                              leading: QueryArtworkWidget(
                                id: value.audioList[index].id,
                                type: ArtworkType.AUDIO,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    value.isPlaying
                        // ? _buildPlayingCard(context: context, size: size / .9)
                        ? Text('data')
                        : const SizedBox(),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Loading',
                  ),
                ),
        ),
      ),
    );
  }

  _buildPlayingCard({
    required BuildContext context,
    required Size size,
  }) {
    return Consumer<AudioProvider>(
      builder: (context, value, child) => GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => const Audio(),
          );
        },
        onTap: () => showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => const Audio(),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(
            horizontal: 2,
          ),
          height: size.height / 14,
          width: size.width,
          decoration: const BoxDecoration(
            color: Color(0xFF04abe7),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.skip_previous,
                    size: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (value.isPlaying) {
                        await value.advancedPlayer.pause();

                        value.isPlaying = false;
                      } else {
                        // log(songurl.data);
                        await value.playAudio();
                        value.isPlaying = true;
                      }
                    },
                    child: Icon(
                      value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      value.nextSong(value.currentSongIndex);
                    },
                    child: const Icon(
                      Icons.skip_next,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.audioList[value.currentSongIndex].title.length >
                                20
                            ? value.audioList[value.currentSongIndex].title
                                .substring(0, 20)
                            : value.audioList[value.currentSongIndex].title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        value.audioList[value.currentSongIndex].artist
                                    .toString()
                                    .length >
                                15
                            ? value.audioList[value.currentSongIndex].artist
                                .toString()
                                .substring(0, 15)
                            : value.audioList[value.currentSongIndex].artist
                                .toString(),
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.favorite)
            ],
          ),
        ),
      ),
    );
  }
}
