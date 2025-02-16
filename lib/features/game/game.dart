import 'package:falling_ball/core/services/auth_service.dart';
import 'package:falling_ball/features/game/world.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:falling_ball/app/config.dart';

class FallGame extends Forge2DGame {
  final context;
  late final supabase;

  FallGame({required this.context, required this.supabase})
      : super(
          gravity: Vector2(0.0, 30.0),
          world: FallGameWorld(context, supabase),
          camera: CameraComponent.withFixedResolution(
            width: Config.WORLD_WIDTH,
            height: Config.WORLD_HEIGHT,
          ),
          zoom: 1,
        ){}

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (await AuthService.isUserLoggedIn(supabase)) {
      hideUserNameInput();
    }else {
      showUserNameInput();
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
