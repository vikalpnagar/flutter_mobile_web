import 'package:http/http.dart';

/// Return error in case no suitable platform is detected
BaseClient get httpClient => throw UnsupportedError('Unknown Platform');
