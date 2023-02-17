import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tunin_2/db_functions/model/audio_player.dart';
import 'package:tunin_2/common/widgets/get_songs.dart';

import '../../splash_screen.dart';

import 'db_favourite.dart';

class PlaylistDb extends ChangeNotifier {
  // static ValueNotifier<List<AudioPlayer>> playlistNotifier = ValueNotifier([]);
  List<AudioPlayer> playList = [];
  Box<AudioPlayer> playdb = Hive.box<AudioPlayer>("playlistDB");
  Future<void> playlistAdd(AudioPlayer value) async {
    // final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    await playdb.add(value);

    playList.add(value);
    notifyListeners();
  }

  getAllPlaylist() async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    playList.clear();
    playList.addAll(playlistdb.values);
  }

  playlistDelete(int index) async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    await playlistdb.deleteAt(index);
    getAllPlaylist();
  }



  List<SongModel> listplaylist(List<int> data, BuildContext context) {
    List<SongModel> playsongs = [];
    for (int i = 0;
        i < Provider.of<GetSongs>(context, listen: false).songscopy.length;
        i++) {
      for (int j = 0; j < data.length; j++) {
        if (Provider.of<GetSongs>(context, listen: false).songscopy[i].id ==
            data[j]) {
          playsongs
              .add(Provider.of<GetSongs>(context, listen: false).songscopy[i]);
        }
      }
    }
    return playsongs;
  }

  Future<void> appReset(context) async {
    final playlistDb = Hive.box<AudioPlayer>('playlistDB');
    final musicDb = Hive.box<int>('favouriteDB');
    await musicDb.clear();
    await playlistDb.clear();
    FavouriteDb().favourList.clear();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (Route<dynamic> route) => false);
  }
}
