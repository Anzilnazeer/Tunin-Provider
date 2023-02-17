// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../db_functions/db_function/db_favourite.dart';
import '../../utils/consts/colors.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({required this.song, super.key});
  final SongModel song;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (() {
        if (Provider.of<FavouriteDb>(context, listen: false)
            .favourCheck(song)) {
          Provider.of<FavouriteDb>(context, listen: false).delete(song.id);
          Provider.of<FavouriteDb>(context, listen: false).notifyListeners();

          final snackBar = SnackBar(
              backgroundColor: const Color.fromARGB(126, 0, 0, 0),
              duration: const Duration(milliseconds: 800),
              behavior: SnackBarBehavior.floating,
              width: 100,
              content: Text(
                'Disliked',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsinUse().white,
                ),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          Provider.of<FavouriteDb>(context, listen: false).add(song);
          Provider.of<FavouriteDb>(context, listen: false).notifyListeners();

          final snackBar = SnackBar(
              backgroundColor: const Color.fromARGB(126, 0, 0, 0),
              duration: const Duration(milliseconds: 800),
              behavior: SnackBarBehavior.floating,
              width: 100,
              content: Text(
                'Liked',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsinUse().white,
                ),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        Provider.of<FavouriteDb>(context, listen: false).notifyListeners();
      }),
      icon: Provider.of<FavouriteDb>(context).favourCheck(song)
          ? Icon(
              Icons.thumb_up_alt_rounded,
              color: ColorsinUse().white,
              size: 20,
            )
          : const Icon(
              Icons.thumb_up_off_alt_outlined,
              color: Color.fromARGB(122, 175, 175, 175),
              size: 20,
            ),
    );
  }
}
