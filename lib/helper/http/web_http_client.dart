import 'package:http/browser_client.dart';

/// Returning BrowserClient if our app is running on browser
BrowserClient get httpClient {
  return BrowserClient();
}
