import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;
  GetSettingsUseCase(this.repository);
  Future<SettingsEntity> call() => repository.getSettings();
}

class UpdateSettingsUseCase {
  final SettingsRepository repository;
  UpdateSettingsUseCase(this.repository);
  Future<void> call(SettingsEntity params) => repository.updateSettings(params);
}
