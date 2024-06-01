import 'package:assets_audio_player/assets_audio_player.dart';

class AppAudioPlayer {
  static final AssetsAudioPlayer _player = AssetsAudioPlayer();
  static double volumeLevel = 0.5;
  static void initializeAudioPlayer() {
    _player.open(
      Audio("assets/animal sounds/chill-drum-loop-6887.mp3"),
      loopMode: LoopMode.single,
      volume: volumeLevel,
    );
  }

  static void playSound() async {
    await _player.play();
  }

  static void pauseSound() async {
    await _player.pause();
  }

  static void stopSound() async {
    await _player.stop();
  }

  //set volume up
  static void volumeUp() async {
    if (volumeLevel < 1) {
      volumeLevel += 0.1;
      _player.setVolume(volumeLevel);
    }
  }

//set volume down
  static void volumeDown() async {
    if (volumeLevel > 0) {
      volumeLevel -= 0.1;
      _player.setVolume(volumeLevel);
    }
  }
}
