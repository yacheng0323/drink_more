import 'package:equatable/equatable.dart';

class SettingState extends Equatable {
  final SettingStatus status;

  final double? dailyGoal;

  final double? stageGoal;

  const SettingState({
    required this.status,
    this.dailyGoal,
    this.stageGoal,
  });

  SettingState copyWith({
    SettingStatus? status,
    double? dailyGoal,
    double? stageGoal,
  }) {
    return SettingState(
      status: status ?? this.status,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      stageGoal: stageGoal ?? this.stageGoal,
    );
  }

  @override
  List<Object?> get props => [status, dailyGoal, stageGoal];
}

enum SettingStatus {
  initial,
  loading,
  success,
  failure,
  saveDailyGoalSuccess,
  saveDailyGoalFailure,
  saveStageGoalSuccess,
  saveStageGoalFailure,
}
