import 'package:fall_game/features/game/world.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:fall_game/app/config.dart';
import 'package:fall_game/features/game/game.dart';

import 'package:url_launcher/url_launcher.dart';

class TitleDialog {
  late final List<SpriteComponent> _titleDialog;

  List<SpriteComponent> get titleDialog => _titleDialog;

  Future<void> initialize() async {
    _titleDialog = [
      Menu(),
      TitleLogo(),
      StartButton(),
      MultiButton(),
      RankingButton(),
      PostButton(),
      Copyright(),
    ];
  }

  void show(game) {
    game.addAll(_titleDialog);
  }

  void hide(game) {
    _titleDialog.forEach((element) {element.removeFromParent();});
  }
}

class TitleLogo extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_TITLE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .25);
    size = Vector2(Config.WORLD_WIDTH * .77, Config.WORLD_HEIGHT * .2);
    priority = Config.PRIORITY_TITLE_LOGO;
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
    priority = Config.PRIORITY_MENU;
    anchor = Anchor.center;
  }
}

class StartButton extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_START));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .49);
    size = Vector2(Config.WORLD_WIDTH * .46, Config.WORLD_HEIGHT * .085);
    priority = Config.PRIORITY_START_BUTTON;
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    (world as FallGameWorld).singleStart();
    return false;
  }
}

class MultiButton extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_MULTI));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .58);
    size = Vector2(Config.WORLD_WIDTH * .46, Config.WORLD_HEIGHT * .085);
    priority = Config.PRIORITY_START_BUTTON;
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    (world as FallGameWorld).multiStart();
    return false;
  }
}

class RankingButton extends SpriteComponent
    with TapCallbacks, HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_RANKING));
    position = Vector2(Config.WORLD_WIDTH * .4, Config.WORLD_HEIGHT * .72);
    size = Vector2(Config.WORLD_WIDTH * .18, Config.WORLD_HEIGHT * .10);
    priority = Config.PRIORITY_START_BUTTON;
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
    position = Vector2(Config.WORLD_WIDTH * .6, Config.WORLD_HEIGHT * .72);
    size = Vector2(Config.WORLD_WIDTH * .15, Config.WORLD_HEIGHT * .09);
    priority = Config.PRIORITY_START_BUTTON;
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
    size = Vector2(Config.WORLD_WIDTH * .6, Config.WORLD_HEIGHT * .048);
    priority = Config.PRIORITY_START_BUTTON;
    anchor = Anchor.center;
  }
}
