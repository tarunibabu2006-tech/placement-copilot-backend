import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const CopilotApp(),
    ),
  );
}

class CopilotApp extends StatefulWidget {
  const CopilotApp({Key? key}) : super(key: key);

  @override
  State<CopilotApp> createState() => _CopilotAppState();
}

class _CopilotAppState extends State<CopilotApp> {
  late Future<void> _authInitialization;

  @override
  void initState() {
    super.initState();
    // Verify auto-login session on app load
    _authInitialization = Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Placement Copilot',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFFEC4899),
          surface: Color(0xFF1E1F29),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: FutureBuilder(
        future: _authInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                ),
              ),
            );
          }
          
          final authProvider = Provider.of<AuthProvider>(context);
          if (authProvider.isAuthenticated) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
