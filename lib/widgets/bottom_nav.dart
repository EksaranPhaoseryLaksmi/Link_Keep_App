import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/setting_screen.dart';

class BottomNav extends StatefulWidget {
  final String token; // ✅ Accept token

  const BottomNav({super.key, required this.token});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(token: widget.token),
      MemberListScreen(token: widget.token), // ✅ Pass token here
      ActivityListScreen(token: widget.token),
      PaymentListScreen(token: widget.token),
      SettingsScreen(token: widget.token),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Member'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
