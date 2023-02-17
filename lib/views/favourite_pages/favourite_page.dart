import 'dart:io';

import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tunin_2/db_functions/db_function/db_favourite.dart';

import 'package:tunin_2/utils/consts/colors.dart';

import '../../common/widgets/get_songs.dart';
import '../../common/miniplayer/show_mini.dart';

class FavoratePage extends StatelessWidget {
  FavoratePage({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeScrollAppBar(
        scrollController: _scrollController,
        pinned: false,
        elevation: 5,
        fadeOffset: 100,
        expandedHeight: 140,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        fadeWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    "Liked Songs",
                    style: GoogleFonts.aboreto(
                      color: ColorsinUse().white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        child: Consumer<FavouriteDb>(
          builder: (context, value, child) => value.favourList.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Lottie.asset(
                          'assets/lottie/58790-favourite-animation.json',
                          height: 250),
                      Text(
                        'No Favourites',
                        style: TextStyle(
                            color: ColorsinUse().white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : Consumer<FavouriteDb>(
                  builder: (context, favProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemCount: favProvider.favourList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            tileColor: ColorsinUse().tilecolor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onTap: () {
                              favProvider.notifyListeners();
                              List<SongModel> favourlist = [
                                ...favProvider.favourList
                              ];

                              Provider.of<GetSongs>(context, listen: false)
                                  .audioPlayer
                                  .setAudioSource(
                                      Provider.of<GetSongs>(context,
                                              listen: false)
                                          .createSongList(favourlist),
                                      initialIndex: index);

                              Provider.of<GetSongs>(context, listen: false)
                                  .audioPlayer
                                  .play();

                              Provider.of<ShowMiniPlayer>(context,
                                      listen: false)
                                  .updateMiniPlayer(songlist: favourlist);
                            },
                            leading: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(5),
                              id: favProvider.favourList[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note_rounded,
                                color: Color.fromARGB(137, 255, 255, 255),
                                size: 35,
                              ),
                            ),
                            title: Text(
                              favProvider.favourList[index].title,
                              maxLines: 1,
                            ),
                            subtitle:
                                Text(favProvider.favourList[index].artist!),
                            trailing: IconButton(
                              onPressed: () {
                                favProvider.notifyListeners();
                                favProvider
                                    .delete(favProvider.favourList[index].id);
                              },
                              icon: const Icon(
                                Icons.thumb_up_alt_rounded,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
