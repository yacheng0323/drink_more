abstract class CalendarEvent {}

class CalendarInit extends CalendarEvent {}

class SelectDate extends CalendarEvent {
  final DateTime date;

  SelectDate(this.date);
}
