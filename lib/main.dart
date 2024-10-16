import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'package:fall_game/game.dart';
import 'package:fall_game/ad_state.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdState? adState;
  Future<InitializationStatus>? initFuture;
  if (!kIsWeb) {
    initFuture = MobileAds.instance.initialize();
    adState = AdState(initFuture);
  }

  await supabase_flutter.Supabase.initialize(
    url: 'https://jooyyxchsczjwljxdpem.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impvb3l5eGNoc2N6andsanhkcGVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA5OTU1NjUsImV4cCI6MjAxNjU3MTU2NX0.eiXR1YEuyEB95r1C0bkn2EpQzbXxWBkiBnelozo1z98',
      realtimeClientOptions: const supabase_flutter.RealtimeClientOptions(eventsPerSecond: 40),
  );

  // 画面を横固定
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    Provider<AdState?>.value(
      value: adState,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner:false, // 右上のDEBUG消去
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: MyApp(),
      ),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  BannerAd? banner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState?>(context);
    if (adState != null) {
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
            adUnitId: adState.bannerAdUnitId,
            size: AdSize.largeBanner,
            request: AdRequest(),
            listener: adState.adListener,
          )..load();
        });
      });
    }
  }

  // ATT対応
  Future<void> initPlugin() async {
    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } on PlatformException {}
    await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Game main screen
        body: _MyApp(),
        backgroundColor: Colors.black,
        // Google AdMob
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (banner == null)
              Container(
                color: Colors.black,
                height: 100,
              )
            else
              Container(
                color: Colors.black,
                height: 100,
                child: AdWidget(ad: banner!),
              ),
          ]
        )
      );
  }
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final Size size = MediaQuery.of(context).size;
    return GameWidget(
      game: FallGame(
          context: context,
//          viewportResolution: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
//          screenSize: Vector2(size.width, size.height),
      ),
    );
  }
}