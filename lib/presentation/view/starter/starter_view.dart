import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/starter_hero_widget.dart';
import 'widgets/starter_actions_widget.dart';
import 'widgets/starter_footer_widget.dart';

class StarterView extends StatelessWidget {
  const StarterView({super.key});

  static const Color brandGreen = Color(0xFF00FF5A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final horizontalPadding = width >= 900
                ? 64.w
                : width >= 600
                    ? 48.w
                    : 24.w;
            final maxContentWidth = width >= 900 ? 520.w : 420.w;
            final titleSize = width >= 600 ? 36.sp : 32.sp;
            final iconSize = width >= 600 ? 140.w : 120.w;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, innerConstraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: innerConstraints.maxHeight,
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
                                    StarterHeroWidget(
                                      color: brandGreen,
                                      iconSize: iconSize,
                                      titleSize: titleSize,
                                    ),
                                    SizedBox(height: 56.h),
                                    StarterActionsWidget(
                                      color: brandGreen,
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
                  const StarterFooterWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

