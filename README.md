# PackPulse

Smart LiPo Health & Performance Tracking – Flutter app for drone/RC battery management.

## Getting Started

```bash
flutter pub get
flutter run
```

## Architecture

The app follows a layered / clean-ish architecture (see `AI_CONTEXT.md`):

- **Presentation**: `lib/presentation/` – views, widgets
- **Domain**: `lib/domain/` – entities, repository interfaces, use cases
- **Data**: `lib/data/` – repository implementations, services
- **Core**: `lib/core/` – constants, config

## Onboarding & Cache (SOLID)

Onboarding preferences are persisted locally using a cache layer:

- **Domain**: `OnboardingPreferencesEntity`, `IOnboardingCacheRepository`
- **Data**: `OnboardingCacheRepository` (SharedPreferences)
- **Use case**: `OnboardingCacheUseCase` – `savePartial`, `completeOnboarding`, `isOnboardingCompleted`

Each onboarding step saves its data via `savePartial`; the final step calls `completeOnboarding`. The app shows the starter/onboarding flow only when `isOnboardingCompleted()` is false.

### Flow

- **Finish Setup**: Saves preferences, requests notification permission, navigates to Home.
- **Remind me later**: Saves preferences (notifications off), skips permission request, navigates to Home.
