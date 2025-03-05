import 'package:flutter/material.dart';
import 'package:matiz/features/albums/data/models/album_model.dart';
import 'package:matiz/app/widgets/album_card.dart';

class AlbumListView extends StatelessWidget {
  final bool isAuthenticated;
  final List<Album> items;
  final ScrollController? scrollController;

  const AlbumListView(
      {super.key,
      required this.items,
      this.scrollController,
      this.isAuthenticated = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return AlbumCard(album: items[index], isUserLoggedin: isAuthenticated);
      },
    );
  }
}
