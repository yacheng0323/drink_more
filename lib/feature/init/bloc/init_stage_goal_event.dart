abstract class InitStageGoalEvent {}

class StageGoalInit extends InitStageGoalEvent {}

class AddTime extends InitStageGoalEvent {
  final DateTime dateTime;

  AddTime({required this.dateTime});
}

class Submit extends InitStageGoalEvent {
  final double dailyGoal;
  final double stageGoal;

  final List<int> scheduledTimes;

  Submit({required this.dailyGoal, required this.stageGoal, required this.scheduledTimes});
}
