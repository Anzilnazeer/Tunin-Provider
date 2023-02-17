// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:tunin_2/db_functions/db_function/db_playlist.dart';
import 'package:tunin_2/db_functions/model/audio_player.dart';
import 'package:tunin_2/views/playlist_pages/pages/playlist_add_song.dart';
import 'package:tunin_2/views/playlist_pages/common_playlist/dialog_list.dart';
import 'package:tunin_2/views/settings_pages/settings_option.dart';

import '../../../utils/consts/colors.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

TextEditingController newPlaylistController = TextEditingController();

class _PlayListPageState extends State<PlayListPage> {
  late final AudioPlayer playlist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Playlists',
            style: GoogleFonts.aboreto(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          OptionWidget(
            infoText: 'Add playlist',
            infoIcon: Icons.playlist_add,
            infoAction: () {
              DialogList.addPlaylistDialog(context);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          // Hive.box<AudioPlayer>('playlistDB').isEmpty
          Consumer<PlaylistDb>(
            builder: (context, value, child) => value.playdb.isEmpty
                ? const Center(
                    child: Text(
                      'No playlists added',
                      style: TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
                    ),
                  )
                : SingleChildScrollView(child: Consumer<PlaylistDb>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: value.playdb.length,
                          itemBuilder: ((context, index) {
                            final data = value.playdb.values.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                tileColor: ColorsinUse().tilecolor,
                                leading: const Icon(
                                  Icons.folder,
                                  size: 40,
                                  color: Color.fromARGB(255, 240, 240, 240),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 228, 228, 228),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    206, 69, 69, 69),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            title: const Text(
                                              'Delete Playlist',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 15),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this playlist?',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 227, 66, 66),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  value.playlistDelete(index);
                                                  value.notifyListeners();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return PlaylistAddSongs(
                                        playlist: data,
                                        folderindex: index,
                                      );
                                    },
                                  ));
                                },
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  )),
          )
        ]),
      ),
    );
  }
}
