import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:packpulse/domain/entity/onboarding_preferences_entity.dart';
import 'package:packpulse/injection.dart';
import 'package:packpulse/presentation/view/onboarding/onboarding_frequency_view.dart';

class OnboardingFlightTypeView extends StatefulWidget {
  const OnboardingFlightTypeView({super.key});

  @override
  State<OnboardingFlightTypeView> createState() =>
      _OnboardingFlightTypeViewState();
}

class _OnboardingFlightTypeViewState extends State<OnboardingFlightTypeView> {
  int _selectedIndex = 0;

  final List<String> _options = [
    'FPV Freestyle',
    'Cinematic',
    'Long Range',
    'RC Cars',
    'RC Planes',
  ];

  Future<void> _goNext() async {
    await Injection.onboardingCacheUseCase.savePartial(
      OnboardingPreferencesEntity(flightType: _options[_selectedIndex]),
    );
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const OnboardingFrequencyView(),
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
        title: const Text('PackPulse'),
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
                    'Step 1 of 5',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '20% Complete',
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
                  value: 0.2,
                  minHeight: 4.h,
                  backgroundColor: const Color(0xFFE8ECEF),
                  valueColor: const AlwaysStoppedAnimation<Color>(brandGreen),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'What do you fly?',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0C1410),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Choose the primary way you fly so we can tune your pack insights.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF5B6A62),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedIndex;
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() => _selectedIndex = index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEFFDF4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? brandGreen
                                : const Color(0xFFE0E5E9),
                            width: 1.4,
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
                          children: [
                            Icon(
                              Icons.flight_takeoff_rounded,
                              color: isSelected
                                  ? brandGreen
                                  : const Color(0xFF9BA7AF),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                _options[index],
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0C1410),
                                ),
                              ),
                            ),
                            Container(
                              width: 22.w,
                              height: 22.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isSelected ? brandGreen : Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: isSelected ? brandGreen : Colors.white,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
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
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

