import 'package:drink_more/entities/local/reminder_model.dart';

abstract class InitStageGoalEvent {}

class StageGoalInit extends InitStageGoalEvent {}

class AddTime extends InitStageGoalEvent {
  final DateTime dateTime;

  AddTime({required this.dateTime});
}

class Submit extends InitStageGoalEvent {
  final double dailyGoal;
  final double stageGoal;

  final List<ReminderModel> scheduledTimes;

  Submit({required this.dailyGoal, required this.stageGoal, required this.scheduledTimes});
}
