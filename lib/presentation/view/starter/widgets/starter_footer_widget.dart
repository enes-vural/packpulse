import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarterFooterWidget extends StatelessWidget {
  const StarterFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        'By continuing, you agree to our Terms & Privacy Policy',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF0C1410).withOpacity(0.5),
          height: 1.4,
        ),
      ),
    );
  }
}

