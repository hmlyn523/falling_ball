import 'package:falling_ball/features/game/world.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/features/game/game.dart';

class TitleDialog extends PositionComponent
  with HasVisibility {

  late final List<SpriteComponent> _titleDialog;

  List<SpriteComponent> get titleDialog => _titleDialog;

  TitleDialog(): super(
    position: Vector2.all(0),
    size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
  ){
    _titleDialog = [
      // Menu(),
      Copyright(),
      TitleLogo(),
      ChoosePlayers(),
      StartButton(),
      Multi2Button(),
      Multi3Button(),
      Multi4Button(),
      RankAndScore(),
      RankingButton(),
      ScoreButton(),
      // PostButton(),
    ];
    isVisible = false;
    priority = Config.PRIORITY_MIN;
  }

  @override
  Future<void> onLoad() async {
    addAll(_titleDialog);
  }

  void setVisibility(bool isVisible) {
    if (isVisible == this.isVisible) return;
    // 非表示時にイベントを無効化するため、TapTitleButtonのpriorityを変更
    priority = isVisible ? Config.PRIORITY_TITLE : Config.PRIORITY_MIN;
    for (var component in _titleDialog) {
      component.priority = isVisible ? Config.PRIORITY_TITLE : Config.PRIORITY_MIN;
    }
    this.isVisible = isVisible;
  }
}

class TitleLogo extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_TITLE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .275);
    size = Vector2(Config.WORLD_WIDTH * .92, Config.WORLD_HEIGHT * .17);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
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
    priority = Config.PRIORITY_MIN;
  }
}

class StartButton extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_START));
    position = Vector2(Config.WORLD_WIDTH * .35, Config.WORLD_HEIGHT * .5);
    size = Vector2(Config.WORLD_WIDTH * .25, Config.WORLD_HEIGHT * .09);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    (world as FallGameWorld).singleStart();
    return false;
  }
}

class Multi2Button extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_MULTI2));
    position = Vector2(Config.WORLD_WIDTH * .65, Config.WORLD_HEIGHT * .5);
    size = Vector2(Config.WORLD_WIDTH * .25, Config.WORLD_HEIGHT * .09);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    (world as FallGameWorld).multiStart(other_players: 1);
    return false;
  }
}

class Multi3Button extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_MULTI3));
    position = Vector2(Config.WORLD_WIDTH * .35, Config.WORLD_HEIGHT * .62);
    size = Vector2(Config.WORLD_WIDTH * .25, Config.WORLD_HEIGHT * .09);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    (world as FallGameWorld).multiStart(other_players: 2);
    return false;
  }
}

class Multi4Button extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_MULTI4));
    position = Vector2(Config.WORLD_WIDTH * .65, Config.WORLD_HEIGHT * .62);
    size = Vector2(Config.WORLD_WIDTH * .25, Config.WORLD_HEIGHT * .09);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    (world as FallGameWorld).multiStart(other_players: 3);
    return false;
  }
}

class RankingButton extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_RANKING));
    position = Vector2(Config.WORLD_WIDTH * .35, Config.WORLD_HEIGHT * .81);
    size = Vector2(Config.WORLD_WIDTH * .25, Config.WORLD_HEIGHT * .09);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    (world as FallGameWorld).showRankingLayer();
    // RankingLayer aaa = RankingLayer();
    
    // GamesServices.showLeaderboards(iOSLeaderboardID: 'tapjump.ranking');
    // GamesServices.loadLeaderboardScores(
    //   iOSLeaderboardID: 'tapjump.ranking',
    //   scope: PlayerScope.global,
    //   timeScope: TimeScope.allTime,
    //   maxResults: 10);
    return false;
  }
}

class ScoreButton extends SpriteComponent
    with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_SCORE));
    position = Vector2(Config.WORLD_WIDTH * .65, Config.WORLD_HEIGHT * .81);
    size = Vector2(Config.WORLD_WIDTH * .25, Config.WORLD_HEIGHT * .09);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    // (world as FallGameWorld).showRankingLayer();
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
    priority = Config.PRIORITY_MIN;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    // var message = L10n.of((game as FallGame).context)!.post1 +
    //               (world as FallGameWorld).score.toString() +
    //               L10n.of((game as FallGame).context)!.post2;
    // _post(message);
    return false;
  }

  // void _post(message) async {
  //   final Map<String, dynamic> postQuery = {
  //     "text": message,
  //     "url": "",
  //     "hashtags": const [],
  //     "via": "",
  //     "related": "",
  //   };

  //   final Uri postScheme =
  //       Uri(scheme: "twitter", host: "post", queryParameters: postQuery);

  //   final Uri postIntentUrl =
  //       Uri.https("twitter.com", "/intent/tweet", postQuery);

  //   if (await canLaunchUrl(postScheme)) {
  //     await launchUrl(postScheme);
  //   } else if (await canLaunchUrl(postIntentUrl)) {
  //     await launchUrl(postIntentUrl);
  //   }
  // }
}

class Copyright extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite =
        Sprite((game as FallGame).images.fromCache(Config.IMAGE_COPYRIGHT));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .14);
    size = Vector2(Config.WORLD_WIDTH * .6, Config.WORLD_HEIGHT * .055);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }
}

class ChoosePlayers extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite =
        Sprite((game as FallGame).images.fromCache(Config.IMAGE_CHOOSE_PLAYErS));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .415);
    size = Vector2(Config.WORLD_WIDTH * .595, Config.WORLD_HEIGHT * .038);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }
}

class RankAndScore extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite =
        Sprite((game as FallGame).images.fromCache(Config.IMAGE_RANK_AND_SCORE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .72);
    size = Vector2(Config.WORLD_WIDTH * .625, Config.WORLD_HEIGHT * .038);
    anchor = Anchor.center;
    priority = Config.PRIORITY_MIN;
  }
}
