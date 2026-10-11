import 'dart:async';

import 'package:flutter/foundation.dart';

import 'progress_service.dart';
import 'distraction_service.dart';

class StudySessionService {
  static Timer? _timer;

  static DateTime? _endTime;

  static int seconds = 0;

  static int totalSeconds = 0;

  static bool isRunning = false;

  static final ValueNotifier<int> timeNotifier =
      ValueNotifier<int>(0);

  // ============================================================
  // START STUDY SESSION
  // ============================================================

  static void startSession(int minutes) {
    if (minutes <= 0) {
      return;
    }

    // Stop any old timer safely.
    _timer?.cancel();

    final now = DateTime.now();

    seconds = minutes * 60;

    totalSeconds = minutes * 60;

    _endTime = now.add(
      Duration(minutes: minutes),
    );

    isRunning = true;

    timeNotifier.value = seconds;

    _startTicker();

    print("========================================");
    print("STUDY TIMER STARTED");
    print("Duration : $minutes minutes");
    print("========================================");
  }

  // ============================================================
  // TIMER TICKER
  // ============================================================

  static void _startTicker() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_endTime == null) {
          timer.cancel();

          _timer = null;

          return;
        }

        final remaining = _endTime!
            .difference(DateTime.now())
            .inSeconds;

        // --------------------------------------------------------
        // STUDY SESSION COMPLETED
        // --------------------------------------------------------

        if (remaining <= 0) {
          seconds = 0;

          timeNotifier.value = 0;

          isRunning = false;

          timer.cancel();

          _timer = null;

          _endTime = null;

          print("========================================");
          print("STUDY SESSION COMPLETED");
          print("TIMER REACHED 00:00");
          print("STOPPING DISTRACTION MONITORING");
          print("========================================");

          // ------------------------------------------------------
          // COMPLETE PROGRESS
          // ------------------------------------------------------

          ProgressService.completeTopic();

          ProgressService.addStudyHour();

          // ------------------------------------------------------
          // VERY IMPORTANT
          //
          // Stop distraction monitoring automatically when the
          // selected study duration is completed.
          // ------------------------------------------------------

          DistractionService.stopSession();

          return;
        }

        // --------------------------------------------------------
        // UPDATE REMAINING TIME
        // --------------------------------------------------------

        seconds = remaining;

        timeNotifier.value = seconds;
      },
    );
  }

  // ============================================================
  // RESUME SESSION
  // ============================================================

  static void resumeSession() {
    if (seconds <= 0) {
      return;
    }

    if (isRunning) {
      return;
    }

    _endTime = DateTime.now().add(
      Duration(seconds: seconds),
    );

    isRunning = true;

    timeNotifier.value = seconds;

    _startTicker();

    print("========================================");
    print("STUDY SESSION RESUMED");
    print("Remaining : $seconds seconds");
    print("========================================");
  }

  // ============================================================
  // PAUSE SESSION
  // ============================================================

  static void pauseSession() {
    if (_endTime != null) {
      final remaining = _endTime!
          .difference(DateTime.now())
          .inSeconds;

      seconds = remaining > 0 ? remaining : 0;
    }

    _timer?.cancel();

    _timer = null;

    isRunning = false;

    timeNotifier.value = seconds;

    print("========================================");
    print("STUDY SESSION PAUSED");
    print("Remaining : $seconds seconds");
    print("========================================");
  }

  // ============================================================
  // STOP SESSION
  // ============================================================

  static void stopSession() {
    _timer?.cancel();

    _timer = null;

    _endTime = null;

    seconds = 0;

    isRunning = false;

    timeNotifier.value = 0;

    print("========================================");
    print("STUDY SESSION STOPPED");
    print("========================================");
  }

  // ============================================================
  // GET TIME
  // ============================================================

  static String getTime() {
    final minutes = seconds ~/ 60;

    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // TOTAL MINUTES
  // ============================================================

  static int get totalMinutes {
    return totalSeconds ~/ 60;
  }

  // ============================================================
  // TOTAL HOURS
  // ============================================================

  static int get totalHours {
    return totalSeconds ~/ 3600;
  }
}