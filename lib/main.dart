import 'package:falling_ball/screens/game_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

import 'core/services/ad_state.dart';

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

  // 画面を縦固定
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(
    Provider<AdState?>.value(
      value: adState,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GameScreen(),
      ),
    ),
  );
}
