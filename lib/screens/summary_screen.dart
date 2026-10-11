import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/distraction_service.dart';

class SummaryScreen extends StatefulWidget {
  final String summary;

  const SummaryScreen({
    super.key,
    required this.summary,
  });

  @override
  State<SummaryScreen> createState() =>
      _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with WidgetsBindingObserver {
  final DistractionService _distractionService =
      DistractionService();

  bool _summaryActive = false;
  bool _leavingSummary = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _summaryActive = true;

    _startSummaryStudySession();
  }

  // ============================================================
  // START SUMMARY STUDY SESSION
  // ============================================================

  Future<void> _startSummaryStudySession() async {
    await _distractionService.startStudySession();

    print('========================================');
    print('AI SUMMARY READING STARTED');
    print('DISTRACTION MONITORING: ACTIVE');
    print('========================================');
  }

  // ============================================================
  // APP LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    super.didChangeAppLifecycleState(state);

    if (!_summaryActive || _leavingSummary) {
      return;
    }

    // ----------------------------------------------------------
    // USER LEFT STUDY GUARDIAN
    // ----------------------------------------------------------

    if (state == AppLifecycleState.paused) {
      print('========================================');
      print('AI SUMMARY APP BACKGROUNDED');
      print('STARTING DISTRACTION DETECTION');
      print('========================================');

      _distractionService.onAppBackgrounded();
    }

    // ----------------------------------------------------------
    // USER RETURNED TO STUDY GUARDIAN
    // ----------------------------------------------------------

    else if (state == AppLifecycleState.resumed) {
      print('========================================');
      print('AI SUMMARY APP RESUMED');
      print('STOPPING DISTRACTION DETECTION');
      print('========================================');

      _distractionService.onAppResumed();
    }
  }

  // ============================================================
  // COPY SUMMARY
  // ============================================================

  Future<void> _copySummary(
    BuildContext context,
  ) async {
    await Clipboard.setData(
      ClipboardData(
        text: widget.summary,
      ),
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Summary copied to clipboard',
        ),
      ),
    );
  }

  // ============================================================
  // LEAVE SUMMARY
  // ============================================================

  Future<void> _leaveSummary() async {
    if (_leavingSummary) {
      return;
    }

    _leavingSummary = true;

    print('========================================');
    print('LEAVING AI SUMMARY');
    print('STOPPING DISTRACTION MONITORING');
    print('========================================');

    // ----------------------------------------------------------
    // This is an intentional navigation.
    //
    // Therefore the complete summary study session ends here.
    // ----------------------------------------------------------

    await _distractionService.endStudySession();

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

    _summaryActive = false;

    // ----------------------------------------------------------
    // Safety cleanup.
    //
    // The normal navigation path calls endStudySession().
    // This also protects against unexpected disposal.
    // ----------------------------------------------------------

    if (!_leavingSummary) {
      _distractionService.endStudySession();
    }

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

        await _leaveSummary();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AI Summary',
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.blue,
                    size: 28,
                  ),

                  SizedBox(width: 10),

                  Text(
                    'AI Generated Summary',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(18),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey.shade100,

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),

                  border: Border.all(
                    color:
                        Colors.grey.shade300,
                  ),
                ),

                child: SelectableText(
                  widget.summary,

                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child:
                        ElevatedButton.icon(
                      onPressed: () =>
                          _copySummary(
                        context,
                      ),

                      icon: const Icon(
                        Icons.copy,
                      ),

                      label: const Text(
                        'Copy',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          _leaveSummary,

                      icon: const Icon(
                        Icons.refresh,
                      ),

                      label: const Text(
                        'Summarize Another',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}