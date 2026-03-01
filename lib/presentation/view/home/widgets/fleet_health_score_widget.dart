import 'package:flutter/material.dart';
import 'dart:math' as math;

enum HealthState { excellent, good, moderate, poor, unknown }

class FleetHealthScoreWidget extends StatelessWidget {
  /// Score value between 0.0 and 100.0
  /// null → unknown state
  final double? score;

  const FleetHealthScoreWidget({super.key, this.score});

  HealthState get _state {
    if (score == null) return HealthState.unknown;
    if (score! >= 85) return HealthState.excellent;
    if (score! >= 65) return HealthState.good;
    if (score! >= 40) return HealthState.moderate;
    return HealthState.poor;
  }

  _HealthTheme get _theme => _HealthTheme.fromState(_state);

  @override
  Widget build(BuildContext context) {
    final theme = _theme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'FLEET HEALTH SCORE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.55),
                  letterSpacing: 1.8,
                ),
              ),

              const SizedBox(height: 24),

              // Full circle arc with score
              _CircleScoreWidget(score: score, theme: theme),

              const SizedBox(height: 20),

              // Status label
              Text(
                theme.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),

              const SizedBox(height: 6),

              // Message
              Text(
                theme.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.65),
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Full Circle Arc ──────────────────────────────────────────────────────────

class _CircleScoreWidget extends StatelessWidget {
  final double? score;
  final _HealthTheme theme;

  const _CircleScoreWidget({required this.score, required this.theme});

  @override
  Widget build(BuildContext context) {
    const size = 180.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(size, size),
            painter: _CircleArcPainter(
              score: score,
              activeColor: theme.color,
              trackColor: const Color(0xFFEEEEEE),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score != null ? score!.toStringAsFixed(0) : '—',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '/ 100',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.35),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleArcPainter extends CustomPainter {
  final double? score;
  final Color activeColor;
  final Color trackColor;

  _CircleArcPainter({
    required this.score,
    required this.activeColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 14;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Full circle track
    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    if (score != null && score! > 0) {
      // Start from top (-π/2), sweep clockwise
      final sweepAngle = 2 * math.pi * (score! / 100);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleArcPainter old) =>
      old.score != score || old.activeColor != activeColor;
}

// ─── Theme ────────────────────────────────────────────────────────────────────

class _HealthTheme {
  final Color color;
  final String label;
  final String message;

  const _HealthTheme({
    required this.color,
    required this.label,
    required this.message,
  });

  factory _HealthTheme.fromState(HealthState state) {
    switch (state) {
      case HealthState.excellent:
        return const _HealthTheme(
          color: Color(0xFF00C853),
          label: 'Mükemmel Durum',
          message: 'Filonuz optimum parametreler\niçinde çalışıyor.',
        );
      case HealthState.good:
        return const _HealthTheme(
          color: Color(0xFF4CAF50),
          label: 'İyi Durum',
          message: 'Filonuz optimum parametreler\niçinde çalışıyor.',
        );
      case HealthState.moderate:
        return const _HealthTheme(
          color: Color(0xFFFFB020),
          label: 'Orta Durum',
          message: 'Bazı bataryalar dikkat\ngerektiriyor.',
        );
      case HealthState.poor:
        return const _HealthTheme(
          color: Color(0xFFFF4D4D),
          label: 'Kötü Durum',
          message: 'Kritik sorunlar mevcut.\nAcilen kontrol edin.',
        );
      case HealthState.unknown:
        return const _HealthTheme(
          color: Color(0xFFBBBBBB),
          label: 'Veri Yok',
          message: 'Bağlantıyı ve sensörleri\nkontrol edin.',
        );
    }
  }
}

// ─── Demo / Preview ───────────────────────────────────────────────────────────
