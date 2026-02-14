import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:clock_app/shared/settings_preference.dart';

class RingtoneService {
  RingtoneService._();
  static final instance = RingtoneService._();

  static const _allowedAssetSounds = ['sounds/alarm.wav', 'sounds/timer_end.wav'];

  AudioPlayer? _assetPlayer;
  bool _usingAsset = false;

  Future<void> playAlarmLoop({bool isTimer = false}) async {
    if (kIsWeb) return;
    final prefs = SettingsPreference.instance;
    final soundKey = isTimer
        ? await prefs.getTimerSound()
        : await prefs.getAlarmSound();
    if (soundKey == 'system' || soundKey.isEmpty || !_allowedAssetSounds.contains(soundKey)) {
      await FlutterRingtonePlayer().play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        asAlarm: true,
        looping: true,
        volume: 1.0,
      );
      _usingAsset = false;
      return;
    }
    _usingAsset = true;
    _assetPlayer?.stop();
    _assetPlayer = AudioPlayer();
    await _assetPlayer!.setReleaseMode(ReleaseMode.loop);
    await _assetPlayer!.play(AssetSource(soundKey));
  }

  Future<void> stop() async {
    if (_usingAsset && _assetPlayer != null) {
      await _assetPlayer!.stop();
      _assetPlayer = null;
      _usingAsset = false;
    } else {
      await FlutterRingtonePlayer().stop();
    }
  }
}
