import 'dart:io';

import 'package:http/io_client.dart';

/// Returning IOClient if the app is running on VM (In our case - Mobiles)
IOClient get httpClient {
  final httpClient = HttpClient();
  httpClient.connectionTimeout = const Duration(seconds: 10);
  return IOClient(httpClient);
}
