import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarterHeroWidget extends StatelessWidget {
  const StarterHeroWidget({
    super.key,
    required this.color,
    required this.iconSize,
    required this.titleSize,
  });

  final Color color;
  final double iconSize;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF6FFF9),
            border: Border.all(
              color: color.withOpacity(0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.20),
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
            size: iconSize * 0.45,
            color: color,
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
      ],
    );
  }
}

