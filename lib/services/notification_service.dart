import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'study_guardian_alarm_channel';
  static const String channelName = 'Study Guardian';
  static const String channelDescription =
      'Study Guardian distraction reminders';

  static const int immediateNotificationId = 999;
  static const int reminderNotificationId = 1000;

  static const MethodChannel _channel =
      MethodChannel('study_guardian/full_screen');

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(settings);

    await _createChannel();

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    print('========================================');
    print('NOTIFICATION SERVICE INITIALIZED');
    print('IMMEDIATE NORMAL NOTIFICATION: ENABLED');
    print('30 SECOND NORMAL NOTIFICATION: ENABLED');
    print('FULL SCREEN METHOD: AVAILABLE');
    print('========================================');
  }

  // ============================================================
  // BACKGROUND INITIALIZE
  // ============================================================

  static Future<void> initializeForBackground() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(settings);

    await _createChannel();

    print('========================================');
    print('BACKGROUND NOTIFICATION SERVICE INITIALIZED');
    print('========================================');
  }

  // ============================================================
  // CREATE CHANNEL
  // ============================================================

  static Future<void> _createChannel() async {
    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ============================================================
  // NOTIFICATION PERMISSION
  // ============================================================

  static Future<bool> isNotificationEnabled() async {
    try {
      final status = await Permission.notification.status;
      return status.isGranted;
    } catch (e) {
      print('NOTIFICATION PERMISSION ERROR: $e');
      return false;
    }
  }

  // ============================================================
  // OPEN NOTIFICATION SETTINGS
  // ============================================================

  static Future<void> openNotificationSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('OPEN SETTINGS ERROR: $e');
    }
  }

  // ============================================================
  // COMMON NOTIFICATION DETAILS
  // ============================================================

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    visibility: NotificationVisibility.public,
    category: AndroidNotificationCategory.reminder,
  );

  static const NotificationDetails _notificationDetails =
      NotificationDetails(
    android: _androidDetails,
  );

  // ============================================================
  // IMMEDIATE NOTIFICATION
  // ============================================================

  static Future<void> showImmediateNotification() async {
    try {
      await notificationsPlugin.show(
        immediateNotificationId,
        'Study Guardian',
        'You left your study session. Please return to studying.',
        _notificationDetails,
      );

      print('========================================');
      print('IMMEDIATE NORMAL NOTIFICATION SHOWN');
      print('Time Away: 00:00');
      print('FULL SCREEN: NO');
      print('========================================');
    } catch (e, stackTrace) {
      print('========================================');
      print('IMMEDIATE NOTIFICATION ERROR');
      print(e);
      print(stackTrace);
      print('========================================');
    }
  }

  // ============================================================
  // 30 SECOND NORMAL NOTIFICATION
  // ============================================================

  static Future<void> show30SecondReminder() async {
    try {
      await notificationsPlugin.show(
        reminderNotificationId,
        'Study Guardian Reminder',
        'You have been away from your study session for 30 seconds. Please return.',
        _notificationDetails,
      );

      print('========================================');
      print('🔥 30 SECOND NORMAL NOTIFICATION SHOWN');
      print('FULL SCREEN: NO');
      print('========================================');
    } catch (e, stackTrace) {
      print('========================================');
      print('30 SECOND NOTIFICATION ERROR');
      print(e);
      print(stackTrace);
      print('========================================');
    }
  }

  // ============================================================
  // FULL SCREEN REMINDER
  //
  // Kept only for compatibility with existing screens.
  // Current distraction flow uses NORMAL notifications.
  // ============================================================

  static Future<void> showFullScreenReminder({
    String subject = 'Study Session',
    String topic = 'Current Topic',
    String timeAway = '00:00',
  }) async {
    print('========================================');
    print('FULL SCREEN REMINDER REQUESTED');
    print('Subject: $subject');
    print('Topic: $topic');
    print('Time Away: $timeAway');
    print('========================================');

    try {
      await _channel.invokeMethod(
        'openFullScreenReminder',
        {
          'subject': subject,
          'topic': topic,
          'timeAway': timeAway,
        },
      );
    } catch (e) {
      print('FULL SCREEN REMINDER ERROR: $e');
    }
  }

  // ============================================================
  // SCHEDULE REMINDER
  //
  // NOTE:
  // The actual 30-second repeating cycle is handled by
  // android_alarm_manager_plus.
  //
  // This method is retained for compatibility.
  // ============================================================

  static Future<void> scheduleReminder() async {
    print('SCHEDULE REMINDER CALLED');
    print('30 SECOND ALARM IS HANDLED BY ANDROID ALARM MANAGER');
  }

  // ============================================================
  // CANCEL IMMEDIATE
  // ============================================================

  static Future<void> cancelNotification() async {
    try {
      await notificationsPlugin.cancel(
        immediateNotificationId,
      );

      print('IMMEDIATE NOTIFICATION CANCELLED');
    } catch (e) {
      print('CANCEL IMMEDIATE ERROR: $e');
    }
  }

  // ============================================================
  // CANCEL REMINDER
  // ============================================================

  static Future<void> cancelReminder() async {
    try {
      await notificationsPlugin.cancel(
        reminderNotificationId,
      );

      print('30 SECOND REMINDER NOTIFICATION CANCELLED');
    } catch (e) {
      print('CANCEL REMINDER ERROR: $e');
    }
  }

  // ============================================================
  // CANCEL ALL
  // ============================================================

  static Future<void> cancelAllNotifications() async {
    try {
      await notificationsPlugin.cancelAll();

      print('========================================');
      print('ALL STUDY GUARDIAN NOTIFICATIONS CANCELLED');
      print('========================================');
    } catch (e) {
      print('CANCEL ALL ERROR: $e');
    }
  }

  // ============================================================
  // TEST NOTIFICATION
  // ============================================================

  static Future<void> showTestNotification() async {
    try {
      await notificationsPlugin.show(
        5000,
        'Study Guardian Test',
        'Notification system is working.',
        _notificationDetails,
      );

      print('========================================');
      print('TEST NOTIFICATION SHOWN');
      print('========================================');
    } catch (e, stackTrace) {
      print('========================================');
      print('TEST NOTIFICATION ERROR');
      print(e);
      print(stackTrace);
      print('========================================');
    }
  }
}