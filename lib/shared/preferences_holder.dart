import 'package:shared_preferences/shared_preferences.dart';

/// Holds a single cached [SharedPreferences] instance for the app lifecycle.
class PreferencesHolder {
  PreferencesHolder._();
  static final PreferencesHolder instance = PreferencesHolder._();

  SharedPreferences? _prefs;
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
}
