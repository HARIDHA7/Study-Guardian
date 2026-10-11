import '../models/schedule.dart';

class ScheduleService {
  static final List<Schedule> _schedules = [];

  static void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
  }

  static List<Schedule> getSchedules() {
    return _schedules;
  }

  static int getScheduleCount() {
    return _schedules.length;
  }

  static void deleteSchedule(int index) {
    if (index >= 0 && index < _schedules.length) {
      _schedules.removeAt(index);
    }
  }

  static void clearSchedules() {
    _schedules.clear();
  }
}