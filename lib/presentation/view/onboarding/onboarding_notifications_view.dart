import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingNotificationsView extends StatefulWidget {
  const OnboardingNotificationsView({super.key});

  @override
  State<OnboardingNotificationsView> createState() =>
      _OnboardingNotificationsViewState();
}

class _OnboardingNotificationsViewState
    extends State<OnboardingNotificationsView> {
  bool _criticalAlerts = true;
  bool _maintenanceReminders = true;
  bool _performanceReports = false;

  void _finish() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF00FF5A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text('Onboarding'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Final Step: Notifications',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '5 / 5',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: brandGreen,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: 1,
                  minHeight: 4.h,
                  backgroundColor: const Color(0xFFE8ECEF),
                  valueColor: const AlwaysStoppedAnimation<Color>(brandGreen),
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEFFDF4),
                      ),
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: brandGreen,
                        size: 34.w,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Stay Informed',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0C1410),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Control how PackPulse keeps you updated.\nChoose the alerts that matter most to your fleet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF5B6A62),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: ListView(
                  children: [
                    _NotificationCard(
                      title: 'Critical Health Alerts',
                      subtitle:
                          'Immediate notifications for hardware failure or health risks.',
                      value: _criticalAlerts,
                      color: const Color(0xFFFF4C4C),
                      onChanged: (value) {
                        setState(() => _criticalAlerts = value);
                      },
                    ),
                    SizedBox(height: 12.h),
                    _NotificationCard(
                      title: 'Maintenance Reminders',
                      subtitle:
                          'Scheduled updates for routine pack maintenance checks.',
                      value: _maintenanceReminders,
                      color: brandGreen,
                      onChanged: (value) {
                        setState(() => _maintenanceReminders = value);
                      },
                    ),
                    SizedBox(height: 12.h),
                    _NotificationCard(
                      title: 'Performance Reports',
                      subtitle:
                          'Weekly summaries of your pack\'s efficiency and usage.',
                      value: _performanceReports,
                      color: const Color(0xFF3B82F6),
                      onChanged: (value) {
                        setState(() => _performanceReports = value);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: brandGreen,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _finish,
                  child: Text(
                    'Finish Setup',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Remind me later',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E5E9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.notifications_rounded,
              size: 16.w,
              color: color,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0C1410),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF5B6A62),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF00FF5A),
            inactiveTrackColor: const Color(0xFFE0E5E9),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

