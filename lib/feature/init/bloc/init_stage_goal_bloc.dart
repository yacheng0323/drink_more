import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/entities/local/reminder_model.dart';
import 'package:drink_more/feature/init/bloc/init_stage_goal_event.dart';
import 'package:drink_more/feature/init/bloc/init_stage_goal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InitStageGoalBloc extends Bloc<InitStageGoalEvent, InitStageGoalState> {
  InitStageGoalBloc(super.initialState) {
    on<StageGoalInit>(init);
    on<AddTime>(addTime);
    on<Submit>(submit);
  }

  Future<void> init(StageGoalInit event, Emitter<InitStageGoalState> emit) async {}

  Future<void> addTime(AddTime event, Emitter<InitStageGoalState> emit) async {
    int hour = event.dateTime.hour;
    int minute = event.dateTime.minute;
    int totalSeconds = hour * 3600 + minute * 60;

    List<ReminderModel> list = List.from(state.scheduledTimes ?? []);
    bool exists = list.any((reminder) => reminder.seconds == totalSeconds);
    if (exists) {
      emit(state.copyWith(status: InitStageGoalStatus.addTimeFailure));
    } else {
      int newId = list.isNotEmpty ? list.last.id + 1 : 1;
      list.add(ReminderModel(id: newId, seconds: totalSeconds));
      emit(state.copyWith(scheduledTimes: list, status: InitStageGoalStatus.addTimeSuccess));
    }
  }

  Future<void> submit(
    Submit event,
    Emitter<InitStageGoalState> emit,
  ) async {
    emit.call(state.copyWith(status: InitStageGoalStatus.loading));

    try {
      final dbService = GetIt.I.get<DatabaseService>();

      await dbService.insertWaterGoal(event.dailyGoal);
      await dbService.insertStageGoal(event.stageGoal);
      await dbService.insertReminder(event.scheduledTimes);

      emit.call(state.copyWith(status: InitStageGoalStatus.success));
    } catch (e) {
      emit.call(state.copyWith(status: InitStageGoalStatus.startError));
    }
  }
}
