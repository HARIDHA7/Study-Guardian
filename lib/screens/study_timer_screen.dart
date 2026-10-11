import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/distraction_service.dart';
import '../services/notification_service.dart';
import '../services/study_session_service.dart';

import 'study_reader_screen.dart';

class StudyTimerScreen extends StatefulWidget {
  final Note? note;

  const StudyTimerScreen({
    super.key,
    this.note,
  });

  @override
  State<StudyTimerScreen> createState() =>
      _StudyTimerScreenState();
}

class _StudyTimerScreenState extends State<StudyTimerScreen>
    with WidgetsBindingObserver {
  // ============================================================
  // SERVICES
  // ============================================================

  final DistractionService _distractionService =
      DistractionService();

  // ============================================================
  // STATE
  // ============================================================

  bool isReadingFile = false;

  bool _durationSelected = false;

  bool _completingSession = false;

  int? selectedDuration;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDurationSelection();
    });
  }

  // ============================================================
  // APP LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    super.didChangeAppLifecycleState(state);

    if (!_durationSelected || _completingSession) {
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      print('========================================');
      print('STUDY GUARDIAN APP BACKGROUNDED');
      print('STARTING DISTRACTION MONITORING');
      print('========================================');

      _distractionService.onAppBackgrounded();
    } else if (state == AppLifecycleState.resumed) {
      print('========================================');
      print('STUDY GUARDIAN APP RESUMED');
      print('STOPPING DISTRACTION MONITORING');
      print('========================================');

      _distractionService.onAppResumed();
    }
  }

  // ============================================================
  // SHOW STUDY DURATION
  // ============================================================

  Future<void> _showDurationSelection() async {
    if (!mounted || _durationSelected) {
      return;
    }

    final duration = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Choose Study Duration',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How long do you want to study?',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              _durationButton(
                context,
                '15 Minutes',
                15,
              ),

              _durationButton(
                context,
                '25 Minutes',
                25,
              ),

              _durationButton(
                context,
                '30 Minutes',
                30,
              ),

              _durationButton(
                context,
                '45 Minutes',
                45,
              ),

              _durationButton(
                context,
                '60 Minutes',
                60,
              ),

              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: () async {
                  final customDuration =
                      await _showCustomDurationDialog(context);

                  if (customDuration != null &&
                      context.mounted) {
                    Navigator.pop(
                      context,
                      customDuration,
                    );
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Custom Duration'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || duration == null) {
      return;
    }

    selectedDuration = duration;
    _durationSelected = true;

    // ----------------------------------------------------------
    // START STUDY TIMER
    // ----------------------------------------------------------

    StudySessionService.startSession(duration);

    // ----------------------------------------------------------
    // START DISTRACTION MONITORING
    // ----------------------------------------------------------

    await _distractionService.startStudySession();

    print('========================================');
    print('STUDY SESSION STARTED');
    print('Duration: $duration minutes');
    print('Distraction monitoring ACTIVE');
    print('========================================');

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // DURATION BUTTON
  // ============================================================

  Widget _durationButton(
    BuildContext context,
    String title,
    int minutes,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              minutes,
            );
          },
          child: Text(title),
        ),
      ),
    );
  }

  // ============================================================
  // CUSTOM DURATION
  // ============================================================

  Future<int?> _showCustomDurationDialog(
    BuildContext context,
  ) async {
    final controller = TextEditingController();

    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Custom Duration'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutes',
              hintText: 'Example: 40',
              suffixText: 'min',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final minutes = int.tryParse(
                  controller.text.trim(),
                );

                if (minutes == null || minutes <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid duration.',
                      ),
                    ),
                  );

                  return;
                }

                if (minutes > 180) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Maximum study duration is 180 minutes.',
                      ),
                    ),
                  );

                  return;
                }

                Navigator.pop(
                  context,
                  minutes,
                );
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
  }

  // ============================================================
  // SHOW EXIT NOTIFICATION
  // ============================================================

  Future<void> _showExitNotification() async {
    if (!_durationSelected) {
      return;
    }

    await NotificationService.showFullScreenReminder(
      subject: widget.note?.subject ?? 'Study Session',
      topic: widget.note?.unit ?? 'Current Topic',
      timeAway: '00:00',
    );

    print('========================================');
    print('STUDY SCREEN EXIT NOTIFICATION SHOWN');
    print('========================================');
  }

  // ============================================================
  // OPEN STUDY FILE
  // ============================================================

  Future<void> openFile() async {
    if (widget.note == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No study file found.',
          ),
        ),
      );

      return;
    }

    isReadingFile = true;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudyReaderScreen(
          note: widget.note!,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    isReadingFile = false;

    if (_durationSelected && !_completingSession) {
      print('========================================');
      print('USER RETURNED FROM STUDY READER');
      print('========================================');

      await _showExitNotification();
    }
  }

  // ============================================================
  // COMPLETE STUDY SESSION
  // ============================================================

  Future<void> _completeSession() async {
    if (_completingSession) {
      return;
    }

    _completingSession = true;

    // ----------------------------------------------------------
    // STOP STUDY TIMER
    // ----------------------------------------------------------

    StudySessionService.stopSession();

    // ----------------------------------------------------------
    // STOP DISTRACTION MONITORING
    // ----------------------------------------------------------

    await _distractionService.endStudySession();

    await NotificationService.cancelReminder();

    await NotificationService.cancelNotification();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // ============================================================
  // BACK FROM STUDY TIMER
  // ============================================================

  Future<void> _handleBack() async {
    if (_completingSession) {
      return;
    }

    if (!_durationSelected) {
      if (mounted) {
        Navigator.pop(context);
      }

      return;
    }

    print('========================================');
    print('USER LEFT STUDY TIMER SCREEN');
    print('STOPPING STUDY SESSION');
    print('========================================');

    // ----------------------------------------------------------
    // STOP STUDY TIMER
    // ----------------------------------------------------------

    StudySessionService.stopSession();

    // ----------------------------------------------------------
    // STOP DISTRACTION MONITORING
    // ----------------------------------------------------------

    await _distractionService.endStudySession();

    // ----------------------------------------------------------
    // SHOW INTENTIONAL EXIT REMINDER
    // ----------------------------------------------------------

    await _showExitNotification();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (_durationSelected && !_completingSession) {
      _distractionService.endStudySession();
    }

    NotificationService.cancelReminder();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (
        bool didPop,
        dynamic result,
      ) async {
        if (didPop) {
          return;
        }

        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Study Session',
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book,
                size: 60,
              ),

              const SizedBox(height: 20),

              Text(
                widget.note?.unit ?? 'Study Session',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              if (selectedDuration != null)
                Text(
                  'Study Duration: $selectedDuration min',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

              const SizedBox(height: 25),

              if (_durationSelected)
                ValueListenableBuilder<int>(
                  valueListenable:
                      StudySessionService.timeNotifier,
                  builder: (
                    context,
                    value,
                    child,
                  ) {
                    return Text(
                      StudySessionService.getTime(),
                      style: const TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                )
              else
                const CircularProgressIndicator(),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed:
                    _durationSelected ? openFile : null,
                icon: const Icon(
                  Icons.picture_as_pdf,
                ),
                label: const Text(
                  'Read File',
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed:
                    _durationSelected
                        ? _completeSession
                        : null,
                icon: const Icon(
                  Icons.check_circle,
                ),
                label: const Text(
                  'Complete Session',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}