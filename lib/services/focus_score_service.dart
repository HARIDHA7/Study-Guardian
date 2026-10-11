import 'distraction_history_service.dart';
import 'progress_service.dart';

class FocusScoreService {
  static double calculateScore() {
    double score = 100;

    // Reduce score based on distraction time
    int distractionSeconds =
        DistractionHistoryService.getTotalSeconds();

    score -= distractionSeconds / 30;

    // Bonus for completed topics
    score += ProgressService.getProgress().completedTopics * 2;

    // Bonus for study hours
    score += ProgressService.getProgress().studyHours * 3;

    if (score > 100) {
      score = 100;
    }

    if (score < 0) {
      score = 0;
    }

    return double.parse(score.toStringAsFixed(1));
  }
}