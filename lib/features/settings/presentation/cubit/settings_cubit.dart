import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/settings_service.dart';

class SettingsState {
  final bool hapticFeedbackEnabled;

  SettingsState({required this.hapticFeedbackEnabled});
}

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _settingsService;

  SettingsCubit(this._settingsService) : super(SettingsState(hapticFeedbackEnabled: true));

  Future<void> loadSettings() async {
    final hapticFeedbackEnabled = await _settingsService.isHapticFeedbackEnabled();
    emit(SettingsState(hapticFeedbackEnabled: hapticFeedbackEnabled));
  }

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    await _settingsService.setHapticFeedbackEnabled(enabled);
    emit(SettingsState(hapticFeedbackEnabled: enabled));
  }
}