import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:packpulse/injection.dart';
import 'package:packpulse/presentation/view/home_menu/home_menu_view.dart';
import 'package:packpulse/presentation/view/starter/starter_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.init();
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
          home: const _InitialRoute(),
        );
      },
    );
  }
}

/// Decides initial route: Starter (onboarding) or Home.
/// Onboarding shows only when app is first opened or setup not completed.
class _InitialRoute extends StatelessWidget {
  const _InitialRoute();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Injection.onboardingCacheUseCase.isOnboardingCompleted(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final completed = snapshot.data ?? false;
        return completed ? HomeMenuView() : const StarterView();
      },
    );
  }
}
