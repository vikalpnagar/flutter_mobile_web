import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_web/helper/network_util.dart';
import 'package:flutter_mobile_web/providers/album/album.dart';

class AlbumProvider with ChangeNotifier {
  var _ioClient;

  List<Album> _items = [];

  List<Album> get allItems {
    return [..._items];
  }

  int get itemsLength {
    return _items?.length ?? 0;
  }

  set ioClient(baseClient) => this._ioClient = baseClient;

  Album findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAlbums() async {
    var url = '${NetworkUtil.SERVER_URL}${NetworkUtil.ALBUM_SEGMENT}';
    try {
      final response = await _ioClient.get(url);
      final jsonResponse = jsonDecode(response.body) as Iterable;
      print("fetchAlbums: jsonResponse $jsonResponse");
      final List<Album> albumList = [];
      if (jsonResponse != null) {
        albumList.addAll(jsonResponse.map((value) => Album.fromJson(value)));
        _items = albumList;
      }
      notifyListeners();
    } catch (error) {
      print("fetchAlbums: Exception ${error.toString()}");
      throw (error);
    }
  }
}
