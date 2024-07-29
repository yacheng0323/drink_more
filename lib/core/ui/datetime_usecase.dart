class DatetimeUsecase {
  static DateTime timeFromSeconds(int totalSeconds) {
    DateTime now = DateTime.now();

    int hour = totalSeconds ~/ 3600;
    int minute = (totalSeconds % 3600) ~/ 60;
    int second = totalSeconds % 60;

    hour = hour % 24;

    return DateTime(now.year, now.month, now.day, hour, minute, second);
  }
}
