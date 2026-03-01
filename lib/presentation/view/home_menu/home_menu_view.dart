import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:packpulse/presentation/view/batteries/batteries_view.dart';
import 'package:packpulse/presentation/view/dashboard/dashboard_view.dart';
import 'package:packpulse/presentation/view/home/home_view.dart';
import 'package:packpulse/presentation/view/settings/settings_view.dart';

class HomeMenuView extends StatefulWidget {
  const HomeMenuView({super.key});

  @override
  State<HomeMenuView> createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView> {
  static const Color brandGreen = Color(0xFF00FF5A);

  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
    BottomNavigationBarItem(icon: Icon(Icons.battery_full), label: 'BATTERIES'),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'DASHBOARD'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SETTINGS'),
  ];

  final List<StatefulWidget> _views = [
    const HomeView(),
    const BatteriesView(),
    const DashboardView(),
    const SettingsView(),
  ];

  int _selectedIndex = 0;

  void changeSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    debugPrint('selectedIndex: $_selectedIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          return changeSelectedIndex(value);
        },
        backgroundColor: Colors.white,
        selectedItemColor: brandGreen,
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: _items,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('PackPulse'),
      ),
      body: SafeArea(child: _views[_selectedIndex]),
    );
  }
}
