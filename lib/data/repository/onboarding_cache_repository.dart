import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/cache_constants.dart';
import '../../domain/entity/onboarding_preferences_entity.dart';
import '../../domain/repository/i_onboarding_cache_repository.dart';

/// Implementation of [IOnboardingCacheRepository] using SharedPreferences.
/// Single responsibility: persist/retrieve onboarding data.
class OnboardingCacheRepository implements IOnboardingCacheRepository {
  OnboardingCacheRepository(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<OnboardingPreferencesEntity> getPreferences() async {
    return OnboardingPreferencesEntity(
      flightType: _prefs.getString(CacheConstants.flightType),
      flightFrequency: _prefs.getString(CacheConstants.flightFrequency),
      packsPerSession: _prefs.getInt(CacheConstants.packsPerSession),
      temperatureIndex: _prefs.getInt(CacheConstants.temperatureIndex),
      highPowerSetup: _prefs.getBool(CacheConstants.highPowerSetup),
      adaptiveAi: _prefs.getBool(CacheConstants.adaptiveAi),
      criticalAlerts: _prefs.getBool(CacheConstants.criticalAlerts),
      maintenanceReminders: _prefs.getBool(CacheConstants.maintenanceReminders),
      performanceReports: _prefs.getBool(CacheConstants.performanceReports),
      notificationsRequested:
          _prefs.getBool(CacheConstants.notificationsRequested),
      completed: _prefs.getBool(CacheConstants.onboardingCompleted) ?? false,
    );
  }

  @override
  Future<void> savePreferences(OnboardingPreferencesEntity preferences) async {
    final batch = <Future<void>>[];
    if (preferences.flightType != null) {
      batch.add(_prefs.setString(CacheConstants.flightType, preferences.flightType!));
    }
    if (preferences.flightFrequency != null) {
      batch.add(_prefs.setString(
          CacheConstants.flightFrequency, preferences.flightFrequency!));
    }
    if (preferences.packsPerSession != null) {
      batch.add(_prefs.setInt(
          CacheConstants.packsPerSession, preferences.packsPerSession!));
    }
    if (preferences.temperatureIndex != null) {
      batch.add(_prefs.setInt(
          CacheConstants.temperatureIndex, preferences.temperatureIndex!));
    }
    if (preferences.highPowerSetup != null) {
      batch.add(_prefs.setBool(
          CacheConstants.highPowerSetup, preferences.highPowerSetup!));
    }
    if (preferences.adaptiveAi != null) {
      batch.add(
          _prefs.setBool(CacheConstants.adaptiveAi, preferences.adaptiveAi!));
    }
    if (preferences.criticalAlerts != null) {
      batch.add(_prefs.setBool(
          CacheConstants.criticalAlerts, preferences.criticalAlerts!));
    }
    if (preferences.maintenanceReminders != null) {
      batch.add(_prefs.setBool(
          CacheConstants.maintenanceReminders,
          preferences.maintenanceReminders!));
    }
    if (preferences.performanceReports != null) {
      batch.add(_prefs.setBool(
          CacheConstants.performanceReports,
          preferences.performanceReports!));
    }
    if (preferences.notificationsRequested != null) {
      batch.add(_prefs.setBool(
          CacheConstants.notificationsRequested,
          preferences.notificationsRequested!));
    }
    if (preferences.completed) {
      batch.add(_prefs.setBool(CacheConstants.onboardingCompleted, true));
    }
    await Future.wait(batch);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(CacheConstants.onboardingCompleted) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(CacheConstants.onboardingCompleted, true);
  }
}
