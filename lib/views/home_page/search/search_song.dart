import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tunin_2/common/widgets/get_songs.dart';
import 'package:tunin_2/views/favourite_pages/favourite_button.dart';
import 'package:tunin_2/views/home_page/listing/songs_list.dart';

import '../../../utils/consts/colors.dart';
import '../now_playing/now_playing_page.dart';

class Serach extends StatefulWidget {
  const Serach({super.key});

  @override
  State<Serach> createState() => _SerachState();
}

class _SerachState extends State<Serach> {
  List<SongModel> findSongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Row(
        children: [
          IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Text(
            'Search songs'.toUpperCase(),
            style: const TextStyle(
              color: Color.fromARGB(220, 255, 255, 255),
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          cursorColor: ColorsinUse().red,
          autofocus: true,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) => runFilter(value),
          decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromARGB(13, 255, 255, 255),
              suffixIcon: Icon(
                Icons.search,
                color: ColorsinUse().red,
              ),
              hintText: 'search songs here..',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(148, 255, 255, 255))),
        ),
      ),
      SingleChildScrollView(
          child: findSongs.isEmpty
              ? const Center(
                  child: Text(
                    'Find Songs',
                    style: TextStyle(
                      color: Color.fromARGB(98, 255, 255, 255),
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: ColorsinUse().tilecolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        leading: const Icon(
                          Icons.music_note_rounded,
                          color: Color.fromARGB(137, 255, 255, 255),
                          size: 35,
                        ),
                        title: Text(
                          findSongs[index].displayNameWOExt,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          findSongs[index].artist!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: FavouriteButton(song: findSongs[index]),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Provider.of<GetSongs>(context, listen: false)
                              .audioPlayer
                              .setAudioSource(
                                  Provider.of<GetSongs>(context, listen: false)
                                      .createSongList(findSongs),
                                  initialIndex: index);
                          Provider.of<GetSongs>(context, listen: false)
                              .audioPlayer
                              .play();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => NowPlaying(
                                    audioPlayerSong: findSongs,
                                  )),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  itemCount: findSongs.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ))
    ]));
  }

  void runFilter(String keyword) {
    List<SongModel> results = [];
    if (keyword.isEmpty) {
      results = SongsList.song;
    } else {
      results = SongsList.song
          .where((SongModel item) => item.displayNameWOExt
              .toLowerCase()
              .contains(keyword.toLowerCase().trim()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      findSongs = results;
    });
  }
}
