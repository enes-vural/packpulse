import '../entity/onboarding_preferences_entity.dart';
import '../repository/i_onboarding_cache_repository.dart';

/// Use case for onboarding cache operations.
/// Encapsulates business rules; presentation layer depends on this, not repository.
class OnboardingCacheUseCase {
  OnboardingCacheUseCase(this._repository);

  final IOnboardingCacheRepository _repository;

  Future<OnboardingPreferencesEntity> getPreferences() =>
      _repository.getPreferences();

  Future<void> savePreferences(OnboardingPreferencesEntity preferences) =>
      _repository.savePreferences(preferences);

  Future<bool> isOnboardingCompleted() =>
      _repository.isOnboardingCompleted();

  Future<void> completeOnboarding(OnboardingPreferencesEntity partial) async {
    final current = await _repository.getPreferences();
    final merged = OnboardingPreferencesEntity(
      flightType: partial.flightType ?? current.flightType,
      flightFrequency: partial.flightFrequency ?? current.flightFrequency,
      packsPerSession: partial.packsPerSession ?? current.packsPerSession,
      temperatureIndex: partial.temperatureIndex ?? current.temperatureIndex,
      highPowerSetup: partial.highPowerSetup ?? current.highPowerSetup,
      adaptiveAi: partial.adaptiveAi ?? current.adaptiveAi,
      criticalAlerts: partial.criticalAlerts ?? current.criticalAlerts,
      maintenanceReminders:
          partial.maintenanceReminders ?? current.maintenanceReminders,
      performanceReports:
          partial.performanceReports ?? current.performanceReports,
      notificationsRequested:
          partial.notificationsRequested ?? current.notificationsRequested,
      completed: true,
    );
    await _repository.savePreferences(merged);
  }

  /// Merges partial preferences with existing cached data and saves.
  Future<void> savePartial(OnboardingPreferencesEntity partial) async {
    final current = await _repository.getPreferences();
    final merged = OnboardingPreferencesEntity(
      flightType: partial.flightType ?? current.flightType,
      flightFrequency: partial.flightFrequency ?? current.flightFrequency,
      packsPerSession: partial.packsPerSession ?? current.packsPerSession,
      temperatureIndex: partial.temperatureIndex ?? current.temperatureIndex,
      highPowerSetup: partial.highPowerSetup ?? current.highPowerSetup,
      adaptiveAi: partial.adaptiveAi ?? current.adaptiveAi,
      criticalAlerts: partial.criticalAlerts ?? current.criticalAlerts,
      maintenanceReminders:
          partial.maintenanceReminders ?? current.maintenanceReminders,
      performanceReports:
          partial.performanceReports ?? current.performanceReports,
      notificationsRequested:
          partial.notificationsRequested ?? current.notificationsRequested,
      completed: partial.completed || current.completed,
    );
    await _repository.savePreferences(merged);
  }
}
