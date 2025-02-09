import 'package:falling_ball/core/services/ad_state.dart';
import 'package:falling_ball/core/services/auth_service.dart';
import 'package:falling_ball/features/game/game.dart';
import 'package:falling_ball/screens/user_name_input_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BannerAd? banner;
  late final SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ゲーム本体
          GameWidget(
            game: FallGame(context: context, supabase: supabase),
            overlayBuilderMap: {
              'userNameInput': (context, game) => UserNameInputOverlay(
                onSave: (userName, password) async {
                  AuthService.signInOrSignUp(context, supabase, userName, password);
                  (game as FallGame).hideUserNameInput();
                },
              ),
            },
          ),
          // >>> debug ユーザ名を削除
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                AuthService.logout(supabase);
                // SplashScreenに戻る
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => GameScreen(),
                    transitionDuration: Duration.zero, // アニメーションの時間を0にする
                    reverseTransitionDuration: Duration.zero, // 戻りのアニメーションも0にする
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text("ログアウト"),
            ),
          ),
          // <<< debug
        ],
      ),
      bottomNavigationBar: banner != null
          ? Container(
              height: 50,
              child: AdWidget(ad: banner!),
            )
          : SizedBox(),
    );
  }
}