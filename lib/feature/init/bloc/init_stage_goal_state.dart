import 'package:equatable/equatable.dart';

class InitStageGoalState extends Equatable {
  final InitStageGoalStatus status;

  final List<int>? scheduledTimes;

  const InitStageGoalState({required this.status, this.scheduledTimes});

  InitStageGoalState copyWith({
    InitStageGoalStatus? status,
    DateTime? selectDate,
    List<int>? scheduledTimes,
  }) {
    return InitStageGoalState(
      status: status ?? this.status,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
    );
  }

  @override
  List<Object> get props => [
        status,
        scheduledTimes ?? [],
      ];
}

enum InitStageGoalStatus {
  initial,
  loading,
  success,
  addTimeSuccess,
  addTimeFailure,
  startError,
}
