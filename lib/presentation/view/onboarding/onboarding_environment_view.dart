import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'onboarding_notifications_view.dart';

class OnboardingEnvironmentView extends StatefulWidget {
  const OnboardingEnvironmentView({super.key});

  @override
  State<OnboardingEnvironmentView> createState() =>
      _OnboardingEnvironmentViewState();
}

class _OnboardingEnvironmentViewState extends State<OnboardingEnvironmentView> {
  int _temperatureIndex = 1;
  bool _highPowerSetup = true;
  bool _adaptiveAi = true;

  void _goNext() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const OnboardingNotificationsView(),
      ),
    );
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
                    'Environment & Gear',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Step 4 of 5',
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
                  value: 0.8,
                  minHeight: 4.h,
                  backgroundColor: const Color(0xFFE8ECEF),
                  valueColor: const AlwaysStoppedAnimation<Color>(brandGreen),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Environment & Gear',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0C1410),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Tell us about where and how you fly to optimize your battery health predictions.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF5B6A62),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Typical flying temperature',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0C1410),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _TemperatureChip(
                    label: 'Cold',
                    isSelected: _temperatureIndex == 0,
                    onTap: () => setState(() => _temperatureIndex = 0),
                  ),
                  SizedBox(width: 8.w),
                  _TemperatureChip(
                    label: 'Mild',
                    isSelected: _temperatureIndex == 1,
                    onTap: () => setState(() => _temperatureIndex = 1),
                  ),
                  SizedBox(width: 8.w),
                  _TemperatureChip(
                    label: 'Hot',
                    isSelected: _temperatureIndex == 2,
                    onTap: () => setState(() => _temperatureIndex = 2),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                'Operating batteries in extreme temperatures affects cycle life.',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20.h),
              _ToggleCard(
                title: 'High-power setup',
                subtitle:
                    'Optimized for Racing / X-Class drones with high amp draw.',
                value: _highPowerSetup,
                onChanged: (value) {
                  setState(() => _highPowerSetup = value);
                },
              ),
              SizedBox(height: 12.h),
              _ToggleCard(
                title: 'Adaptive Pulse AI',
                subtitle:
                    'Based on your selection, PackPulse will adjust the discharge curve warnings for your specific gear setup.',
                value: _adaptiveAi,
                onChanged: (value) {
                  setState(() => _adaptiveAi = value);
                },
              ),
              const Spacer(),
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
                  onPressed: _goNext,
                  child: Text(
                    'Continue',
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
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(
                    'Skip for now',
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

class _TemperatureChip extends StatelessWidget {
  const _TemperatureChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF00FF5A);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFFDF4) : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? brandGreen : const Color(0xFFE0E5E9),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF0C1410)
                  : const Color(0xFF5B6A62),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
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

