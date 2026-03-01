import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:packpulse/presentation/view/home/add_battery_view.dart';
import 'package:packpulse/presentation/view/home/widgets/active_packs_widget.dart';
import 'package:packpulse/presentation/view/home/widgets/fleet_health_score_widget.dart';
import 'package:packpulse/presentation/view/home/widgets/home_header_items_widget.dart';
import 'package:packpulse/presentation/view/home/widgets/no_battery_empty_state_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  int _selectedNavIndex = 0;

  final List<({String label, int count, HeaderItemType type})> _headerItems = [
    (label: 'Total', count: 42, type: HeaderItemType.total),
    (label: 'Healthy', count: 35, type: HeaderItemType.healthy),
    (label: 'Warning', count: 5, type: HeaderItemType.warning),
    (label: 'Danger', count: 2, type: HeaderItemType.danger),
  ];

  // Set to empty to see empty state, populate to see normal state
  final List<BatteryPack> packs = [
    // BatteryPack(
    //   name: 'ThunderPower #04',
    //   specs: '6S 1300mAh • 120C',
    //   status: PackStatus.healthy,
    //   healthPercent: 92,
    //   sag: 0.24,
    //   avgIr: 3.2,
    //   lastFlight: '2h ago',
    // ),
  ];

  bool get _hasPacks => packs.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: _hasPacks ? _buildPacksContent() : _buildEmptyContent(),
      floatingActionButton: !_hasPacks
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AddNewBatteryView(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF00C853),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────

  Widget _buildEmptyContent() {
    return SingleChildScrollView(
      child: NoBatteriesEmptyState(
        onAddPack: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddNewBatteryView(),
            ),
          );
        },
        onLearnMore: () {},
      ),
    );
  }

  // ── Packs Content ───────────────────────────────────────────────────────────

  Widget _buildPacksContent() {
    return ListView(
      children: [
        SizedBox(height: 10.h),

        // Header filter chips
        SizedBox(
          height: 50.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: List.generate(_headerItems.length, (index) {
                final item = _headerItems[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < _headerItems.length - 1 ? 8.w : 0,
                  ),
                  child: HomeHeaderItem(
                    label: item.label,
                    count: item.count,
                    type: item.type,
                    isSelected: _selectedIndex == index,
                    onTap: () => setState(() => _selectedIndex = index),
                  ),
                );
              }),
            ),
          ),
        ),

        SizedBox(height: 10.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: FleetHealthScoreWidget(score: 100.0),
        ),

        SizedBox(height: 16.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ActivePacksWidget(packs: packs, onViewAll: () {}),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }

  // ── Bottom Nav ──────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    final items = [
      (icon: Icons.dashboard_rounded, label: 'DASHBOARD'),
      (icon: Icons.battery_charging_full_rounded, label: 'DEVICES'),
      (icon: Icons.bar_chart_rounded, label: 'ANALYTICS'),
      (icon: Icons.settings_rounded, label: 'SETTINGS'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = _selectedNavIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedNavIndex = i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 24,
                        color: isActive
                            ? const Color(0xFF00C853)
                            : const Color(0xFF9E9E9E),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? const Color(0xFF00C853)
                              : const Color(0xFF9E9E9E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
