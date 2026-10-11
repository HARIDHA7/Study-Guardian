import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'services/notification_service.dart';
import 'services/distraction_service.dart';

import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // TIMEZONE
  // ============================================================

  tz.initializeTimeZones();

  try {
    final String timezone =
        await FlutterTimezone.getLocalTimezone();

    print('========================================');
    print('TIMEZONE INITIALIZED');
    print('TIMEZONE: $timezone');
    print('========================================');
  } catch (e) {
    print('TIMEZONE INITIALIZATION ERROR: $e');
  }

  // ============================================================
  // ANDROID ALARM MANAGER
  // ============================================================

  try {
    final bool initialized =
        await AndroidAlarmManager.initialize();

    print('========================================');
    print('ANDROID ALARM MANAGER INITIALIZED');
    print('RESULT: $initialized');
    print('========================================');
  } catch (e, stackTrace) {
    print('========================================');
    print('ANDROID ALARM MANAGER INITIALIZATION ERROR');
    print(e);
    print(stackTrace);
    print('========================================');
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  try {
    await NotificationService.initialize();
  } catch (e, stackTrace) {
    print('========================================');
    print('NOTIFICATION INITIALIZATION ERROR');
    print(e);
    print(stackTrace);
    print('========================================');
  }

  // ============================================================
  // DISTRACTION SERVICE
  // ============================================================

  try {
    await DistractionService.initialize();
  } catch (e, stackTrace) {
    print('========================================');
    print('DISTRACTION SERVICE INITIALIZATION ERROR');
    print(e);
    print(stackTrace);
    print('========================================');
  }

  // ============================================================
  // APP
  // ============================================================

  runApp(
    const StudyGuardianApp(),
  );
}

class StudyGuardianApp extends StatelessWidget {
  const StudyGuardianApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Guardian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}