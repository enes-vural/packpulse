import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'PackPulse',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00FF5A),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const StarterPage(),
    );
  }
}

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF00FF5A);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final horizontalPadding = w >= 900
                ? 64.w
                : w >= 600
                    ? 48.w
                    : 24.w;
            final maxContentWidth = w >= 900 ? 520.w : 420.w;
            final titleSize = w >= 600 ? 36.sp : 32.sp;
            final iconSize = w >= 600 ? 140.w : 120.w;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(foregroundColor: brandGreen),
                      onPressed: () {
                        // TODO: Skip to main experience.
                      },
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, inner) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: inner.maxHeight,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: maxContentWidth,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: iconSize,
                                      height: iconSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFF6FFF9),
                                        border: Border.all(
                                          color: brandGreen.withOpacity(0.25),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: brandGreen.withOpacity(0.20),
                                            blurRadius: 32,
                                            spreadRadius: 2,
                                          ),
                                          const BoxShadow(
                                            color: Color(0x14000000),
                                            blurRadius: 18,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.battery_full_rounded,
                                        size: w >= 600 ? 62 : 56,
                                        color: brandGreen,
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                    Text(
                                      'PackPulse',
                                      style: TextStyle(
                                        fontSize: titleSize,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0C1410),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'Smart LiPo Health &\nPerformance Tracking',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: const Color(0xFF5B6A62),
                                        height: 1.4,
                                      ),
                                    ),
                                    SizedBox(height: 56.h),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: brandGreen,
                                          foregroundColor: Colors.black,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 18.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // TODO: Navigate to onboarding / auth flow.
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward_rounded,
                                        ),
                                        label: Text(
                                          'Get Started',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0x22000000),
                                          ),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 18.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          foregroundColor: const Color(
                                            0xFF0C1410,
                                          ),
                                        ),
                                        onPressed: () {
                                          // TODO: Show more information / tour.
                                        },
                                        child: Text(
                                          'Learn More',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      'By continuing, you agree to our Terms & Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF0C1410).withOpacity(0.5),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
