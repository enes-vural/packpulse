import 'package:shared_preferences/shared_preferences.dart';

import 'data/repository/onboarding_cache_repository.dart';
import 'domain/usecase/onboarding_cache_use_case.dart';

/// Simple dependency injection / service locator.
/// Initialized in main before runApp.
class Injection {
  static late final OnboardingCacheUseCase onboardingCacheUseCase;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheRepo = OnboardingCacheRepository(prefs);
    onboardingCacheUseCase = OnboardingCacheUseCase(cacheRepo);
  }
}
