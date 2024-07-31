import 'package:drink_more/core/database/database_service.dart';
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

    List<int> list = List.from(state.scheduledTimes ?? []);
    list.contains(totalSeconds) ? emit.call(state.copyWith(status: InitStageGoalStatus.addTimeFailure)) : list.add(totalSeconds);

    emit.call(state.copyWith(status: InitStageGoalStatus.addTimeSuccess, scheduledTimes: list));
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

      final a = await dbService.getReminders();
      final b = await dbService.getStageGoals();
      final c = await dbService.getWaterGoal();

      print(a);
      print(b);
      print(c);

      emit.call(state.copyWith(status: InitStageGoalStatus.success));
    } catch (e) {
      emit.call(state.copyWith(status: InitStageGoalStatus.startError));
    }
  }
}
