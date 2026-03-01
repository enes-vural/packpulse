import 'package:flutter/material.dart';

class NoBatteriesEmptyState extends StatelessWidget {
  final VoidCallback? onAddPack;
  final VoidCallback? onLearnMore;

  const NoBatteriesEmptyState({super.key, this.onAddPack, this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // ── Illustration ──
          _IllustrationWidget(),

          const SizedBox(height: 40),

          // ── Title ──
          const Text(
            'No batteries found',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 14),

          // ── Description ──
          Text(
            'Start tracking your battery health by adding your first pack. Connect via Bluetooth or manual entry to get real-time insights.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withOpacity(0.45),
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 36),

          // ── Add Button ──
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onAddPack,
              icon: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
              label: const Text(
                'Add Your First Pack',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Learn More ──
          GestureDetector(
            onTap: onLearnMore,
            child: const Text(
              'Learn how to connect',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00C853),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Illustration ─────────────────────────────────────────────────────────────

class _IllustrationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow circle
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C853).withOpacity(0.07),
            ),
          ),

          // Middle circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C853).withOpacity(0.08),
            ),
          ),

          // White card
          Positioned(
            top: 20,
            left: 30,
            right: 0,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Battery icon with question mark
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.battery_full_rounded,
                        size: 72,
                        color: const Color(0xFF00C853).withOpacity(0.5),
                      ),
                      const Positioned(
                        bottom: 14,
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF00C853),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Skeleton lines
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 8,
                              width: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C853).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              height: 8,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bluetooth icon (top right)
          Positioned(
            top: 16,
            right: 8,
            child: Icon(
              Icons.bluetooth,
              size: 22,
              color: const Color(0xFF00C853).withOpacity(0.7),
            ),
          ),

          // Signal icon (left)
          Positioned(
            left: 8,
            bottom: 50,
            child: Icon(
              Icons.sensors_rounded,
              size: 26,
              color: const Color(0xFF00C853).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
