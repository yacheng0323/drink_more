import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/entities/local/reminder_model.dart';
import 'package:drink_more/feature/drinkhome/bloc/drink_more_event.dart';
import 'package:drink_more/feature/drinkhome/bloc/drink_more_state.dart';
import 'package:drink_more/feature/local_notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DrinkMoreBloc extends Bloc<DrinkMoreEvent, DrinkMoreState> {
  DrinkMoreBloc(super.initialState) {
    on<DrinkMoreInit>(init);
    on<AddMoreRecord>(addWaterAmount);
    on<AddNewScheduledTimes>(addNewscheduledTimes);
    on<UpdateScheduledTimes>(updateScheduledTimes);
    on<DeleteScheduledTimes>(deleteScheduledTimes);
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

      List<ReminderModel> scheduledTimes = await dbService.getReminders();
      scheduledTimes.sort((a, b) => a.seconds.compareTo(b.seconds));

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

  Future<void> addNewscheduledTimes(
    AddNewScheduledTimes event,
    Emitter<DrinkMoreState> emit,
  ) async {
    emit.call(state.copyWith(status: DrinkMoreStatus.loading));

    try {
      final dbService = GetIt.I.get<DatabaseService>();

      int hour = event.time.hour;
      int minute = event.time.minute;
      int totalSeconds = hour * 3600 + minute * 60;

      List<ReminderModel> list = List.from(state.scheduledTimes ?? []);
      bool exists = list.any((reminder) => reminder.seconds == totalSeconds);

      if (exists) {
        emit(state.copyWith(status: DrinkMoreStatus.addTimeFailure));
      } else {
        int newId = list.isNotEmpty ? list.last.id + 1 : 1;
        list.add(ReminderModel(id: newId, seconds: totalSeconds));

        await dbService.insertReminder(list);
        List<ReminderModel> scheduledTimes = await dbService.getReminders();
        await LocalNotification.scheduleWaterReminders();
        scheduledTimes.sort((a, b) => a.seconds.compareTo(b.seconds));

        emit(state.copyWith(status: DrinkMoreStatus.success, scheduledTimes: scheduledTimes));
      }
    } catch (e) {
      emit.call(state.copyWith(status: DrinkMoreStatus.failure));
    }
  }

  Future<void> updateScheduledTimes(
    UpdateScheduledTimes event,
    Emitter<DrinkMoreState> emit,
  ) async {
    emit.call(state.copyWith(status: DrinkMoreStatus.loading));

    try {
      final dbService = GetIt.I.get<DatabaseService>();

      await dbService.updateReminder(event.id, event.second);
      List<ReminderModel> scheduledTimes = await dbService.getReminders();
      await LocalNotification.scheduleWaterReminders();
      scheduledTimes.sort((a, b) => a.seconds.compareTo(b.seconds));

      emit.call(state.copyWith(status: DrinkMoreStatus.success, scheduledTimes: scheduledTimes));
    } catch (e) {
      emit.call(state.copyWith(status: DrinkMoreStatus.failure));
    }
  }

  Future<void> deleteScheduledTimes(
    DeleteScheduledTimes event,
    Emitter<DrinkMoreState> emit,
  ) async {
    emit.call(state.copyWith(status: DrinkMoreStatus.loading));

    try {
      final dbService = GetIt.I.get<DatabaseService>();

      await dbService.deleteReminder(event.id);
      List<ReminderModel> scheduledTimes = await dbService.getReminders();
      await LocalNotification.scheduleWaterReminders();
      scheduledTimes.sort((a, b) => a.seconds.compareTo(b.seconds));

      emit.call(state.copyWith(status: DrinkMoreStatus.success, scheduledTimes: scheduledTimes));
    } catch (e) {
      emit.call(state.copyWith(status: DrinkMoreStatus.failure));
    }
  }
}
