import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/feature/reminder/bloc/reminder_event.dart';
import 'package:drink_more/feature/reminder/bloc/reminder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc(super.initialState) {
    on<ReminderInit>(init);
    on<Confirm>(confirm);
  }

  Future<void> init(ReminderInit event, Emitter<ReminderState> emit) async {
    int hours = event.seconds ~/ 3600;
    int minutes = (event.seconds % 3600) ~/ 60;

    DateTime dateTime = DateTime(2024, 1, 1, hours, minutes);
    String formattedTime = DateFormat("a hh:mm").format(dateTime);

    emit.call(state.copyWith(time: event.seconds, displayTime: formattedTime));
  }

  Future<void> confirm(Confirm event, Emitter<ReminderState> emit) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      List<Map<String, dynamic>> getStageGoal = await dbService.getStageGoals();
      double stageGoal = getStageGoal[0]["amount"];
      await dbService.insertWaterRecord(DateTime.now(), stageGoal);

      emit.call(state.copyWith(status: ReminderStatus.success));
    } catch (e) {
      emit.call(state.copyWith(status: ReminderStatus.failure));
    }
  }
}
