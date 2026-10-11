import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'notification_service.dart';
import 'distraction_history_service.dart';

class DistractionService with WidgetsBindingObserver {
  static const int _distractionAlarmId = 3001;

  static final DistractionService _instance =
      DistractionService._internal();

  factory DistractionService() {
    return _instance;
  }

  DistractionService._internal();

  static bool _sessionActive = false;
  static bool _alarmRunning = false;
  static bool _monitoringSuspended = false;

  static DateTime? _distractionStartTime;

  static String currentSubject = 'Current Subject';
  static String currentTopic = 'Current Topic';

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(_instance);

    print('========================================');
    print('DISTRACTION SERVICE INITIALIZED');
    print('IMMEDIATE -> 30 SEC -> 30 SEC -> 30 SEC');
    print('NORMAL NOTIFICATIONS ONLY');
    print('FULL SCREEN: DISABLED');
    print('========================================');
  }

  // ============================================================
  // START STUDY SESSION
  // ============================================================

  Future<void> startStudySession({
    String subject = 'Current Subject',
    String topic = 'Current Topic',
  }) async {
    currentSubject = subject;
    currentTopic = topic;

    _sessionActive = true;
    _alarmRunning = false;
    _monitoringSuspended = false;
    _distractionStartTime = null;

    await _cancelAlarm();

    try {
      await NotificationService.cancelAllNotifications();
    } catch (e) {
      print('FAILED TO CLEAR OLD NOTIFICATIONS: $e');
    }

    print('========================================');
    print('STUDY SESSION STARTED');
    print('Subject: $currentSubject');
    print('Topic: $currentTopic');
    print('DISTRACTION MONITORING: ON');
    print('========================================');
  }

  // ============================================================
  // STATIC START SESSION
  // ============================================================

  static void startSession({
    required String subject,
    required String topic,
  }) {
    currentSubject = subject;
    currentTopic = topic;

    _sessionActive = true;
    _alarmRunning = false;
    _monitoringSuspended = false;
    _distractionStartTime = null;

    unawaited(_cancelAlarm());

    print('========================================');
    print('STUDY SESSION STARTED');
    print('Subject: $currentSubject');
    print('Topic: $currentTopic');
    print('DISTRACTION MONITORING: ON');
    print('========================================');
  }

  // ============================================================
  // SUSPEND
  // ============================================================

  static Future<void> suspendMonitoring() async {
    _monitoringSuspended = true;
    _alarmRunning = false;
    _distractionStartTime = null;

    print('========================================');
    print('DISTRACTION MONITORING SUSPENDED');
    print('UPLOAD / READING MODE');
    print('========================================');

    await _cancelAlarm();

    await NotificationService.cancelNotification();
    await NotificationService.cancelReminder();
  }

  // ============================================================
  // RESUME
  // ============================================================

  static void resumeMonitoring() {
    _monitoringSuspended = false;

    print('========================================');
    print('DISTRACTION MONITORING RESUMED');
    print('========================================');
  }

  // ============================================================
  // APP BACKGROUNDED
  // ============================================================

  void onAppBackgrounded() {
    if (!_sessionActive) {
      return;
    }

    if (_monitoringSuspended) {
      print('BACKGROUND IGNORED - MONITORING SUSPENDED');
      return;
    }

    if (!_alarmRunning) {
      unawaited(startDistraction());
    }
  }

  // ============================================================
  // APP RESUMED
  // ============================================================

  void onAppResumed() {
    if (!_sessionActive) {
      return;
    }

    if (_alarmRunning) {
      unawaited(endDistraction());
    }
  }

  // ============================================================
  // START DISTRACTION
  // ============================================================

  static Future<void> startDistraction() async {
    if (!_sessionActive) {
      return;
    }

    if (_monitoringSuspended) {
      return;
    }

    if (_alarmRunning) {
      return;
    }

    _alarmRunning = true;
    _distractionStartTime = DateTime.now();

    print('========================================');
    print('DISTRACTION CYCLE STARTED');
    print(
      'TIME: ${_distractionStartTime!.toIso8601String()}',
    );
    print('========================================');

    // ----------------------------------------------------------
    // IMMEDIATE NORMAL NOTIFICATION
    // ----------------------------------------------------------

    try {
      await NotificationService.showImmediateNotification();

      print('========================================');
      print('IMMEDIATE NORMAL NOTIFICATION SENT');
      print('TIME AWAY: 00:00');
      print('NEXT REMINDER: 00:30');
      print('FULL SCREEN: DISABLED');
      print('========================================');
    } catch (e) {
      print('FAILED TO SHOW IMMEDIATE NOTIFICATION: $e');
    }

    // ----------------------------------------------------------
    // FIRST 30 SECOND ALARM
    // ----------------------------------------------------------

    await _scheduleNextAlarm();
  }

  // ============================================================
  // BACKGROUND ALARM CALLBACK
  // ============================================================

  @pragma('vm:entry-point')
  static Future<void> distractionAlarmCallback() async {
    DartPluginRegistrant.ensureInitialized();

    print('========================================');
    print('🔥 30 SECOND DISTRACTION ALARM FIRED');
    print('========================================');

    try {
      await NotificationService.initializeForBackground();

      await NotificationService.show30SecondReminder();

      print('========================================');
      print('✅ 30 SECOND NORMAL NOTIFICATION SHOWN');
      print('FULL SCREEN: DISABLED');
      print('========================================');

      final bool scheduled =
          await AndroidAlarmManager.oneShot(
        const Duration(seconds: 30),
        _distractionAlarmId,
        distractionAlarmCallback,
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
        rescheduleOnReboot: false,
      );

      print('========================================');
      print('NEXT 30 SECOND ALARM SCHEDULED');
      print('Scheduled: $scheduled');
      print('========================================');
    } catch (e, stackTrace) {
      print('========================================');
      print('❌ DISTRACTION BACKGROUND ALARM ERROR');
      print(e);
      print(stackTrace);
      print('========================================');
    }
  }

  // ============================================================
  // SCHEDULE NEXT ALARM
  // ============================================================

  static Future<void> _scheduleNextAlarm() async {
    try {
      await AndroidAlarmManager.cancel(
        _distractionAlarmId,
      );

      final bool scheduled =
          await AndroidAlarmManager.oneShot(
        const Duration(seconds: 30),
        _distractionAlarmId,
        distractionAlarmCallback,
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
        rescheduleOnReboot: false,
      );

      print('========================================');
      print('30 SECOND ALARM CREATED');
      print('Scheduled: $scheduled');
      print('Subject: $currentSubject');
      print('Topic: $currentTopic');
      print('NEXT REMINDER: 00:30');
      print('========================================');

      if (!scheduled) {
        print('⚠ ANDROID DID NOT ACCEPT THE ALARM');
      }
    } catch (e, stackTrace) {
      print('========================================');
      print('❌ FAILED TO SCHEDULE 30 SECOND ALARM');
      print(e);
      print(stackTrace);
      print('========================================');

      _alarmRunning = false;
      _distractionStartTime = null;
    }
  }

  // ============================================================
  // END DISTRACTION
  // ============================================================

  static Future<void> endDistraction() async {
    final DateTime? startTime = _distractionStartTime;

    _alarmRunning = false;
    _distractionStartTime = null;

    await _cancelAlarm();

    await NotificationService.cancelReminder();
    await NotificationService.cancelNotification();

    if (startTime != null) {
      final Duration awayDuration =
          DateTime.now().difference(startTime);

      try {
        DistractionHistoryService.addDistraction(
          topic: currentTopic,
          duration: awayDuration.inSeconds,
        );
      } catch (e) {
        print('FAILED TO SAVE DISTRACTION HISTORY: $e');
      }

      print('========================================');
      print('USER RETURNED TO STUDY GUARDIAN');
      print(
        'TIME AWAY: ${_formatDuration(awayDuration)}',
      );
      print('30 SECOND ALARM CANCELLED');
      print('ALL DISTRACTION REMINDERS STOPPED');
      print('========================================');
    }
  }

  // ============================================================
  // END STUDY SESSION
  // ============================================================

  Future<void> endStudySession() async {
    _sessionActive = false;
    _monitoringSuspended = false;

    await endDistraction();

    await NotificationService.cancelAllNotifications();

    print('========================================');
    print('STUDY SESSION ENDED');
    print('DISTRACTION MONITORING: OFF');
    print('========================================');
  }

  // ============================================================
  // STATIC STOP SESSION
  // ============================================================

  static Future<void> stopSession() async {
    _sessionActive = false;
    _monitoringSuspended = false;

    await endDistraction();

    await NotificationService.cancelAllNotifications();

    print('========================================');
    print('STUDY SESSION ENDED');
    print('DISTRACTION MONITORING: OFF');
    print('========================================');
  }

  // ============================================================
  // CANCEL ALARM
  // ============================================================

  static Future<void> _cancelAlarm() async {
    try {
      await AndroidAlarmManager.cancel(
        _distractionAlarmId,
      );

      print('========================================');
      print('30 SECOND DISTRACTION ALARM CANCELLED');
      print('========================================');
    } catch (e) {
      print('FAILED TO CANCEL DISTRACTION ALARM: $e');
    }
  }

  // ============================================================
  // APP LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (!_sessionActive) {
      return;
    }

    print(
      'APP LIFECYCLE STATE: ${state.name}',
    );

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if (!_monitoringSuspended && !_alarmRunning) {
        unawaited(startDistraction());
      }

      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (_alarmRunning) {
        unawaited(endDistraction());
      }
    }
  }

  // ============================================================
  // TIME AWAY
  // ============================================================

  static String currentTimeAway() {
    if (_distractionStartTime == null) {
      return '00:00';
    }

    final Duration duration =
        DateTime.now().difference(
      _distractionStartTime!,
    );

    return _formatDuration(duration);
  }

  // ============================================================
  // FORMAT
  // ============================================================

  static String _formatDuration(
    Duration duration,
  ) {
    final int totalSeconds = duration.inSeconds;

    final int hours = totalSeconds ~/ 3600;

    final int minutes =
        (totalSeconds % 3600) ~/ 60;

    final int seconds =
        totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // STATUS
  // ============================================================

  static bool get isSessionActive {
    return _sessionActive;
  }

  static bool get isDistractionActive {
    return _alarmRunning;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  static void dispose() {
    WidgetsBinding.instance.removeObserver(
      _instance,
    );
  }
}