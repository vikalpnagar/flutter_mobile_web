import 'package:flutter/material.dart';
import 'package:flutter_mobile_web/app/app_localizations.dart';
import 'package:flutter_mobile_web/providers/photo/photo_provider.dart';
import 'package:provider/provider.dart';

class PhotoItemDetail extends StatelessWidget {
  final int id;
  final Function onPhotoSelected;

  const PhotoItemDetail(this.id, this.onPhotoSelected);

  @override
  Widget build(BuildContext context) {
    final photo =
        Provider.of<PhotoProvider>(context, listen: false).findById(id);
    return GestureDetector(
      onTap: () => onPhotoSelected(photo.id),
      child: Card(
        color: Theme.of(context).accentColor,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(28.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/images/photo_placeholder.png'),
              image: NetworkImage(photo.thumbnailUrl),
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            photo.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            "${AppLocalizations.of(context).photoId} ${photo.id}, ${AppLocalizations.of(context).albumId} ${photo.albumId}",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
      ),
    );
  }
}
