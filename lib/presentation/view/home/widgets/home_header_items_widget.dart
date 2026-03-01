import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum HeaderItemType { total, healthy, warning, danger }

class HeaderColors {
  // Total (nötr / mavi-gri)
  static const Color totalOutline = Color(0xFF6B7280);
  static const Color totalFill = Color(0xFFF3F4F6);
  static const Color totalText = Color(0xFF374151);
  static const Color totalIcon = Color(0xFF6B7280);
  static const Color totalSelectedFill = Color(0xFFF0F1F3);

  static const Color totalSelectedOutline = Color(0xFF374151);

  // Healthy (yeşil)
  static const Color healthyOutline = Color(0xFF22C55E);
  static const Color healthyFill = Color(0xFFECFDF5);
  static const Color healthyText = Color(0xFF16A34A);
  static const Color healthyIcon = Color(0xFF22C55E);
  static const Color healthySelectedFill = Color(
    0xFFECFDF5,
  ); // unselected fill ile neredeyse aynı, çok soft

  // Warning (turuncu)
  static const Color warningOutline = Color(0xFFF59E0B);
  static const Color warningFill = Color(0xFFFFFBEB);
  static const Color warningText = Color(0xFFD97706);
  static const Color warningIcon = Color(0xFFF59E0B);
  static const Color warningSelectedFill = Color(
    0xFFFFFBEB,
  ); // unselected fill ile neredeyse aynı

  // Danger (kırmızı)
  static const Color dangerOutline = Color(0xFFEF4444);
  static const Color dangerFill = Color(0xFFFEF2F2);
  static const Color dangerText = Color(0xFFDC2626);
  static const Color dangerIcon = Color(0xFFEF4444);
  static const Color dangerSelectedFill = Color(
    0xFFFEF2F2,
  ); // unselected fill ile neredeyse aynı
}

class HomeHeaderItem extends StatefulWidget {
  const HomeHeaderItem({
    super.key,
    required this.label,
    required this.count,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final HeaderItemType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<HomeHeaderItem> createState() => _HomeHeaderItemState();
}

class _HomeHeaderItemState extends State<HomeHeaderItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.93,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  // ── Renkler ──
  Color get _outlineColor {
    if (widget.isSelected) {
      return switch (widget.type) {
        HeaderItemType.total => HeaderColors.totalSelectedOutline,
        HeaderItemType.healthy => HeaderColors.healthyOutline,
        HeaderItemType.warning => HeaderColors.warningOutline,
        HeaderItemType.danger => HeaderColors.dangerOutline,
      };
    }
    return switch (widget.type) {
      HeaderItemType.total => HeaderColors.totalOutline,
      HeaderItemType.healthy => HeaderColors.healthyOutline,
      HeaderItemType.warning => HeaderColors.warningOutline,
      HeaderItemType.danger => HeaderColors.dangerOutline,
    };
  }

  Color get _fillColor {
    if (widget.isSelected) {
      return switch (widget.type) {
        HeaderItemType.total => HeaderColors.totalSelectedFill,
        HeaderItemType.healthy => HeaderColors.healthySelectedFill,
        HeaderItemType.warning => HeaderColors.warningSelectedFill,
        HeaderItemType.danger => HeaderColors.dangerSelectedFill,
      };
    }
    return switch (widget.type) {
      HeaderItemType.total => HeaderColors.totalFill,
      HeaderItemType.healthy => HeaderColors.healthyFill,
      HeaderItemType.warning => HeaderColors.warningFill,
      HeaderItemType.danger => HeaderColors.dangerFill,
    };
  }

  Color get _textColor => switch (widget.type) {
    HeaderItemType.total => HeaderColors.totalText,
    HeaderItemType.healthy => HeaderColors.healthyText,
    HeaderItemType.warning => HeaderColors.warningText,
    HeaderItemType.danger => HeaderColors.dangerText,
  };

  Color get _iconColor => switch (widget.type) {
    HeaderItemType.total => HeaderColors.totalIcon,
    HeaderItemType.healthy => HeaderColors.healthyIcon,
    HeaderItemType.warning => HeaderColors.warningIcon,
    HeaderItemType.danger => HeaderColors.dangerIcon,
  };

  IconData get _iconData => switch (widget.type) {
    HeaderItemType.total => Icons.layers_rounded,
    HeaderItemType.healthy => Icons.check_circle,
    HeaderItemType.warning => Icons.warning_amber_rounded,
    HeaderItemType.danger => Icons.cancel_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: _outlineColor,
              width: widget.isSelected ? 1.25 : 1.0,
            ),
            color: _fillColor,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: _outlineColor.withOpacity(
                  widget.isSelected ? 0.15 : 0.08,
                ),

                blurRadius: widget.isSelected ? 8 : 6,

                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_iconData, color: _iconColor, size: 15.sp),
              SizedBox(width: 5.w),
              Text(
                '${widget.count} ${widget.label}',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 13.sp,
                  fontWeight: widget.isSelected
                      ? FontWeight.w700
                      : FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              // Seçili olduğunda küçük bir nokta göster
              if (widget.isSelected) ...[
                SizedBox(width: 5.w),
                Container(
                  width: 5.w,
                  height: 5.w,
                  decoration: BoxDecoration(
                    color: _outlineColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
