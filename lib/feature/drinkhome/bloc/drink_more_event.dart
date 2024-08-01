abstract class DrinkMoreEvent {}

class DrinkMoreInit extends DrinkMoreEvent {}

class AddMoreRecord extends DrinkMoreEvent {
  final double amount;

  AddMoreRecord({required this.amount});
}

class UpdateScheduledTimes extends DrinkMoreEvent {
  final int id;
  final int second;

  UpdateScheduledTimes({required this.id, required this.second});
}

class DeleteScheduledTimes extends DrinkMoreEvent {
  final int id;

  DeleteScheduledTimes({required this.id});
}

class AddNewScheduledTimes extends DrinkMoreEvent {
  final DateTime time;

  AddNewScheduledTimes({required this.time});
}
