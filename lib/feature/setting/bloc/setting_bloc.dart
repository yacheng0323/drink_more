import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/feature/setting/bloc/setting_event.dart';
import 'package:drink_more/feature/setting/bloc/setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc(SettingState initialState) : super(initialState) {
    on<SettingInit>(init);
    on<SaveDailyGoal>(saveDailyGoal);
    on<SaveStageGoal>(saveStageGoal);
    on<Reset>(reset);
  }

  Future<void> init(
    SettingInit event,
    Emitter<SettingState> emit,
  ) async {
    emit.call(state.copyWith(status: SettingStatus.loading));
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      Map<String, dynamic> getWaterGoal = await dbService.getWaterGoal() ?? {};
      List<Map<String, dynamic>> getStageGoal = await dbService.getStageGoals();
      double dailyGoal = getWaterGoal["dailyGoal"];
      double stageGoal = getStageGoal[0]["amount"];

      emit.call(state.copyWith(
        status: SettingStatus.success,
        dailyGoal: dailyGoal,
        stageGoal: stageGoal,
      ));
    } catch (e) {
      emit.call(state.copyWith(status: SettingStatus.failure));
    }
  }

  Future<void> saveDailyGoal(
    SaveDailyGoal event,
    Emitter<SettingState> emit,
  ) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      Map<String, dynamic>? getWaterGoal = await dbService.getWaterGoal() ?? {};
      int id = getWaterGoal["id"];

      await dbService.updateDailyGoal(id, event.amount);

      emit.call(state.copyWith(status: SettingStatus.saveDailyGoalSuccess, dailyGoal: event.amount));
    } catch (e) {
      emit.call(state.copyWith(status: SettingStatus.saveDailyGoalFailure));
    }
  }

  Future<void> saveStageGoal(
    SaveStageGoal event,
    Emitter<SettingState> emit,
  ) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      List<Map<String, dynamic>> getStageGoal = await dbService.getStageGoals();
      int id = getStageGoal[0]["id"];

      await dbService.updateStageGoal(id, event.amount);

      emit.call(state.copyWith(status: SettingStatus.saveStageGoalSuccess, stageGoal: event.amount));
    } catch (e) {
      emit.call(state.copyWith(status: SettingStatus.saveStageGoalFailure));
    }
  }

  Future<void> reset(
    Reset event,
    Emitter<SettingState> emit,
  ) async {
    final dbService = GetIt.I.get<DatabaseService>();
    await dbService.clearAllTables();
  }
}
