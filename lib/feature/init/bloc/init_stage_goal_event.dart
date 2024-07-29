abstract class InitStageGoalEvent {}

class StageGoalInit extends InitStageGoalEvent {}

class AddTime extends InitStageGoalEvent {
  final DateTime dateTime;

  AddTime({required this.dateTime});
}
