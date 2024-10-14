import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/blocs/weight_bloc.dart';
import 'package:weight_tracker/blocs/settings_bloc.dart';
import 'package:weight_tracker/repositories/weight_repository.dart';
import 'package:weight_tracker/repositories/settings_repository.dart';
import 'package:weight_tracker/screens/home_screen.dart';
import 'package:weight_tracker/screens/progress_screen.dart';
import 'package:weight_tracker/screens/settings_screen.dart';
import 'package:weight_tracker/services/notification_service.dart';
import 'package:weight_tracker/theme/app_theme.dart';
import 'package:weight_tracker/models/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;

  final settingsRepository = SettingsRepository();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<WeightBloc>(
          create: (context) => WeightBloc(WeightRepository()),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(settingsRepository, notificationService),
        ),
        Provider<NotificationService>.value(value: notificationService),
      ],
      child: MyApp(isFirstRun: isFirstRun),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isFirstRun;

  const MyApp({Key? key, required this.isFirstRun}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, UserSettings>(
      builder: (context, settings) {
        return MaterialApp(
          title: 'Weight Tracker',
          debugShowCheckedModeBanner: false,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: MainScreen(isFirstRun: widget.isFirstRun),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isFirstRun;

  const MainScreen({Key? key, required this.isFirstRun}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      ProgressScreen(),
      SettingsScreen(),
    ];

    if (widget.isFirstRun) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // i have added the below code to expand to the onboarding screen if I need to
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OnboardingScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
