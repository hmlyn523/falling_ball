import 'package:flame_audio/flame_audio.dart';

class Audio {
  static late Map<String, AudioPool> _audioPools;
  static const AUDIO_BGM = 'bgm.wav';
  static const AUDIO_TITLE = 'title.wav';
  static const AUDIO_COLLISION = 'sfx/collision.wav';
  static const AUDIO_SPAWN = 'sfx/spawn.wav';

  static Future<void> load() async {
    // FlameAudio.bgm.initialize();
    // _audioPools = {
    //   AUDIO_COLLISION : await FlameAudio.createPool(AUDIO_COLLISION, minPlayers: 3, maxPlayers: 4),
    //   AUDIO_SPAWN : await FlameAudio.createPool(AUDIO_SPAWN, minPlayers: 3, maxPlayers: 4),
    // };
  }

  static Future<void> play(String filename) async {
    // await _audioPools[filename]!.start();
  }

  static Future<void> bgmPlay(String filename) async {
    // if (FlameAudio.bgm.isPlaying) {
    //   await FlameAudio.bgm.stop();
    // }
    // await FlameAudio.bgm.play(filename);
  }

  static Future<void> bgmStop() async {
    // await FlameAudio.bgm.stop();
  }
}
