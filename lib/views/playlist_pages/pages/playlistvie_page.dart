// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tunin_2/views/playlist_pages/common_playlist/checkPlaylist.dart';
import '../../../db_functions/model/audio_player.dart';
import '../../../utils/consts/colors.dart';

class PlaylistViewPage extends StatelessWidget {
  PlaylistViewPage({Key? key, required this.playlist}) : super(key: key);

  final AudioPlayer playlist;
  final audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add songs'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<SongModel>>(
          future: audioQuery.querySongs(
            sortType: SongSortType.TITLE,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Songs Found',
                ),
              );
            }
            return Consumer<CheckPlaylist>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: ((ctx, index) {
                      return ListTile(
                        tileColor: ColorsinUse().tilecolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: const Icon(
                          Icons.music_note_rounded,
                          color: Color.fromARGB(137, 255, 255, 255),
                          size: 35,
                        ),
                        title: Text(
                          item.data![index].displayNameWOExt,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '${item.data![index].artist}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                            onPressed: (() {
                              provider.checkPlaylist(
                                  item.data![index], playlist);

                              Provider.of<CheckPlaylist>(context, listen: false)
                                  .notifyListeners();
                            }),
                            icon: !playlist.isValueIn(item.data![index].id)
                                ? const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.remove,
                                    color: ColorsinUse().white,
                                  )),
                      );
                    }),
                    itemCount: item.data!.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
