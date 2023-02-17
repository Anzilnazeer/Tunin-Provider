import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tunin_2/views/home_page/search/search_song.dart';

import 'package:tunin_2/views/home_page/listing/songs_list.dart';

import '../../../utils/consts/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FadeScrollAppBar(
        appBarTitle: Text(
          'TUNIN',
          style: GoogleFonts.monda(color: Colors.white),
        ),
        appBarActions: [
          IconButton(
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Serach()));
                });
              },
              icon: Icon(Icons.search, color: ColorsinUse().white))
        ],
        scrollController: _scrollController,
        pinned: true,
        fadeOffset: 120,
        expandedHeight: screenHeight / 5,
        floating: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        fadeWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: screenHeight / 22,
                ),
                Text(
                  "Hello Listener",
                  style: GoogleFonts.aboreto(
                    color: Color.fromARGB(255, 144, 36, 36),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "turn into tunin ",
                  style: TextStyle(
                    color: ColorsinUse().white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        child: const SongsList(),
      ),
    );
  }
}
