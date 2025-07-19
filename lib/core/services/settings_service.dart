import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable

class SettingsService {
  static const _hapticFeedbackEnabledKey = 'haptic_feedback_enabled';

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticFeedbackEnabledKey, enabled);
  }

  Future<bool> isHapticFeedbackEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticFeedbackEnabledKey) ?? true;
  }
}