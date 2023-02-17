import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:on_audio_query/on_audio_query.dart';

// ValueNotifier<List<SongModel>> musiclistNotifier = ValueNotifier([]);

class FavouriteDb extends ChangeNotifier {
  bool isfavourite = false;
  final musicDb = Hive.box<int>('favouriteDB');
  // static ValueNotifier<List<SongModel>> favouriteSongs = ValueNotifier([]);
  List<SongModel> favourList = [];
  

  isFavourite(List<SongModel> songs) async {
    for (SongModel song in songs) {
      if (favourCheck(song)) {
        favourList.add(song);
      }
    }
    isfavourite = true;
  }

  bool favourCheck(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }

    return false;
  }

  add(SongModel song) async {
    musicDb.add(song.id);
    favourList.add(song);

    // FavouriteDb.favouriteSongs.notifyListeners();
    notifyListeners();
  }

  delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favourMap = musicDb.toMap();
    favourMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    favourList.removeWhere((song) => song.id == id);
    notifyListeners();
  }
}
