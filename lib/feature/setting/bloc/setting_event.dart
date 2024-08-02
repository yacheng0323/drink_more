abstract class SettingEvent {}

class SettingInit extends SettingEvent {}

class SaveDailyGoal extends SettingEvent {
  double amount;

  SaveDailyGoal({required this.amount});
}

class SaveStageGoal extends SettingEvent {
  double amount;

  SaveStageGoal({
    required this.amount,
  });
}

class Reset extends SettingEvent {}
