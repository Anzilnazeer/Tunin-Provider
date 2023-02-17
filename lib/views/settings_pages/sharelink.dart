import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Widget shareLink(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 10), () {
        return Share.share(
            'https://play.google.com/store/apps/details?id=com.anzilnazeer.tunin_2');
      }),
      builder: (context, AsyncSnapshot snapshot) => snapshot.data,
    ),
  );
}
