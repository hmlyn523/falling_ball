import 'package:falling_ball/features/game/world.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/features/game/game.dart';

import 'package:url_launcher/url_launcher.dart';

class TitleDialog extends PositionComponent
  with HasVisibility {

  late final List<SpriteComponent> _titleDialog;

  List<SpriteComponent> get titleDialog => _titleDialog;

  TitleDialog(): super(
    position: Vector2.all(0),
    size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
  ){
    priority = Config.PRIORITY_TITLE;
    _titleDialog = [
      Menu(),
      TitleLogo(),
      StartButton(),
      Multi2Button(),
      Multi3Button(),
      // RankingButton(),
      // PostButton(),
      Copyright(),
    ];
    isVisible = false;
  }

  @override
  Future<void> onLoad() async {
    addAll(_titleDialog);
  }

  void setVisibility(bool isVisible) {
    priority = isVisible ? Config.PRIORITY_GAME_OVER : Config.PRIORITY_MIN;
    this.isVisible = isVisible;
  }
}

class TitleLogo extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_TITLE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .25);
    size = Vector2(Config.WORLD_WIDTH * .83, Config.WORLD_HEIGHT * .22);
    anchor = Anchor.center;
  }
}

class Menu extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_MENU));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .61);
    size = Vector2(Config.WORLD_WIDTH * .6, Config.WORLD_HEIGHT * .4);
    // priority = Config.PRIORITY_MENU;
    anchor = Anchor.center;
  }
}

class StartButton extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_START));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .485);
    size = Vector2(Config.WORLD_WIDTH * .53, Config.WORLD_HEIGHT * .095);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    (world as FallGameWorld).singleStart();
    return false;
  }
}

class Multi2Button extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_MULTI2));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .595);
    size = Vector2(Config.WORLD_WIDTH * .53, Config.WORLD_HEIGHT * .095);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    (world as FallGameWorld).multiStart(other_players: 1);
    return false;
  }
}

class Multi3Button extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_MULTI3));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .705);
    size = Vector2(Config.WORLD_WIDTH * .53, Config.WORLD_HEIGHT * .095);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    (world as FallGameWorld).multiStart(other_players: 2);
    return false;
  }
}

class RankingButton extends SpriteComponent
    with TapCallbacks, HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_RANKING));
    position = Vector2(Config.WORLD_WIDTH * .4, Config.WORLD_HEIGHT * .74);
    size = Vector2(Config.WORLD_WIDTH * .18, Config.WORLD_HEIGHT * .10);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    // GamesServices.showLeaderboards(iOSLeaderboardID: 'tapjump.ranking');
    // GamesServices.loadLeaderboardScores(
    //   iOSLeaderboardID: 'tapjump.ranking',
    //   scope: PlayerScope.global,
    //   timeScope: TimeScope.allTime,
    //   maxResults: 10);
    return false;
  }
}

class PostButton extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_POST));
    position = Vector2(Config.WORLD_WIDTH * .6, Config.WORLD_HEIGHT * .74);
    size = Vector2(Config.WORLD_WIDTH * .15, Config.WORLD_HEIGHT * .09);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    // var message = L10n.of((game as FallGame).context)!.post1 +
    //               (world as FallGameWorld).score.toString() +
    //               L10n.of((game as FallGame).context)!.post2;
    // _post(message);
    return false;
  }

  void _post(message) async {
    final Map<String, dynamic> postQuery = {
      "text": message,
      "url": "",
      "hashtags": const [],
      "via": "",
      "related": "",
    };

    final Uri postScheme =
        Uri(scheme: "twitter", host: "post", queryParameters: postQuery);

    final Uri postIntentUrl =
        Uri.https("twitter.com", "/intent/tweet", postQuery);

    if (await canLaunchUrl(postScheme)) {
      await launchUrl(postScheme);
    } else if (await canLaunchUrl(postIntentUrl)) {
      await launchUrl(postIntentUrl);
    }
  }
}

class Copyright extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite =
        Sprite((game as FallGame).images.fromCache(Config.IMAGE_COPYRIGHT));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .85);
    size = Vector2(Config.WORLD_WIDTH * .6, Config.WORLD_HEIGHT * .055);
    anchor = Anchor.center;
  }
}
