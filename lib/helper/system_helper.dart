import 'package:flutter/foundation.dart';

class SystemHelper {

  /// Check if we are running on web or mobile based on kIsWeb
  static bool get isWeb {
    return kIsWeb ?? false;
  }
}
