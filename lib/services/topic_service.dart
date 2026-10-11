import '../models/topic.dart';

class TopicService {
  static final Map<String, List<Topic>> _topics = {};

  static void addTopic(
    String subject,
    String name,
    int duration,
  ) {
    _topics.putIfAbsent(subject, () => []);

    bool exists = _topics[subject]!.any(
      (topic) =>
          topic.name.toLowerCase() ==
          name.trim().toLowerCase(),
    );

    if (!exists) {
      _topics[subject]!.add(
        Topic(
          name: name.trim(),
          studyDuration: duration,
          status: "Pending",
        ),
      );
    }
  }

  static List<Topic> getTopics(String subject) {
    return _topics[subject] ?? [];
  }

  static List<Topic> getAllTopics() {
    List<Topic> allTopics = [];

    for (var topics in _topics.values) {
      allTopics.addAll(topics);
    }

    return allTopics;
  }

  static void deleteTopic(
    String subject,
    int index,
  ) {
    if (_topics.containsKey(subject) &&
        index >= 0 &&
        index < _topics[subject]!.length) {
      _topics[subject]!.removeAt(index);
    }
  }

  static void markCompleted(
    String subject,
    int index,
  ) {
    if (_topics.containsKey(subject) &&
        index >= 0 &&
        index < _topics[subject]!.length) {
      _topics[subject]![index].status = "Completed";
    }
  }

  static int completedCount(String subject) {
    if (subject.isEmpty) {
      int count = 0;

      for (var topics in _topics.values) {
        count += topics
            .where(
              (topic) => topic.status == "Completed",
            )
            .length;
      }

      return count;
    }

    return _topics[subject]
            ?.where(
              (topic) => topic.status == "Completed",
            )
            .length ??
        0;
  }

  static int pendingCount(String subject) {
    if (subject.isEmpty) {
      int count = 0;

      for (var topics in _topics.values) {
        count += topics
            .where(
              (topic) => topic.status != "Completed",
            )
            .length;
      }

      return count;
    }

    return _topics[subject]
            ?.where(
              (topic) => topic.status != "Completed",
            )
            .length ??
        0;
  }

  static int totalTopics() {
    int total = 0;

    for (var topics in _topics.values) {
      total += topics.length;
    }

    return total;
  }

  static int totalStudyMinutes() {
    int total = 0;

    for (var topics in _topics.values) {
      for (var topic in topics) {
        total += topic.studyDuration;
      }
    }

    return total;
  }

  static void clearTopics() {
    _topics.clear();
  }
}