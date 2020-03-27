import 'package:flutter_mobile_web/app/app_localizations.dart';
import 'package:flutter_mobile_web/helper/network_util.dart';
import 'package:flutter_mobile_web/helper/system_helper.dart';
import 'package:flutter_mobile_web/providers/album/album.dart';
import 'package:flutter_mobile_web/providers/album/album_provider.dart';
import 'package:flutter_mobile_web/widgets/album_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatelessWidget {
  static const routeName = '/album-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).albumsTitle,
        ),
      ),
      body: AlbumView(),
    );
  }
}

class AlbumView extends StatefulWidget {
  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  Future _fetchAlbumsFuture;

  @override
  void initState() {
    super.initState();
    _fetchAlbumsFuture = _fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAlbumGrid();
  }

  FutureBuilder _buildAlbumGrid() => FutureBuilder(
        future: _fetchAlbumsFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchAlbums,
                    child: Consumer<AlbumProvider>(
                      builder: (ctx, albums, _) {
                        if (albums.itemsLength > 0) {
                          final List<Album> albumList = albums.allItems;
                          return Scrollbar(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: SystemHelper.isWeb ? 3 : 2,
                                childAspectRatio: 2,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              itemCount: albums.itemsLength,
                              itemBuilder: (_, i) => AlbumItem(
                                albumList[i].id,
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
                _fetchAlbumsFuture = _fetchAlbums();
              }),
              child: Text(
                AppLocalizations.of(context).refreshButton,
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      );

  Future<void> _fetchAlbums() {
    var fetchAlbums =
        Provider.of<AlbumProvider>(context, listen: false).fetchAlbums();
    return fetchAlbums.catchError((error) async {
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
