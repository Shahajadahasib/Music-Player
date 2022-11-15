import 'package:flutter/material.dart';
import 'package:music/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'audio.dart';
import 'permissio.dart';

class AudioList extends StatelessWidget {
  const AudioList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AudioProvider>().fetchAudioList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        elevation: 2,
      ),
      body: PermissionSettings.isPermit
          ? RefreshIndicator(
              onRefresh: () async {
                context.read<AudioProvider>().fetchAudioList;
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: context.read<AudioProvider>().audioList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            context.read<AudioProvider>().currentSongIndex =
                                index;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Audio(),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(context
                                .watch<AudioProvider>()
                                .audioList[index]
                                .title),
                            subtitle: Text(context
                                    .watch<AudioProvider>()
                                    .audioList[index]
                                    .artist ??
                                "No Artist"),
                            trailing: const Icon(Icons.arrow_forward_rounded),
                            // This Widget will query/load image. Just add the id and type.
                            // You can use/create your own widget/method using [queryArtwork].
                            leading: QueryArtworkWidget(
                              id: context
                                  .watch<AudioProvider>()
                                  .audioList[index]
                                  .id,
                              type: ArtworkType.AUDIO,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // context.read<AudioProvider>().isPlaying
                  //     ? Container(
                  //         color: Colors.red,
                  //         height: 50,
                  //         child: Text(context
                  //             .read<AudioProvider>()
                  //             .audioList[context
                  //                 .watch<AudioProvider>()
                  //                 .currentSongIndex]
                  //             .title),
                  //       )
                  //     : SizedBox()
                ],
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
