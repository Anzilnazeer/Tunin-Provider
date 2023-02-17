// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tunin_2/db_functions/db_function/db_favourite.dart';
import 'package:tunin_2/views/favourite_pages/favourite_button.dart';
import 'package:tunin_2/common/widgets/get_songs.dart';

import '../../../utils/consts/colors.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    Key? key,
    required this.audioPlayerSong,
  }) : super(key: key);

  final List<SongModel> audioPlayerSong;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

ValueNotifier<List<SongModel>> playingSongNotifier = ValueNotifier([]);

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  int currentIndex = 0;

  @override
  void initState() {
    Provider.of<GetSongs>(context, listen: false)
        .audioPlayer
        .currentIndexStream
        .listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
        Provider.of<GetSongs>(context, listen: false).currentIndexes = index;
      }
    });

    super.initState();
    sliderFuntion();
  }

  void sliderFuntion() {
    Provider.of<GetSongs>(context, listen: false)
        .audioPlayer
        .durationStream
        .listen((time) {
      setState(() {
        _duration = time!;
      });
    });
    Provider.of<GetSongs>(context, listen: false)
        .audioPlayer
        .positionStream
        .listen((pos) {
      setState(() {
        _position = pos;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetSongs>(
      builder: (context, provider, child) {
        return Container(
          decoration: newGradient(),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 100,
                backgroundColor: const Color.fromARGB(0, 117, 2, 2),
                title: Text(
                  'Now Playing',
                  style: GoogleFonts.aboreto(),
                  textAlign: TextAlign.center,
                ),
                leading: IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    provider.audioPlayer.pause();
                    Provider.of<FavouriteDb>(context, listen: false)
                        .notifyListeners();
                  }),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 25,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20),
                          child: SizedBox(
                            height: 320,
                            width: 330,
                            child: QueryArtworkWidget(
                                id: widget.audioPlayerSong[currentIndex].id,
                                type: ArtworkType.AUDIO,
                                keepOldArtwork: true,
                                artworkBorder: BorderRadius.circular(20),
                                artworkClipBehavior:
                                    Clip.antiAliasWithSaveLayer,
                                artworkFit: BoxFit.fill,
                                quality: 100,
                                nullArtworkWidget: Provider.of<GetSongs>(
                                            context,
                                            listen: false)
                                        .audioPlayer
                                        .playing
                                    ? Lottie.asset(
                                        "assets/lottie/30131-audio-power.json",
                                        animate: true,
                                        height: 100)
                                    : Lottie.asset(
                                        "assets/lottie/30131-audio-power.json",
                                        animate: false,
                                        height: 100)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextScroll(
                            widget.audioPlayerSong[currentIndex].title,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(25, 0)),
                            style: const TextStyle(
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            widget.audioPlayerSong[currentIndex].artist
                                        .toString() ==
                                    '<Unknown>'
                                ? "Unknown Artist?"
                                : widget.audioPlayerSong[currentIndex].artist
                                    .toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FavouriteButton(
                            song: widget.audioPlayerSong[currentIndex],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Slider(
                        thumbColor: const Color.fromARGB(79, 250, 245, 245),
                        activeColor: const Color.fromARGB(255, 226, 226, 226),
                        inactiveColor: const Color.fromARGB(85, 218, 218, 218),
                        value: _position.inSeconds.toDouble(),
                        min: const Duration(microseconds: 0)
                            .inSeconds
                            .toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        onChanged: ((value) {
                          setState(() {
                            changeToSeconds(value.toInt());
                            value = value;
                          });
                        })),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _position.toString().substring(2, 7).split('.')[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _duration.toString().substring(2, 7).split('.')[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            provider.audioPlayer.shuffleModeEnabled
                                ? provider.audioPlayer
                                    .setShuffleModeEnabled(false)
                                : provider.audioPlayer
                                    .setShuffleModeEnabled(true);
                          },
                          icon: StreamBuilder(
                            stream:
                                provider.audioPlayer.shuffleModeEnabledStream,
                            builder: (context, snapshot) {
                              if (provider.audioPlayer.shuffleModeEnabled) {
                                return Icon(
                                  Icons.shuffle,
                                  color: ColorsinUse().white,
                                  size: 25,
                                );
                              } else {
                                return const Icon(
                                  Icons.shuffle,
                                  size: 25,
                                  color: Color.fromARGB(90, 255, 255, 255),
                                );
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (provider.audioPlayer.hasPrevious) {
                                provider.audioPlayer.seekToPrevious();
                                provider.audioPlayer.play();
                              } else {
                                provider.audioPlayer.play();
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.skip_previous_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          iconSize: 50,
                          icon: StreamBuilder(
                              stream: provider.audioPlayer.playingStream,
                              builder: (context, snapshot) {
                                bool? playing = snapshot.data;
                                if (playing != null && playing) {
                                  return const Icon(
                                    Icons.pause,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 45,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.play_arrow,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 45,
                                  );
                                }
                              }),
                          onPressed: (() async {
                            if (provider.audioPlayer.playing) {
                              await provider.audioPlayer.pause();
                              setState(() {});
                            } else {
                              await provider.audioPlayer.play();
                              setState(() {});
                            }
                          }),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() async {
                              if (provider.audioPlayer.hasNext) {
                                await provider.audioPlayer.seekToNext();
                                await provider.audioPlayer.play();
                              } else {
                                await provider.audioPlayer.play();
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.skip_next_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: (() {
                            provider.audioPlayer.loopMode == LoopMode.one
                                ? provider.audioPlayer.setLoopMode(LoopMode.all)
                                : provider.audioPlayer
                                    .setLoopMode(LoopMode.one);
                          }),
                          icon: StreamBuilder<LoopMode>(
                            stream: provider.audioPlayer.loopModeStream,
                            builder: (context, item) {
                              final loopMode = item.data;
                              if (LoopMode.one == loopMode) {
                                return const Icon(
                                  Icons.repeat,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 25,
                                );
                              } else {
                                return const Icon(
                                  Icons.repeat,
                                  size: 25,
                                  color: Color.fromARGB(90, 255, 255, 255),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  void changeToSeconds(int secoonds) {
    Duration duration = Duration(seconds: secoonds);
    Provider.of<GetSongs>(context).audioPlayer.seek(duration);
  }
}
