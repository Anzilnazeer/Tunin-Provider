import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/views/home_page/now_playing/now_playing_page.dart';

class ShowMiniPlayer extends ChangeNotifier {
  List<SongModel> miniPlayerNotifier = [];

  updateMiniPlayer({required List<SongModel> songlist}) {
    miniPlayerNotifier.clear();
    miniPlayerNotifier.addAll(songlist);
    notifyListeners();
  }
}
