// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:provider/provider.dart';
import 'package:tunin_2/db_functions/db_function/db_favourite.dart';
import 'package:tunin_2/views/home_page/listing/home_page.dart';
import 'package:tunin_2/views/favourite_pages/favourite_page.dart';
import 'package:tunin_2/views/playlist_pages/pages/playlist_page.dart';
import 'package:tunin_2/views/settings_pages/settings_page.dart';

import 'package:tunin_2/common/widgets/get_songs.dart';
import 'package:tunin_2/common/miniplayer/mini_player.dart';

import 'package:tunin_2/common/miniplayer/show_mini.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> bottomNavOptions = <Widget>[
    const HomePage(),
    FavoratePage(),
    const PlayListPage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: bottomNavOptions,
        ),
        bottomNavigationBar: Consumer<ShowMiniPlayer>(
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (Provider.of<GetSongs>(context, listen: false)
                        .audioPlayer
                        .currentIndex !=
                    null)
                  Miniplayer(
                    minHeight: 70,
                    maxHeight: 70,
                    builder: (height, percentage) {
                      return MiniaudioPlayerWidget(
                        miniaudioPlayerSong:
                            Provider.of<GetSongs>(context, listen: false)
                                .playingSongs,
                      );
                    },
                  ),
                const SizedBox.shrink(),
                GNav(
                    activeColor: const Color.fromARGB(255, 171, 18, 18),
                    tabs: const [
                      GButton(
                        icon: Icons.home,
                        iconColor: Color.fromARGB(255, 79, 79, 79),
                        text: 'Home',
                      ),
                      GButton(
                        icon: Icons.thumb_up_rounded,
                        iconColor: Color.fromARGB(255, 79, 79, 79),
                        text: ' Liked',
                      ),
                      GButton(
                        icon: Icons.playlist_add,
                        iconColor: Color.fromARGB(255, 79, 79, 79),
                        text: 'Playlists',
                      ),
                      GButton(
                        icon: Icons.settings,
                        iconColor: Color.fromARGB(255, 79, 79, 79),
                        text: 'Settings',
                      ),
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                        Provider.of<FavouriteDb>(context, listen: false)
                            .notifyListeners();
                        Provider.of<ShowMiniPlayer>(context, listen: false)
                            .notifyListeners();
                      });
                    }),
              ],
            );
          },
        ));
  }
}
