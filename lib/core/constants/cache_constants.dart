/// Cache keys for onboarding and app preferences.
/// Keeps storage keys centralized and type-safe.
abstract final class CacheConstants {
  static const String onboardingCompleted = 'onboarding_completed';
  static const String flightType = 'onboarding_flight_type';
  static const String flightFrequency = 'onboarding_flight_frequency';
  static const String packsPerSession = 'onboarding_packs_per_session';
  static const String temperatureIndex = 'onboarding_temperature_index';
  static const String highPowerSetup = 'onboarding_high_power_setup';
  static const String adaptiveAi = 'onboarding_adaptive_ai';
  static const String criticalAlerts = 'onboarding_critical_alerts';
  static const String maintenanceReminders = 'onboarding_maintenance_reminders';
  static const String performanceReports = 'onboarding_performance_reports';
  static const String notificationsRequested = 'onboarding_notifications_requested';
}
