import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/db_functions/model/audio_player.dart';

import '../../../utils/consts/colors.dart';

class CheckPlaylist extends ChangeNotifier {
  void checkPlaylist(SongModel data, AudioPlayer playlist) {
    if (!playlist.isValueIn(data.id)) {
      playlist.add(data.id);
      // final snackbar = SnackBar(
      //     backgroundColor: const Color.fromARGB(126, 0, 0, 0),
      //     duration: const Duration(milliseconds: 800),
      //     behavior: SnackBarBehavior.floating,
      //     width: 200,
      //     content: Text(
      //       'Added to Playlist',
      //       style: TextStyle(
      //         color: ColorsinUse().white,
      //       ),
      //     ));
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      playlist.deleteData(data.id);
      // final snackbar = SnackBar(
      //   backgroundColor: const Color.fromARGB(126, 0, 0, 0),
      //   content: Text(
      //     'Song Deleted',
      //     style: TextStyle(
      //       color: ColorsinUse().white,
      //     ),
      //   ),
      //   duration: const Duration(milliseconds: 800),
      //   behavior: SnackBarBehavior.floating,
      //   width: 200,
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
