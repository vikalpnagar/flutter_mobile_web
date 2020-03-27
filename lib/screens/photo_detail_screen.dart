import 'package:flutter_mobile_web/app/app_localizations.dart';
import 'package:flutter_mobile_web/helper/system_helper.dart';
import 'package:flutter_mobile_web/providers/photo/photo.dart';
import 'package:flutter_mobile_web/providers/photo/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_web/widgets/photo_item.dart';
import 'package:flutter_mobile_web/widgets/photo_item_detail.dart';
import 'package:provider/provider.dart';

class PhotoDetailScreen extends StatefulWidget {
  static const routeName = '/photo-detail';

  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  double _availableWidth;
  int _photoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _availableWidth = mediaQuery.size.width;
  }

  @override
  Widget build(BuildContext context) {
    if (_photoId == null)
      _photoId = ModalRoute.of(context).settings.arguments as int; // is the id!
    final photo =
        Provider.of<PhotoProvider>(context, listen: false).findById(_photoId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: SystemHelper.isWeb ? 600 : 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: _availableWidth / 2),
                child: Text(photo.title),
              ),
              background: Hero(
                tag: photo.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/photo_placeholder.png'),
                  image: NetworkImage(photo.url),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                AppLocalizations.of(context).otherPhotos,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ),
          Consumer<PhotoProvider>(
            builder: (ctx, photos, _) {
              int photosLength = photos.itemsLengthByAlbumId(photo.albumId);
              final List<Photo> photoList =
                  photos.itemsByAlbumId(photo.albumId);
              return SliverList(
                delegate: SliverChildBuilderDelegate((ctx, i) {
                  if (photosLength > 0) {
                    return PhotoItemDetail(
                      photoList[i].id,
                      onPhotoSelected,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }, childCount: photosLength),
              );
            },
          ),
        ],
      ),
    );
  }

  void onPhotoSelected(int photoId) {
    setState(() {
      this._photoId = photoId;
    });
  }
}
