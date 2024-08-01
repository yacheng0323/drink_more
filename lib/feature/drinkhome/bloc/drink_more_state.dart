import 'package:drink_more/entities/local/reminder_model.dart';
import 'package:equatable/equatable.dart';

class DrinkMoreState extends Equatable {
  final DrinkMoreStatus status;

  final List<ReminderModel>? scheduledTimes;

  final double? dailyGoal;

  final double? stageGoal;

  final double? amount;

  const DrinkMoreState({
    required this.status,
    this.scheduledTimes,
    this.dailyGoal,
    this.stageGoal,
    this.amount,
  });

  DrinkMoreState copyWith({
    DrinkMoreStatus? status,
    List<ReminderModel>? scheduledTimes,
    double? dailyGoal,
    double? stageGoal,
    double? amount,
  }) {
    return DrinkMoreState(
      status: status ?? this.status,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      stageGoal: stageGoal ?? this.stageGoal,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        scheduledTimes,
        dailyGoal,
        stageGoal,
        amount,
      ];
}

enum DrinkMoreStatus {
  initial,
  loading,
  success,
  failure,
  addTimeFailure,
  addTimeSuccess,
}
