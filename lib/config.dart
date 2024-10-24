import 'package:flame/components.dart';

class Config {
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
  static const CHAIN_INTERVAL = 1000;
  static const MIN_CHAIN = 3;

  static const PRIORITY_MAX = 999;
  static const PRIORITY_TITLE_LOGO = 120;
  static const PRIORITY_GAME_OVER_LOGO = 110;
  static const PRIORITY_TAP_TITLE = 100;
  static const PRIORITY_CANCEL = 90;
  static const PRIORITY_CONNECT = 80;
  static const PRIORITY_START_BUTTON = 70;
  static const PRIORITY_MENU = 60;
  static const PRIORITY_BACK_F = 55;
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
  static const IMAGE_MULTI = "multi.png";
  static const IMAGE_POST = "post.png";
  static const IMAGE_COPYRIGHT = "copyright.png";
  static const IMAGE_MENU = "menu.png";
  static const IMAGE_RANKING = "ranking.png";
  static const IMAGE_GAME_OVER = "game_over.png";
  static const IMAGE_TAP_TITLE = "tap_title.png";
  static const IMAGE_EMPTY = "empty.png";
  static const IMAGE_CONNECT = "connect.gif";
  static const IMAGE_CANCEL = "cancel.png";
}

class WallPosition {
  static Vector2 topLeft = Vector2(Config.WORLD_WIDTH * .05, -Config.WORLD_HEIGHT);
  static Vector2 bottomRight = Vector2(Config.WORLD_WIDTH * .95, Config.WORLD_HEIGHT * .9);
  static Vector2 topRight = Vector2(Config.WORLD_WIDTH * .95, -Config.WORLD_HEIGHT);
  static Vector2 bottomLeft = Vector2(Config.WORLD_WIDTH * .05, Config.WORLD_HEIGHT * .9);
  static double width = topRight.x - topLeft.x;
}

class FallInfo {
  late int type;
  final String image;
  final double radius;
  final Vector2 size;
  final double density;
  final int score;
  FallInfo(this.image, this.radius, this.size, this.density, this.score);
}

class FallList {
  final List<FallInfo> value = [];
  FallList() {
    value.add(new FallInfo(Config.IMAGE_1,  WallPosition.width * .070 * .5, Vector2.all(WallPosition.width * .070), 2.6,  0));
    value.add(new FallInfo(Config.IMAGE_2,  WallPosition.width * .097 * .45, Vector2.all(WallPosition.width * .097), 2.4,  1));
    value.add(new FallInfo(Config.IMAGE_3,  WallPosition.width * .129 * .45, Vector2.all(WallPosition.width * .129), 2.25, 3));
    value.add(new FallInfo(Config.IMAGE_4,  WallPosition.width * .166 * .45, Vector2.all(WallPosition.width * .166), 2.10, 6));
    value.add(new FallInfo(Config.IMAGE_5,  WallPosition.width * .208 * .45, Vector2.all(WallPosition.width * .208), 1.95, 10));
    value.add(new FallInfo(Config.IMAGE_6,  WallPosition.width * .250 * .45, Vector2.all(WallPosition.width * .250), 1.85, 15));
    value.add(new FallInfo(Config.IMAGE_7,  WallPosition.width * .298 * .45, Vector2.all(WallPosition.width * .298), 1.75, 21));
    value.add(new FallInfo(Config.IMAGE_8,  WallPosition.width * .346 * .45, Vector2.all(WallPosition.width * .346), 1.65, 28));
    value.add(new FallInfo(Config.IMAGE_9,  WallPosition.width * .399 * .45, Vector2.all(WallPosition.width * .399), 1.6,  36));
    value.add(new FallInfo(Config.IMAGE_10, WallPosition.width * .444 * .45, Vector2.all(WallPosition.width * .444), 1.55, 45));
    value.add(new FallInfo(Config.IMAGE_11, WallPosition.width * .513 * .45, Vector2.all(WallPosition.width * .513), 1.5,  55));
    value.add(new FallInfo(Config.IMAGE_12,  WallPosition.width * .070 * .45, Vector2.all(WallPosition.width * .070), 2.6,  0));
    // Set type.
    for ( int index = 0; index < value.length; index++) {
      value[index].type = index;
    }
  }
}
