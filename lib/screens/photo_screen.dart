import 'package:flutter_mobile_web/app/app_localizations.dart';
import 'package:flutter_mobile_web/helper/network_util.dart';
import 'package:flutter_mobile_web/providers/album/album.dart';
import 'package:flutter_mobile_web/providers/album/album_provider.dart';
import 'package:flutter_mobile_web/providers/photo/photo.dart';
import 'package:flutter_mobile_web/providers/photo/photo_provider.dart';
import 'package:flutter_mobile_web/widgets/album_item.dart';
import 'package:flutter_mobile_web/widgets/photo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoScreen extends StatelessWidget {
  static const routeName = '/photo-screen';

  @override
  Widget build(BuildContext context) {
    var albumId = ModalRoute.of(context).settings.arguments as int;
    String albumName = Provider.of<AlbumProvider>(context, listen: false)
            .findById(albumId)
            ?.title ??
        null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          albumName ?? AppLocalizations.of(context).photosTitle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PhotoView(albumId),
    );
  }
}

class PhotoView extends StatefulWidget {
  final int albumId;

  const PhotoView(this.albumId);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  Future _fetchPhotosFuture;

  @override
  void initState() {
    super.initState();
    _fetchPhotosFuture = _fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPhotosList();
  }

  FutureBuilder _buildPhotosList() => FutureBuilder(
        future: _fetchPhotosFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchPhotos,
                    child: Consumer<PhotoProvider>(
                      builder: (ctx, photos, _) {
                        int photosLength = photos.itemsLengthByAlbumId(widget.albumId);
                        if (photosLength > 0) {
                          final List<Photo> photoList = photos.itemsByAlbumId(widget.albumId);
                          return Scrollbar(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: photosLength,
                              itemBuilder: (_, i) => PhotoItem(
                                photoList[i].id,
                              ),
                            ),
                          );
                        } else {
                          return _buildNoDataView();
                        }
                      },
                    ),
                  ),
      );

  Center _buildNoDataView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).noDataToShow,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            RaisedButton(
              onPressed: () => setState(() {
                _fetchPhotosFuture = _fetchPhotos();
              }),
              child: Text(
                AppLocalizations.of(context).refreshButton,
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      );

  Future<void> _fetchPhotos() {
    var fetchPhotos = Provider.of<PhotoProvider>(context, listen: false)
        .fetchPhotos(widget.albumId);
    return fetchPhotos.catchError((error) async {
      await NetworkUtil.isActiveInternetAvailable().then((available) {
        showErrorDialog(!available);
      });
    });
  }

  void showErrorDialog(bool noInternet) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).errorDialogTitle),
        content: Text(noInternet
            ? AppLocalizations.of(context).errorDialogMsgNoInternet
            : AppLocalizations.of(context).errorDialogMsg),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).errorDialogButton),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
