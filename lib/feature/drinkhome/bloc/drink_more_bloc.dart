import 'dart:math';

import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/feature/drinkhome/bloc/drink_more_event.dart';
import 'package:drink_more/feature/drinkhome/bloc/drink_more_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DrinkMoreBloc extends Bloc<DrinkMoreEvent, DrinkMoreState> {
  DrinkMoreBloc(super.initialState) {
    on<DrinkMoreInit>(init);
    on<AddMoreRecord>(addWaterAmount);
    on<UpdateScheduledTimes>(updateScheduledTimes);
  }

  Future<void> init(
    DrinkMoreInit event,
    Emitter<DrinkMoreState> emit,
  ) async {
    emit.call(state.copyWith(status: DrinkMoreStatus.loading));

    try {
      final dbService = GetIt.I.get<DatabaseService>();
      Map<String, dynamic> getWaterGoal = await dbService.getWaterGoal() ?? {};

      double amount = await dbService.getTotalWaterAmount(DateTime.now());
      double dailyGoal = getWaterGoal["dailyGoal"];

      List<int> scheduledTimes = await dbService.getReminders();

      emit.call(state.copyWith(status: DrinkMoreStatus.success, dailyGoal: dailyGoal, amount: amount, scheduledTimes: scheduledTimes));
    } catch (e) {
      emit.call(state.copyWith(status: DrinkMoreStatus.failure));
    }
  }

  Future<void> addWaterAmount(
    AddMoreRecord event,
    Emitter<DrinkMoreState> emit,
  ) async {
    emit.call(state.copyWith(status: DrinkMoreStatus.loading));

    try {
      final dbService = GetIt.I.get<DatabaseService>();
      await dbService.insertWaterRecord(DateTime.now(), event.amount);

      double amount = await dbService.getTotalWaterAmount(DateTime.now());
      Map<String, dynamic> getWaterGoal = await dbService.getWaterGoal() ?? {};

      double dailyGoal = getWaterGoal["dailyGoal"];

      emit.call(state.copyWith(status: DrinkMoreStatus.success, dailyGoal: dailyGoal, amount: amount));
    } catch (e) {
      emit.call(state.copyWith(status: DrinkMoreStatus.failure));
    }
  }

  Future<void> updateScheduledTimes(
    UpdateScheduledTimes event,
    Emitter<DrinkMoreState> emit,
  ) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();

      // +1 是因為 id 是從 1 開始
      await dbService.updateReminder(event.id + 1, event.second);
      List<int> scheduledTimes = await dbService.getReminders();
      emit.call(state.copyWith(status: DrinkMoreStatus.success, scheduledTimes: scheduledTimes));
    } catch (e) {
      emit.call(state.copyWith(status: DrinkMoreStatus.failure));
    }
  }
}
