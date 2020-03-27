import 'dart:io';

import 'package:flutter_mobile_web/helper/system_helper.dart';
import 'package:connectivity/connectivity.dart';

class NetworkUtil {

  // API Endpoints
  static const String SERVER_URL = "https://jsonplaceholder.typicode.com/";
  static const String ALBUM_SEGMENT = "albums";
  static const String PHOTO_SEGMENT = "photos";

  static Future<bool> checkNetworkConnectivity() async {
    if (!SystemHelper.isWeb) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
    }
    return true;
  }

  /// Check if active internet connection is available.
  static Future<bool> isActiveInternetAvailable() async {

    // connectivity plugin is only supported only for mobiles.
    // So skipping this in case app is running on browser
    bool available =
        SystemHelper.isWeb ? true : await checkNetworkConnectivity();

    if (available) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Active Internet Connection Available');
          return true;
        }
      } on SocketException catch (_) {
        print('Active Internet Connection NOT Available');
      }
    }
    return false;
  }
}
