/// Domain entity for onboarding user preferences.
/// Immutable, framework-agnostic representation of cached onboarding data.
class OnboardingPreferencesEntity {
  const OnboardingPreferencesEntity({
    this.flightType,
    this.flightFrequency,
    this.packsPerSession,
    this.temperatureIndex,
    this.highPowerSetup,
    this.adaptiveAi,
    this.criticalAlerts,
    this.maintenanceReminders,
    this.performanceReports,
    this.notificationsRequested,
    this.completed = false,
  });

  final String? flightType;
  final String? flightFrequency;
  final int? packsPerSession;
  final int? temperatureIndex;
  final bool? highPowerSetup;
  final bool? adaptiveAi;
  final bool? criticalAlerts;
  final bool? maintenanceReminders;
  final bool? performanceReports;
  final bool? notificationsRequested;
  final bool completed;

  OnboardingPreferencesEntity copyWith({
    String? flightType,
    String? flightFrequency,
    int? packsPerSession,
    int? temperatureIndex,
    bool? highPowerSetup,
    bool? adaptiveAi,
    bool? criticalAlerts,
    bool? maintenanceReminders,
    bool? performanceReports,
    bool? notificationsRequested,
    bool? completed,
  }) {
    return OnboardingPreferencesEntity(
      flightType: flightType ?? this.flightType,
      flightFrequency: flightFrequency ?? this.flightFrequency,
      packsPerSession: packsPerSession ?? this.packsPerSession,
      temperatureIndex: temperatureIndex ?? this.temperatureIndex,
      highPowerSetup: highPowerSetup ?? this.highPowerSetup,
      adaptiveAi: adaptiveAi ?? this.adaptiveAi,
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      maintenanceReminders: maintenanceReminders ?? this.maintenanceReminders,
      performanceReports: performanceReports ?? this.performanceReports,
      notificationsRequested:
          notificationsRequested ?? this.notificationsRequested,
      completed: completed ?? this.completed,
    );
  }
}
