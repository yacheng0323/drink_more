import 'package:drink_more/feature/init/bloc/init_stage_goal_event.dart';
import 'package:drink_more/feature/init/bloc/init_stage_goal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitStageGoalBloc extends Bloc<InitStageGoalEvent, InitStageGoalState> {
  InitStageGoalBloc(super.initialState) {
    on<StageGoalInit>(init);
    on<AddTime>(addTime);
  }

  Future<void> init(StageGoalInit event, Emitter<InitStageGoalState> emit) async {}

  Future<void> addTime(AddTime event, Emitter<InitStageGoalState> emit) async {
    int hour = event.dateTime.hour;
    int minute = event.dateTime.minute;
    int totalSeconds = hour * 3600 + minute * 60;

    List<int> list = List.from(state.scheduledTimes ?? []);
    list.contains(totalSeconds) ? emit.call(state.copyWith(status: InitStageGoalStatus.failure)) : list.add(totalSeconds);

    emit.call(state.copyWith(status: InitStageGoalStatus.success, scheduledTimes: list));
  }
}
