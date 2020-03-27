import 'dart:convert';

import 'package:flutter_mobile_web/helper/network_util.dart';
import 'package:flutter_mobile_web/providers/photo/photo.dart';
import 'package:flutter/material.dart';

class PhotoProvider with ChangeNotifier {
  var _ioClient;

  List<Photo> _items = [];

  List<Photo> get allItems {
    return [..._items];
  }

  int get itemsLength {
    return _items?.length ?? 0;
  }

  set ioClient(baseClient) => this._ioClient = baseClient;

  Photo findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  int itemsLengthByAlbumId(int albumId) =>
      _items.where((photo) => photo.albumId == albumId).length;

  List<Photo> itemsByAlbumId(int albumId) =>
      _items.where((photo) => photo.albumId == albumId).toList();

  Future<void> fetchPhotos(int albumId) async {
    var url =
        '${NetworkUtil.SERVER_URL}${NetworkUtil.PHOTO_SEGMENT}?albumId=$albumId';
    try {
      final response = await _ioClient.get(url);
      final jsonResponse = jsonDecode(response.body) as Iterable;
      print("fetchPhotos: jsonResponse $jsonResponse");
      final List<Photo> photoList = [];
      if (jsonResponse != null) {
        photoList.addAll(jsonResponse.map((value) => Photo.fromJson(value)));
        _items = photoList;
      }
      notifyListeners();
    } catch (error) {
      _ioClient.close();
      print("fetchPhotos: Exception ${error.toString()}");
      throw (error);
    }
  }
}
