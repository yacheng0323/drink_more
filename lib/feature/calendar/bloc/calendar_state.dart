import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final CalendarStatus status;

  final DateTime? selectDate;

  final double? dailyGoal;

  final double? stageGoal;

  final double? amount;

  final List<DateTime>? markedDates;

  const CalendarState({
    required this.status,
    this.selectDate,
    this.dailyGoal,
    this.stageGoal,
    this.amount,
    this.markedDates,
  });

  CalendarState copyWith({
    CalendarStatus? status,
    DateTime? selectDate,
    double? dailyGoal,
    double? stageGoal,
    double? amount,
    List<DateTime>? markedDates,
  }) {
    return CalendarState(
      status: status ?? this.status,
      selectDate: selectDate ?? this.selectDate,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      stageGoal: stageGoal ?? this.stageGoal,
      amount: amount ?? this.amount,
      markedDates: markedDates ?? this.markedDates,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectDate,
        dailyGoal,
        stageGoal,
        amount,
        markedDates,
      ];
}

enum CalendarStatus {
  initial,
  loading,
  success,
  failure,
}
