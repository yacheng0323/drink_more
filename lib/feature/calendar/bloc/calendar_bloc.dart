import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/feature/calendar/bloc/calendar_event.dart';
import 'package:drink_more/feature/calendar/bloc/calendar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(super.initialState) {
    on<CalendarInit>(init);
    on<SelectDate>(selectDate);
  }

  Future<void> init(
    CalendarInit event,
    Emitter<CalendarState> emit,
  ) async {
    emit.call(state.copyWith(status: CalendarStatus.loading));
    // 生成假数据
    // generateFakeWaterRecords();
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      Map<String, dynamic> getWaterGoal = await dbService.getWaterGoal() ?? {};

      double amount = await dbService.getTotalWaterAmount(DateTime.now());
      double dailyGoal = getWaterGoal["dailyGoal"];

      List<DateTime> markedDates = [];

      List<Map<String, dynamic>> getAllRecords = await dbService.getAllWaterRecords();
      getAllRecords.forEach((element) {
        if (element["date"] != null) {
          DateTime date = DateTime.parse(element["date"]);
          DateTime utcDate = DateTime.utc(date.year, date.month, date.day);

          markedDates.add(utcDate);
        }
      });

      emit.call(state.copyWith(status: CalendarStatus.success, dailyGoal: dailyGoal, amount: amount, markedDates: markedDates));
    } catch (e) {
      emit.call(state.copyWith(status: CalendarStatus.failure));
    }
  }

  Future<void> selectDate(SelectDate event, Emitter<CalendarState> emit) async {
    emit.call(state.copyWith(status: CalendarStatus.loading));

    try {
      final dbService = GetIt.I.get<DatabaseService>();
      Map<String, dynamic> getWaterGoal = await dbService.getWaterGoal() ?? {};

      double amount = await dbService.getTotalWaterAmount(event.date);
      double dailyGoal = getWaterGoal["dailyGoal"];

      emit.call(state.copyWith(status: CalendarStatus.success, dailyGoal: dailyGoal, amount: amount));
    } catch (e) {
      emit.call(state.copyWith(status: CalendarStatus.failure));
    }
    emit.call(state.copyWith(selectDate: event.date));
  }

  /// 生成假数据
  // Future<void> generateFakeWaterRecords() async {
  //   final dbService = DatabaseService();

  //   // 日期格式
  //   final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  //   final Random random = Random();

  //   // 生成 7 月 1 日到 7 月 30 日的日期列表
  //   DateTime startDate = DateTime.utc(2024, 7, 1);
  //   DateTime endDate = DateTime.utc(2024, 7, 30);

  //   List<DateTime> dates = [];
  //   DateTime currentDate = startDate;

  //   while (currentDate.isBefore(endDate.add(Duration(days: 1)))) {
  //     dates.add(currentDate);
  //     currentDate = currentDate.add(Duration(days: 1));
  //   }

  //   // 生成假数据
  //   for (DateTime date in dates) {
  //     // 随机决定是否记录饮水量
  //     bool shouldRecord = random.nextBool();
  //     if (shouldRecord) {
  //       // 生成随机饮水量 (例如 100 ml 到 500 ml)
  //       double amount = 100 + random.nextDouble() * 400;
  //       String formattedDate = dateFormat.format(date);
  //       await dbService.insertWaterRecord(date, amount);
  //     }
  //   }
  // }
}
