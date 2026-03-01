import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

enum PackStatus { healthy, warning, critical, unknown }

class BatteryPack {
  final String name;
  final String specs; // e.g. "6S 1300mAh • 120C"
  final PackStatus status;
  final double healthPercent; // 0–100
  final double sag; // volts
  final double avgIr; // mΩ
  final String lastFlight; // e.g. "2h ago"

  const BatteryPack({
    required this.name,
    required this.specs,
    required this.status,
    required this.healthPercent,
    required this.sag,
    required this.avgIr,
    required this.lastFlight,
  });
}

// ─── Active Packs Section ─────────────────────────────────────────────────────

class ActivePacksWidget extends StatelessWidget {
  final List<BatteryPack> packs;
  final VoidCallback? onViewAll;

  const ActivePacksWidget({super.key, required this.packs, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Packs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00C853),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Pack cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: packs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _PackCard(pack: packs[index]),
        ),
      ],
    );
  }
}

// ─── Single Pack Card ─────────────────────────────────────────────────────────

class _PackCard extends StatelessWidget {
  final BatteryPack pack;

  const _PackCard({required this.pack});

  @override
  Widget build(BuildContext context) {
    final statusTheme = _StatusTheme.from(pack.status);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0.w,
        top: 10.h,
        right: 16.0.w,
        bottom: 10.0.h,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: name + status badge + health%
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + specs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pack.specs,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge + health
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusTheme.bgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusTheme.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusTheme.textColor,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Health percent
                    Text(
                      '${pack.healthPercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: statusTheme.textColor,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Divider
            Container(height: 1, color: const Color(0xFFF0F0F0)),

            const SizedBox(height: 12),

            // Stats row
            Row(
              children: [
                _StatItem(
                  label: 'SAG',
                  value: '${pack.sag.toStringAsFixed(2)}V',
                ),
                const SizedBox(width: 28),
                _StatItem(
                  label: 'AVG IR',
                  value: '${pack.avgIr.toStringAsFixed(1)}mΩ',
                ),
                const Spacer(),
                _StatItem(
                  label: 'LAST FLIGHT',
                  value: pack.lastFlight,
                  alignRight: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;

  const _StatItem({
    required this.label,
    required this.value,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.35),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

// ─── Status Theme ─────────────────────────────────────────────────────────────

class _StatusTheme {
  final Color bgColor;
  final Color textColor;
  final String label;

  const _StatusTheme({
    required this.bgColor,
    required this.textColor,
    required this.label,
  });

  factory _StatusTheme.from(PackStatus status) {
    switch (status) {
      case PackStatus.healthy:
        return const _StatusTheme(
          bgColor: Color(0xFFE8F5E9),
          textColor: Color(0xFF2E7D32),
          label: 'HEALTHY',
        );
      case PackStatus.warning:
        return const _StatusTheme(
          bgColor: Color(0xFFFFF3E0),
          textColor: Color(0xFFE65100),
          label: 'WARNING',
        );
      case PackStatus.critical:
        return const _StatusTheme(
          bgColor: Color(0xFFFFEBEE),
          textColor: Color(0xFFC62828),
          label: 'CRITICAL',
        );
      case PackStatus.unknown:
        return const _StatusTheme(
          bgColor: Color(0xFFF5F5F5),
          textColor: Color(0xFF757575),
          label: 'UNKNOWN',
        );
    }
  }
}

// ─── Demo ─────────────────────────────────────────────────────────────────────

void main() {
  runApp(const _DemoApp());
}

class _DemoApp extends StatelessWidget {
  const _DemoApp();

  @override
  Widget build(BuildContext context) {
    const packs = [
      BatteryPack(
        name: 'ThunderPower #04',
        specs: '6S 1300mAh • 120C',
        status: PackStatus.healthy,
        healthPercent: 92,
        sag: 0.24,
        avgIr: 3.2,
        lastFlight: '2h ago',
      ),
      BatteryPack(
        name: 'Tattu R-Line #12',
        specs: '6S 1300mAh • 150C',
        status: PackStatus.warning,
        healthPercent: 78,
        sag: 0.48,
        avgIr: 5.8,
        lastFlight: 'Yesterday',
      ),
      BatteryPack(
        name: 'Lumenier #07',
        specs: '6S 1300mAh • 100C',
        status: PackStatus.healthy,
        healthPercent: 94,
        sag: 0.18,
        avgIr: 2.9,
        lastFlight: '4d ago',
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF0F2F5)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PackPulse',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1A2E),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ActivePacksWidget(packs: packs, onViewAll: () {}),
        ),
      ),
    );
  }
}
