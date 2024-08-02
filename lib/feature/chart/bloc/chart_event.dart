abstract class ChartEvent {}

class ChartInit extends ChartEvent {}

class SelectDay extends ChartEvent {
  final double day;

  SelectDay({required this.day});
}
