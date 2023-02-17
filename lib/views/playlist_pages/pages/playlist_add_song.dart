// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tunin_2/db_functions/db_function/db_playlist.dart';
import 'package:tunin_2/db_functions/model/audio_player.dart';
import 'package:tunin_2/views/playlist_pages/pages/playlistvie_page.dart';
import '../../../utils/consts/colors.dart';
import '../../../common/widgets/get_songs.dart';
import '../../home_page/now_playing/now_playing_page.dart';
import '../../favourite_pages/favourite_button.dart';

class PlaylistAddSongs extends StatelessWidget {
  PlaylistAddSongs(
      {Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final AudioPlayer playlist;
  final int folderindex;

  late List<SongModel> playlistSong;

  @override
  Widget build(BuildContext context) {
    Provider.of<PlaylistDb>(context, listen: false).getAllPlaylist();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 1, 1),
      appBar: AppBar(
        title: Text(playlist.name.toUpperCase()),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlaylistViewPage(playlist: playlist),
                ));
              },
              icon: const Icon(
                Icons.playlist_add,
                size: 30,
              ))
        ],
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Consumer<PlaylistDb>(
          builder: (context, provider, child) {
            playlistSong = provider.listplaylist(
                provider.playdb.values.toList()[folderindex].songId, context);
            return SingleChildScrollView(
              child: Consumer<PlaylistDb>(
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(10),
                                    flex: 1,
                                    onPressed: (context) {
                                      playlist
                                          .deleteData(playlistSong[index].id);
                                      value.notifyListeners();
                                    },
                                    backgroundColor:
                                        const Color.fromARGB(255, 128, 30, 30),
                                    foregroundColor: ColorsinUse().white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ]),
                            child: ListTile(
                              onTap: () async {
                                List<SongModel> newList = [...playlistSong];
                                Provider.of<GetSongs>(context, listen: false)
                                    .audioPlayer
                                    .setAudioSource(
                                        Provider.of<GetSongs>(context,
                                                listen: false)
                                            .createSongList(newList),
                                        initialIndex: index);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ((context) => NowPlaying(
                                          audioPlayerSong: playlistSong,
                                        )),
                                  ),
                                );
                                Provider.of<GetSongs>(context, listen: false)
                                    .audioPlayer
                                    .play();
                              },
                              tileColor: ColorsinUse().tilecolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              leading: const Icon(
                                Icons.music_note_rounded,
                                color: Color.fromARGB(137, 255, 255, 255),
                                size: 35,
                              ),
                              title: Text(
                                playlistSong[index].displayNameWOExt,
                                maxLines: 1,
                                style: TextStyle(color: ColorsinUse().white),
                              ),
                              subtitle: Text(
                                playlistSong[index].artist!,
                                style: TextStyle(color: ColorsinUse().white),
                              ),
                              trailing: FavouriteButton(
                                song: playlistSong[index],
                              ),
                            ));
                      }),
                      itemCount: playlistSong.length,
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
