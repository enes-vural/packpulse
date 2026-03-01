import '../entity/onboarding_preferences_entity.dart';

/// Repository interface for onboarding cache operations.
/// Domain depends on abstraction, not implementation (Dependency Inversion).
abstract interface class IOnboardingCacheRepository {
  Future<OnboardingPreferencesEntity> getPreferences();

  Future<void> savePreferences(OnboardingPreferencesEntity preferences);

  Future<bool> isOnboardingCompleted();

  Future<void> setOnboardingCompleted();
}
