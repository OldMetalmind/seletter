// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:seletter/helpers/helpers.dart';
import 'package:seletter/helpers/navigator_helper.dart';
import 'package:seletter/l10n/l10n.dart';
import 'package:seletter/puzzle/puzzle.dart';
import 'package:seletter/ui/finish/finish_page.dart';
import 'package:seletter/ui/home/home_page.dart';

class App extends StatefulWidget {
  const App({Key? key, ValueGetter<PlatformHelper>? platformHelperFactory})
      : _platformHelperFactory = platformHelperFactory ?? getPlatformHelper,
        super(key: key);

  final ValueGetter<PlatformHelper> _platformHelperFactory;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// The path to local assets folder.
  static const localAssetsPrefix = 'assets/';

  static final audioControlAssets = [
    'assets/images/audio_control/simple_on.png',
    'assets/images/audio_control/simple_off.png',
    'assets/images/audio_control/dashatar_on.png',
    'assets/images/audio_control/green_dashatar_off.png',
    'assets/images/audio_control/blue_dashatar_off.png',
    'assets/images/audio_control/yellow_dashatar_off.png',
  ];

  static final audioAssets = [
    'assets/audio/shuffle.mp3',
    'assets/audio/click.mp3',
    'assets/audio/dumbbell.mp3',
    'assets/audio/sandwich.mp3',
    'assets/audio/skateboard.mp3',
    'assets/audio/success.mp3',
    'assets/audio/tile_move.mp3',
  ];

  static final animationAssets = [
    'assets/animations/tile_puzzle.json',
    'assets/animations/button_primary.json',
    'assets/animations/button_secondary.json',
    'assets/animations/star_small.json',
    'assets/animations/tile_hint.json',
    'assets/animations/result_0.json',
    'assets/animations/result_1.json',
    'assets/animations/result_2.json',
    'assets/animations/result_3.json',
    'assets/animations/tutorial.json',
    'assets/animations/logo_intro.json',
  ];

  late final PlatformHelper _platformHelper;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _platformHelper = widget._platformHelperFactory();

    _timer = Timer(const Duration(milliseconds: 20), () {
      for (var i = 1; i <= 15; i++) {
        precacheImage(
          Image.asset('assets/images/dashatar/green/$i.png').image,
          context,
        );
        precacheImage(
          Image.asset('assets/images/dashatar/blue/$i.png').image,
          context,
        );
        precacheImage(
          Image.asset('assets/images/dashatar/yellow/$i.png').image,
          context,
        );
      }
      precacheImage(
        Image.asset('assets/images/dashatar/gallery/green.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/success/green.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/gallery/blue.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/success/blue.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/gallery/yellow.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/success/yellow.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/logo_flutter_color.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/logo_flutter_white.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/shuffle_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/timer_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/simple_dash_large.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/simple_dash_medium.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/simple_dash_small.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/twitter_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/facebook_icon.png').image,
        context,
      );

      for (final audioControlAsset in audioControlAssets) {
        precacheImage(
          Image.asset(audioControlAsset).image,
          context,
        );
      }

      for (final audioAsset in audioAssets) {
        prefetchToMemory(audioAsset);
      }

      for (final animation in animationAssets) {
        prefetchToMemory(animation);
      }
    });
  }

  /// Prefetches the given [filePath] to memory.
  Future<void> prefetchToMemory(String filePath) async {
    if (_platformHelper.isWeb) {
      // We rely on browser caching here. Once the browser downloads the file,
      // the native implementation should be able to access it from cache.
      await http.get(Uri.parse('$localAssetsPrefix$filePath'));
      return;
    }
    // logger.i(
    //   '''
    //   The function `prefetchToMemory` is not implemented for platforms other than Web.
    //   ''',
    // );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xff49D737),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xff49D737),
          backgroundColor: const Color(0xffEFEFEF),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: pageHome,
      routes: {
        pageHome: (context) => const HomePage(),
        pageGame: (context) => const PuzzlePage(),
        pageFinish: (context) => const FinishPage(),
      },
    );
  }
}
