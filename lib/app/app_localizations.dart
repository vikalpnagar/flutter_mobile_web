import 'dart:async';
import 'dart:ui';

import 'package:flutter_mobile_web/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Localization handler for the app
class AppLocalizations {
  final String _localeName;

  AppLocalizations(this._localeName) {}

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode == null || locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  String get appTitle =>
      Intl.message("Flutter Mobile + Web", name: "appTitle", locale: _localeName);

  String get albumsTitle =>
      Intl.message("Albums", name: "albumsTitle", locale: _localeName);

  String get noDataToShow =>
      Intl.message("Nothing to show here.\nTry refreshing the page.",
          name: "noDataToShow", locale: _localeName);

  String get refreshButton =>
      Intl.message("Refresh", name: "refreshButton", locale: _localeName);

  String get errorDialogTitle => Intl.message("An error occurred!",
      name: "errorDialogTitle", locale: _localeName);

  String get errorDialogMsg => Intl.message("Something went wrong.",
      name: "errorDialogMsg", locale: _localeName);

  String get errorDialogMsgNoInternet =>
      Intl.message("Looks like you do not have active internet connection.",
          name: "errorDialogMsgNoInternet", locale: _localeName);

  String get errorDialogButton =>
      Intl.message("Okay", name: "errorDialogButton", locale: _localeName);

  String get photosTitle =>
      Intl.message("Photos", name: "photosTitle", locale: _localeName);

  String get albumId =>
      Intl.message("Album ID", name: "albumId", locale: _localeName);

  String get photoId =>
      Intl.message("Photo ID", name: "photoId", locale: _localeName);

  String get otherPhotos =>
      Intl.message("Other photos from the same album", name: "otherPhotos", locale: _localeName);
}

class AppTranslationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppTranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Supporting only english for now
    return ["en"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
