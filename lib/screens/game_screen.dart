import 'package:falling_ball/core/services/ad_state.dart';
import 'package:falling_ball/features/game/game.dart';
import 'package:falling_ball/screens/user_name_input_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BannerAd? banner;

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
            game: FallGame(context: context),
            overlayBuilderMap: {
              'userNameInput': (context, game) => UserNameInputOverlay(
                onSave: (userName) async {
                  final uuid = const Uuid().v4();
                  final prefs = await SharedPreferences.getInstance();
                  final userNameSetResult = await prefs.setString('userName', userName);
                  final uuidSetResult = await prefs.setString('uuid', uuid);
                  if (userNameSetResult && uuidSetResult) {
                    print('ユーザー名の保存に成功しました: $userName');
                    (game as FallGame).hideUserNameInput();
                  } else {
                    print('ユーザー名の保存に失敗しました');
                  }
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
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('userName'); // ユーザー名を削除

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
              child: Text("ユーザ削除"),
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