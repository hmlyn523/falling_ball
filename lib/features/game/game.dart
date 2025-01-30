import 'package:falling_ball/features/game/world.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:falling_ball/app/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FallGame extends Forge2DGame {
  final context;

  FallGame({required this.context})
      : super(
          gravity: Vector2(0, 30.0),
          world: FallGameWorld(context),
          camera: CameraComponent.withFixedResolution(
            width: Config.WORLD_WIDTH,
            height: Config.WORLD_HEIGHT,
          ),
          zoom: 1,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // SharedPreferencesでユーザー名を確認
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    final uuid = prefs.getString('uuid');
    print('userName : ${userName} / uuid: ${uuid}'); // Debug　
    if (userName == null || userName.isEmpty || uuid == null || uuid.isEmpty) {
      // ゲーム開始時にユーザー名入力オーバーレイを表示
      showUserNameInput();
    }else{
      hideUserNameInput();
    }
  }

  void showUserNameInput() {
    print('showUserNameInput()');
    overlays.add('userNameInput');
  }

  void hideUserNameInput() {
    print('hideUserNameInput()');
    overlays.remove('userNameInput');
  }
}
