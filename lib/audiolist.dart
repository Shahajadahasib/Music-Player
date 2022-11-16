import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'audio.dart';
import 'permissio.dart';

class AudioList extends StatelessWidget {
  const AudioList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<AudioProvider>().fetchAudioList;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Music Player"),
          elevation: 2,
        ),
        body: context.read<AudioProvider>().audioList.isNotEmpty // must read
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: context.read<AudioProvider>().audioList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // context.read<AudioProvider>().currentSongIndex =
                            //     index;
                            // showCupertinoModalBottomSheet(
                            //   context: context,
                            //   builder: (context) => const Audio(),
                            // );
                          },
                          child: ListTile(
                            title: Text(context
                                .read<AudioProvider>()
                                .audioList[index]
                                .title),
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
                  // !context.watch<AudioProvider>().isPlaying
                  //     ? _buildPlayingCard(
                  //         context: context,
                  //         size: size,
                  //       )
                  //     : const SizedBox(),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Loading',
                ),
              ));
  }
}
