import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tunin_2/views/favourite_pages/favourite_button.dart';
import 'package:tunin_2/common/widgets/get_songs.dart';
import '../../../db_functions/db_function/db_favourite.dart';
import '../../../utils/consts/colors.dart';
import '../../../common/miniplayer/show_mini.dart';

class SongsList extends StatefulWidget {
  const SongsList({
    super.key,
  });

  static List<SongModel> song = [];

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  final _audioQuery = OnAudioQuery();
  bool isFavourite = true;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  @override
  void dispose() {
    Provider.of<GetSongs>(context, listen: false).audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: SongSortType.DURATION,
          orderType: OrderType.DESC_OR_GREATER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return Center(
                child: Lottie.asset(
                    'assets/lottie/131209-chart-generation.json',
                    height: 10));
          }
          if (item.data!.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(
                    'No Songs Found',
                    style: TextStyle(color: ColorsinUse().white),
                  ),
                ],
              ),
            );
          }
          SongsList.song = item.data!;
          if (!Provider.of<FavouriteDb>(context, listen: false).isfavourite) {
            Provider.of<FavouriteDb>(context, listen: false)
                .isFavourite(item.data!);
          }
          Provider.of<GetSongs>(context, listen: false).songscopy = item.data!;
          return ListView.separated(
            itemBuilder: ((context, index) => Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Consumer<GetSongs>(
                    builder: (context, provider, child) {
                      return ListTile(
                        tileColor: ColorsinUse().tilecolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        leading: QueryArtworkWidget(
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.circular(2),
                          size: 50,
                          artworkFit: BoxFit.fill,
                          quality: 100,
                          nullArtworkWidget: const Icon(
                            Icons.music_note_rounded,
                            color: Color.fromARGB(137, 255, 255, 255),
                            size: 35,
                          ),
                        ),
                        title: Text(
                          item.data![index].displayNameWOExt,
                          maxLines: 1,
                          style: TextStyle(color: ColorsinUse().white),
                        ),
                        subtitle: Text(
                          '${item.data![index].artist}',
                          style: TextStyle(color: ColorsinUse().white),
                        ),
                        trailing: FavouriteButton(
                          song: item.data![index],
                        ),
                        onTap: () async {
                          provider.audioPlayer.setAudioSource(
                              provider.createSongList(item.data!),
                              initialIndex: index);

                          await Provider.of<ShowMiniPlayer>(context,
                                  listen: false)
                              .updateMiniPlayer(songlist: item.data!);

                          await provider.audioPlayer.play();
                        },
                      );
                    },
                  ),
                )),
            itemCount: item.data!.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
        setState(() {});
      }
    }
  }
}
