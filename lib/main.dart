import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:tunin_2/db_functions/db_function/db_favourite.dart';
import 'package:tunin_2/db_functions/db_function/db_playlist.dart';

import 'package:tunin_2/db_functions/model/audio_player.dart';
import 'package:tunin_2/views/playlist_pages/common_playlist/checkPlaylist.dart';
import 'package:tunin_2/splash_screen.dart';
import 'package:tunin_2/common/widgets/get_songs.dart';
import 'package:tunin_2/common/miniplayer/show_mini.dart';

Future<void> main(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AudioPlayerAdapter().typeId)) {
    Hive.registerAdapter(AudioPlayerAdapter());
  }
  await Hive.openBox<int>('favouriteDB');
  await Hive.openBox<AudioPlayer>('playlistDB');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavouriteDb()),
        ChangeNotifierProvider(create: (context) => PlaylistDb()),
        ChangeNotifierProvider(create: (context) => GetSongs()),
        ChangeNotifierProvider(create: (context) => ShowMiniPlayer()),
        ChangeNotifierProvider(create: (context) => CheckPlaylist())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.from(colorScheme: const ColorScheme.dark()),
        home: const SplashScreen(),
      ),
    );
  }
}
