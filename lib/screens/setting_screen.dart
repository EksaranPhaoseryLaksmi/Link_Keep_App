import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/auth_service.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'ChangePasswordScreen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String token;

  SettingsScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  String username = '';
  String email = '';
  final String appVersion = '1.0.0';
  final String developerName = 'EK. LAKSMI';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await _authService.getUser();
    if (user != null) {
      setState(() {
        username = user['name'] ?? '';
        email = user['username'] ?? '';
      });
    }
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/Keep-Logo.png'),
              //backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 8),
            const Text(
              "Setting",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text(username.isNotEmpty ? username : 'Loading...'),
              subtitle: Text(email),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.deepPurple),
                  title: Text('ABOUT US'),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Link Keep Application',
                    applicationVersion: appVersion,
                    children: [Text('Developed By  $developerName')],
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.orange),
                  title: Text('Change Password'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangePasswordScreen(
                          token: widget.token,
                          username: username,
                        ),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('LogOut'),
                  onTap: _logout,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.verified, color: Colors.teal),
                  title: Text('Version'),
                  subtitle: Text(appVersion),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.code, color: Colors.green),
                  title: Text('Developer'),
                  subtitle: Text(developerName),
                ),
                Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(Icons.brightness_6, color: Colors.amber),
                  title: Text('Birght/Dark'),
                  value: themeProvider.isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
