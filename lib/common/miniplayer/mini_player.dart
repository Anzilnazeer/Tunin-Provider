import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tunin_2/views/home_page/now_playing/now_playing_page.dart';

import '../widgets/get_songs.dart';

class MiniaudioPlayerWidget extends StatefulWidget {
  const MiniaudioPlayerWidget({
    super.key,
    required this.miniaudioPlayerSong,
  });
  final List<SongModel> miniaudioPlayerSong;

  @override
  State<MiniaudioPlayerWidget> createState() => _MiniaudioPlayerWidgetState();
}

class _MiniaudioPlayerWidgetState extends State<MiniaudioPlayerWidget> {
  @override
  void initState() {
    Provider.of<GetSongs>(context, listen: false)
        .audioPlayer
        .currentIndexStream
        .listen((index) {
      if (index != null && mounted) {
        setState(() {});
        Provider.of<GetSongs>(context, listen: false).currentIndexes = index;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetSongs>(
      builder: (context, value, child) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 82, 7, 7),
                Color.fromARGB(255, 43, 4, 4),
              ],
            ),
          ),
          child: Center(
              child: ListTile(
            leading: const Icon(
              Icons.music_note_rounded,
              color: Color.fromARGB(137, 255, 255, 255),
              size: 35,
            ),
            onTap: () {
              Navigator.of(context).push(createRoute());
              value.audioPlayer.play();
            },
            title: TextScroll(
              value.playingSongs[value.currentIndexes].title,
              velocity: const Velocity(pixelsPerSecond: Offset(25, 0)),
              style: const TextStyle(
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        if (value.audioPlayer.playing) {
                          await value.audioPlayer.pause();
                          setState(() {});
                        } else {
                          await value.audioPlayer.play();
                          setState(() {});
                        }
                      },
                      icon: StreamBuilder<bool>(
                        stream: value.audioPlayer.playingStream,
                        builder: (context, snapshot) {
                          bool? playingStage = snapshot.data;
                          if (playingStage != null && playingStage) {
                            return const Icon(
                              Icons.pause,
                              size: 33,
                              color: Color.fromARGB(255, 255, 255, 255),
                            );
                          } else {
                            return const Icon(
                              Icons.play_arrow,
                              size: 35,
                              color: Color.fromARGB(255, 255, 255, 255),
                            );
                          }
                        },
                      )),
                  IconButton(
                      onPressed: () async {
                        if (value.audioPlayer.hasNext) {
                          await value.audioPlayer.seekToNext();
                          await value.audioPlayer.play();
                        } else {
                          await value.audioPlayer.play();
                        }
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 35,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ))
                ],
              ),
            ),
          )),
        );
      },
    );
  }

  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          NowPlaying(audioPlayerSong: widget.miniaudioPlayerSong),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.5);
        const end = Offset.zero;
        const curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
