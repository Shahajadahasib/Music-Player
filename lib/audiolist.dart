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
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 155, 237, 240),
        body: context.read<AudioProvider>().audioList.isNotEmpty // must read
            ? Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: Container(
                      height: 64,
                      // width: 200,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: context.read<AudioProvider>().audioList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.read<AudioProvider>().currentSongIndex =
                                index;
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => const Audio(),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              context
                                          .read<AudioProvider>()
                                          .audioList[index]
                                          .title
                                          .length >
                                      20
                                  ? context
                                      .read<AudioProvider>()
                                      .audioList[index]
                                      .title
                                      .substring(0, 20)
                                  : context
                                      .read<AudioProvider>()
                                      .audioList[index]
                                      .displayNameWOExt,
                            ),
                            subtitle: Text(context
                                    .read<AudioProvider>()
                                    .audioList[index]
                                    .artist ??
                                "No Artist"),
                            trailing: const Icon(Icons.arrow_forward_rounded),
                            // This Widget will query/load image. Just add the id and type.
                            // You can use/create your own widget/method using [queryArtwork].
                            leading: QueryArtworkWidget(
                              id: context
                                  .read<AudioProvider>()
                                  .audioList[index]
                                  .id,
                              type: ArtworkType.AUDIO,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  context.watch<AudioProvider>().isPlaying
                      ? _buildPlayingCard(context: context, size: size / .9)
                      // Container(
                      //     color: Colors.red,
                      //     height: 50,
                      //     child: Text(context
                      //         .read<AudioProvider>()
                      //         .audioList[
                      //             context.read<AudioProvider>().currentSongIndex]
                      //         .title),
                      //   )
                      : const SizedBox(),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Loading',
                ),
              ),
      ),
    );
  }
}

_buildPlayingCard({
  required BuildContext context,
  required Size size,
}) {
  return GestureDetector(
    onVerticalDragUpdate: (DragUpdateDetails details) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const Audio(),
      //   ),
      // );
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
                  if (context.read<AudioProvider>().isPlaying) {
                    await context.read<AudioProvider>().advancedPlayer.pause();

                    context.read<AudioProvider>().isPlaying = false;
                  } else {
                    // log(songurl.data);
                    await context.read<AudioProvider>().playAudio();
                    context.read<AudioProvider>().isPlaying = true;
                  }
                },
                child: Icon(
                  context.read<AudioProvider>().isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context
                      .read<AudioProvider>()
                      .nextSong(context.read<AudioProvider>().currentSongIndex);
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
                    context
                                .read<AudioProvider>()
                                .audioList[context
                                    .read<AudioProvider>()
                                    .currentSongIndex]
                                .title
                                .length >
                            20
                        ? context
                            .read<AudioProvider>()
                            .audioList[
                                context.read<AudioProvider>().currentSongIndex]
                            .title
                            .substring(0, 20)
                        : context
                            .read<AudioProvider>()
                            .audioList[
                                context.read<AudioProvider>().currentSongIndex]
                            .title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    context
                                .read<AudioProvider>()
                                .audioList[context
                                    .read<AudioProvider>()
                                    .currentSongIndex]
                                .artist
                                .toString()
                                .length >
                            15
                        ? context
                            .read<AudioProvider>()
                            .audioList[
                                context.watch<AudioProvider>().currentSongIndex]
                            .artist
                            .toString()
                            .substring(0, 15)
                        : context
                            .read<AudioProvider>()
                            .audioList[
                                context.read<AudioProvider>().currentSongIndex]
                            .artist
                            .toString(),
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.favorite)
        ],
      ),
    ),
  );
}
