import 'package:flutter/material.dart';
import 'package:flutter_mobile_web/providers/album/album_provider.dart';
import 'package:flutter_mobile_web/screens/photo_screen.dart';
import 'package:provider/provider.dart';

class AlbumItem extends StatelessWidget {
  final int albumId;

  const AlbumItem(this.albumId);

  @override
  Widget build(BuildContext context) {
    final album =
        Provider.of<AlbumProvider>(context, listen: false).findById(albumId);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(PhotoScreen.routeName, arguments: albumId),
      child: Card(
        color: Theme.of(context).accentColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              album.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
