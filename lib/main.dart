import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/my_contents_screen.dart';
import 'screens/add_content_screen.dart';
import 'service/auth_service.dart';

// ✅ ENTRY POINT
void main() {
  runApp(const MyTeamApp());
}

class MyTeamApp extends StatelessWidget {
  const MyTeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuth()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, _) {
          return MaterialApp(
            title: 'Link Keep App',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'NotoSansKhmer',
              scaffoldBackgroundColor: Colors.greenAccent,
            ),
            darkTheme: ThemeData.dark(),
            // 👇 Start with SplashScreen first
            home: SplashScreen(authProvider: authProvider),
          );
        },
      ),
    );
  }
}

// ✅ SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  final AuthProvider authProvider;
  const SplashScreen({super.key, required this.authProvider});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 5));

    // Go to login or main navigation based on authentication
    if (widget.authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(token: widget.authProvider.token),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/Keep-Logo.png'),
              // backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 20),
            // App Name
            const Text(
              'Link Keep App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle (optional)
            const Text(
              'Manage and Save Your Favorite Links',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ APP BACKGROUND WRAPPER
class AppBackgroundWrapper extends StatelessWidget {
  final Widget child;
  const AppBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(color: Colors.grey[100]),

        // Faded logo watermark
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/Keep-Logo.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),

        // Foreground content
        child,
      ],
    );
  }
}

// ✅ MAIN NAVIGATION
class MainNavigation extends StatefulWidget {
  final String token;
  const MainNavigation({required this.token});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;
  int? _teamId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamIdAndSetup();
  }

  Future<void> _loadTeamIdAndSetup() async {
    final authService = AuthService();
    final teamId = await authService.getUserTeamId();

    setState(() {
      _teamId = teamId ?? 0;
      _loading = false;
      _buildScreensAndNavItems();
    });
  }

  void _buildScreensAndNavItems() {
    _screens = [
      DashboardScreen(),
      AddContentScreen(),
      MyContentsScreen(),
      //MemberListScreen(token: widget.token),
      //if (_teamId == 1) StudentListScreen(token: widget.token),
      //ActivityListScreen(token: widget.token),
      //PaymentListScreen(token: widget.token),
      //DocumentListScreen(token: widget.token),
      SettingsScreen(token: widget.token),
    ];

    _navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
      //if (_teamId == 1)
        const BottomNavigationBarItem(icon: Icon(Icons.content_paste_go_rounded), label: 'Content'),
      //const BottomNavigationBarItem(icon: Icon(Icons.event), label: 'សកម្មភាព'),
      //const BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'ការបង់ប្រាក់'),
      //const BottomNavigationBarItem(
        //  icon: Icon(Icons.document_scanner_rounded), label: 'ឯកសារ'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
    ];

    if (_currentIndex >= _screens.length) {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: AppBackgroundWrapper(child: _screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
