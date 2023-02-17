import 'package:flutter/material.dart';
import 'package:tunin_2/db_functions/db_function/db_playlist.dart';
import 'package:tunin_2/utils/consts/colors.dart';

resetApp(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(226, 69, 69, 69),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: const Text('Do you really want to reset TUNIN ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'No',
              style: TextStyle(color: ColorsinUse().white),
            ),
          ),
          TextButton(
            onPressed: () {
              PlaylistDb().appReset(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Reset',
              style: TextStyle(color: ColorsinUse().red),
            ),
          ),
        ],
      );
    },
  );
}
