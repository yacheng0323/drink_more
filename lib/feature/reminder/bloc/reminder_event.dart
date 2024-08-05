abstract class ReminderEvent {}

class ReminderInit extends ReminderEvent {
  final int seconds;

  ReminderInit({required this.seconds});
}

class Confirm extends ReminderEvent {
  final int seconds;

  Confirm({required this.seconds});
}
