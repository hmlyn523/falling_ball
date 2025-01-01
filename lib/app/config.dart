import 'package:flame/components.dart';

class Config {
  static const MAX_OTHER_PLAYER_COUNT = 2;
  static const List<String> ENEMY_BALL_HEIGHT_IMAGES = [
    "enemy_ball_height.png",
    "enemy_ball_height2.png",
  ];

  static const ENEMY_BALL_HEIGHT_INTERVAL = 0.5;

  // static const List<int> itemDischargeProbability = [15, 10, 10, 10, 10, 10, 10, 10, 10, 5];
  static const List<int> itemDischargeProbability = [22, 18, 20, 21, 19];

  static const CATEGORY_BALL       = 0x0001; // 0000000000000010 in binary ボール
  static const CATEGORY_DOWN_WALL  = 0x0002; // 0000000000000100 in binary 下の壁
  static const CATEGORY_LEFT_WALL  = 0x0003; // 0000000000000100 in binary 左の壁
  static const CATEGORY_RIGHT_WALL = 0x0004; // 0000000000000100 in binary 右の壁

  // 画面スケール
  static const WORLD_WIDTH = 40.0;//20.0;//10.0;
  // static const WORLD_HEIGHT = 53.3;//26.65;//13.325;
  static const WORLD_HEIGHT = 63.96;//53.3;//26.65;//13.325;

  // 連鎖間隔
  static const CHAIN_INTERVAL = 600;
  static const MIN_CHAIN = 2;

  static const PRIORITY_MAX = 999;
  static const PRIORITY_CONNECT = 100;
  static const PRIORITY_TITLE = 90;
  static const PRIORITY_WIN_AND_LOSE = 85;
  static const PRIORITY_GAME_OVER = 80;
  static const PRIORITY_BACK_F = 70;
  static const PRIORITY_ENEMY_BALL_HEIGHT = 60;
  static const PRIORITY_FALL_ITEM = 50;
  static const PRIORITY_GAME_COMPONENT = 40;
  static const PRIORITY_FALL_ITEM_SPRITE = 30;
  static const PRIORITY_FALL_ITEM_NEXT = 20;
  static const PRIORITY_LINE = 10;
  // static const PRIORITY = 0; // SpriteBodyComponent
  static const PRIORITY_BACK_B = -10;
  static const PRIORITY_MIN = -999;

  static const IMAGE_1 = "1-icon.png";
  static const IMAGE_2 = "2-icon.png";
  static const IMAGE_3 = "3-icon.png";
  static const IMAGE_4 = "4-icon.png";
  static const IMAGE_5 = "5-icon.png";
  static const IMAGE_6 = "6-icon.png";
  static const IMAGE_7 = "7-icon.png";
  static const IMAGE_8 = "8-icon.png";
  static const IMAGE_9 = "9-icon.png";
  static const IMAGE_10 = "10-icon.png";
  static const IMAGE_11 = "11-icon.png";
  static const IMAGE_12 = "12-icon.png";
  static const IMAGE_BACKGROUND = "back_background.png";
  static const IMAGE_FOREGROUND = "back_foreground.png";
  static const IMAGE_TITLE = "title.png";
  static const IMAGE_START = "start.png";
  static const IMAGE_MULTI2 = "multi2.png";
  static const IMAGE_MULTI3 = "multi3.png";
  static const IMAGE_POST = "post.png";
  static const IMAGE_COPYRIGHT = "copyright.png";
  static const IMAGE_MENU = "menu.png";
  static const IMAGE_RANKING = "ranking.png";
  static const IMAGE_GAME_OVER = "game_over.png";
  static const IMAGE_TAP_TITLE = "tap_title.png";
  static const IMAGE_WIN = "win.png";
  static const IMAGE_LOSE = "lose.png";
  static const IMAGE_EMPTY = "empty.png";
  static const IMAGE_CONNECT = "connect.gif"; static const IMAGE_CANCEL = "cancel.png";
}

class WallPosition {
  static Vector2 topLeft = Vector2(Config.WORLD_WIDTH * .0, -Config.WORLD_HEIGHT);
  static Vector2 bottomRight = Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT * .91);
  static Vector2 topRight = Vector2(Config.WORLD_WIDTH, -Config.WORLD_HEIGHT);
  static Vector2 bottomLeft = Vector2(Config.WORLD_WIDTH * .0, Config.WORLD_HEIGHT * .91);
  static double width = topRight.x - topLeft.x;
}

// 落下ボールの属性定義
class FallingItemAttributes {
  late int type;
  final String image;
  final double radius;
  final Vector2 size;
  final double density;
  final int score;
  FallingItemAttributes(this.image, this.radius, this.size, this.density, this.score);
}

// 全ての落下ボールの属性情報
class FallingItemAttributesCollection {
  final List<FallingItemAttributes> value = [];
  FallingItemAttributesCollection() {
    value.add(new FallingItemAttributes(Config.IMAGE_1,  WallPosition.width * .08 * .5, Vector2.all(WallPosition.width * .08), 2.6,  0));
    value.add(new FallingItemAttributes(Config.IMAGE_2,  WallPosition.width * .099 * .5, Vector2.all(WallPosition.width * .099), 2.4,  1));
    value.add(new FallingItemAttributes(Config.IMAGE_3,  WallPosition.width * .129 * .5, Vector2.all(WallPosition.width * .129), 2.25, 3));
    value.add(new FallingItemAttributes(Config.IMAGE_4,  WallPosition.width * .166 * .5, Vector2.all(WallPosition.width * .166), 2.10, 6));
    value.add(new FallingItemAttributes(Config.IMAGE_5,  WallPosition.width * .208 * .5, Vector2.all(WallPosition.width * .208), 1.95, 10));
    value.add(new FallingItemAttributes(Config.IMAGE_6,  WallPosition.width * .250 * .5, Vector2.all(WallPosition.width * .250), 1.85, 15));
    value.add(new FallingItemAttributes(Config.IMAGE_7,  WallPosition.width * .298 * .5, Vector2.all(WallPosition.width * .298), 1.75, 21));
    value.add(new FallingItemAttributes(Config.IMAGE_8,  WallPosition.width * .346 * .5, Vector2.all(WallPosition.width * .346), 1.65, 28));
    value.add(new FallingItemAttributes(Config.IMAGE_9,  WallPosition.width * .399 * .5, Vector2.all(WallPosition.width * .399), 1.6,  36));
    value.add(new FallingItemAttributes(Config.IMAGE_10, WallPosition.width * .444 * .5, Vector2.all(WallPosition.width * .444), 1.55, 45));
    value.add(new FallingItemAttributes(Config.IMAGE_11, WallPosition.width * .513 * .5, Vector2.all(WallPosition.width * .513), 1.5,  55));
    value.add(new FallingItemAttributes(Config.IMAGE_12,  WallPosition.width * .08 * .5, Vector2.all(WallPosition.width * .08), 2.6,  0));
    // Set type.
    for ( int index = 0; index < value.length; index++) {
      value[index].type = index;
    }
  }
}
