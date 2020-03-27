import 'package:flutter_mobile_web/app/app_localizations.dart';
import 'package:flutter_mobile_web/helper/http/http_client_stub.dart'
    if (dart.library.html) 'package:flutter_mobile_web/helper/http/web_http_client.dart'
    if (dart.library.io) 'package:flutter_mobile_web/helper/http/vm_http_client.dart';
import 'package:flutter_mobile_web/providers/album/album_provider.dart';
import 'package:flutter_mobile_web/providers/photo/photo_provider.dart';
import 'package:flutter_mobile_web/screens/album_screen.dart';
import 'package:flutter_mobile_web/screens/photo_detail_screen.dart';
import 'package:flutter_mobile_web/screens/photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _multiProvider(),
      child: MaterialApp(
        onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
        supportedLocales: [
          const Locale('en'),
        ],
        localizationsDelegates: [
          const AppTranslationsDelegate(),
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
          //provides RTL support
          GlobalWidgetsLocalizations.delegate,
          //provides IOS localization
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: _buildThemeData(),
        home: AlbumScreen(),
        routes: {
          PhotoScreen.routeName: (ctx) => PhotoScreen(),
          PhotoDetailScreen.routeName: (ctx) => PhotoDetailScreen(),
        },
      ),
    );
  }

  ThemeData _buildThemeData() => ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.cyan,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
              ),
              subtitle: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
                color: Colors.white,
              ),
              button: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              subhead: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
              ),
            ),
        buttonTheme: ThemeData.light().buttonTheme.copyWith(
              buttonColor: Colors.cyan,
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
        ),
      );

  BaseClient _createIOClient() {
    return httpClient;
  }

  List<SingleChildWidget> _multiProvider() {
    return [
      Provider<BaseClient>(
        create: (_) => _createIOClient(),
      ),
      ChangeNotifierProxyProvider<BaseClient, AlbumProvider>(
        create: (_) => AlbumProvider(),
        update: (ctx, ioClient, albumProvider) {
          albumProvider..ioClient = ioClient;
          return albumProvider;
        },
      ),
      ChangeNotifierProxyProvider<BaseClient, PhotoProvider>(
        create: (_) => PhotoProvider(),
        update: (ctx, ioClient, photoProvider) {
          photoProvider..ioClient = ioClient;
          return photoProvider;
        },
      ),
    ];
  }
}
