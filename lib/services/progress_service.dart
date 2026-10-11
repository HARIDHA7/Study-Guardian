import '../models/progress.dart';

class ProgressService {
  static Progress progress = Progress(
    studyHours: 0,
    completedTopics: 0,
    focusScore: 100,
  );

  static Progress getProgress() {
    return progress;
  }

  static void completeTopic() {
    progress.completedTopics++;
    updateFocusScore();
  }

  static void addStudyHour([int hours = 1]) {
    progress.studyHours += hours;
    updateFocusScore();
  }

  static void reduceFocusScore([int value = 5]) {
    progress.focusScore -= value;

    if (progress.focusScore < 0) {
      progress.focusScore = 0;
    }
  }

  static void increaseFocusScore([int value = 2]) {
    progress.focusScore += value;

    if (progress.focusScore > 100) {
      progress.focusScore = 100;
    }
  }

  static void updateFocusScore() {
    if (progress.completedTopics > 0) {
      increaseFocusScore();
    }
  }

  static void resetProgress() {
    progress = Progress(
      studyHours: 0,
      completedTopics: 0,
      focusScore: 100,
    );
  }
}