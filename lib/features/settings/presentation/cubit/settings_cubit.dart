import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/settings_usecases.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
  }) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final settings = await getSettingsUseCase();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateSettings(SettingsEntity settings) async {
    emit(SettingsActionInProgress());
    try {
      await updateSettingsUseCase(settings);
      emit(const SettingsActionSuccess('Settings updated successfully'));
      loadSettings();
    } catch (e) {
      emit(SettingsError(e.toString()));
      loadSettings(); // Reload to get back to valid state
    }
  }
}
