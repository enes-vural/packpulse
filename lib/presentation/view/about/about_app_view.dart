import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({super.key});

  static const Color brandGreen = Color(0xFF00FF5A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('About PackPulse'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEFFDF4),
                    ),
                    child: Icon(
                      Icons.battery_full_rounded,
                      color: brandGreen,
                      size: 28.w,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      'PackPulse helps you understand, protect, and get more flights from your LiPo packs.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF5B6A62),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                'Why PackPulse?',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0C1410),
                ),
              ),
              SizedBox(height: 12.h),
              _BulletPoint(
                title: 'Track real battery health',
                body:
                    'Go beyond voltage and flight timers. PackPulse models how you actually fly to estimate true pack health and cycle life.',
              ),
              _BulletPoint(
                title: 'Catch issues before they fail',
                body:
                    'Get early warnings about packs that are drifting, overheating, or behaving differently from your fleet.',
              ),
              _BulletPoint(
                title: 'Fly with confidence',
                body:
                    'See which packs are mission‑ready and which ones should stay on the bench, based on real usage data.',
              ),
              SizedBox(height: 24.h),
              Text(
                'How it works',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0C1410),
                ),
              ),
              SizedBox(height: 12.h),
              _StepCard(
                index: 1,
                title: 'Tell us how you fly',
                body:
                    'During onboarding, PackPulse learns your aircraft type, flying style, and environment so health predictions match your real world.',
              ),
              _StepCard(
                index: 2,
                title: 'Log flights & charging',
                body:
                    'Each cycle updates your pack profile, tracking stress, depth of discharge, and temperature exposure over time.',
              ),
              _StepCard(
                index: 3,
                title: 'Get smart recommendations',
                body:
                    'PackPulse highlights which packs to rotate, retire, or watch closely so you can avoid surprises in the air.',
              ),
              SizedBox(height: 24.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C1410),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: brandGreen,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'The more you fly with PackPulse, the smarter your predictions and recommendations become.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Back to start',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            margin: EdgeInsets.only(top: 7.h, right: 10.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00FF5A),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0C1410),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF5B6A62),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.index,
    required this.title,
    required this.body,
  });

  final int index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEFFDF4),
            ),
            alignment: Alignment.center,
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF00FF5A),
              ),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0C1410),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF5B6A62),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

