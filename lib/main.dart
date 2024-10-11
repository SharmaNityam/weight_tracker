import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/blocs/weight_bloc.dart';
import 'package:weight_tracker/blocs/settings_bloc.dart';
import 'package:weight_tracker/repositories/weight_repository.dart';
import 'package:weight_tracker/repositories/settings_repository.dart';
import 'package:weight_tracker/screens/home_screen.dart';
import 'package:weight_tracker/screens/setup_screen.dart';
import 'package:weight_tracker/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  
  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;

  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  const MyApp({Key? key, required this.isFirstRun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeightBloc>(
          create: (context) => WeightBloc(WeightRepository()),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(SettingsRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Weight Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.teal,
            accentColor: Colors.tealAccent,
          ),
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.teal,
            elevation: 0,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: isFirstRun ? SetupScreen() : HomeScreen(),
      ),
    );
  }
}