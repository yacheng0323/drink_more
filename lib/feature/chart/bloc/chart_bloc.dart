import 'dart:ui';

import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/feature/chart/bloc/chart_event.dart';
import 'package:drink_more/feature/chart/bloc/chart_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc(super.initialState) {
    on<ChartInit>(init);
    on<SelectDay>(onDaySelected);
  }

  Future<void> init(
    ChartInit event,
    Emitter<ChartState> emit,
  ) async {
    emit.call(state.copyWith(status: ChartStatus.loading));
    try {
      DateTime now = DateTime.now();
      final dbService = GetIt.I.get<DatabaseService>();

      Map<String, dynamic> getWaterGoal = await dbService.getWaterGoal() ?? {};
      double amount = await dbService.getTotalWaterAmount(now);
      double dailyGoal = getWaterGoal["dailyGoal"];

      List<Map<String, dynamic>> getAllRecords = await dbService.getAllWaterRecords();
      List<BarChartGroupData> barChartData = [];

      // 前7後7 的天數
      List<DateTime> dateList = getDateList();

      for (DateTime date in dateList) {
        bool found = false;
        for (var element in getAllRecords) {
          if (element["date"] != null) {
            DateTime recordDate = DateTime.parse(element["date"]);
            if (isSameDay(date, recordDate)) {
              double amount = element["amount"];
              barChartData.add(
                BarChartGroupData(
                  x: date.day,
                  barRods: [
                    BarChartRodData(
                      toY: amount,
                      color: amount >= dailyGoal ? const Color(0xff06A1BC) : const Color(0xff568CA3),
                    ),
                  ],
                  showingTooltipIndicators: now.day == date.day ? [0] : [],
                ),
              );
              found = true;
              break;
            }
          }
        }
        if (!found) {
          barChartData.add(
            BarChartGroupData(
              x: date.day,
              barRods: [
                BarChartRodData(
                  toY: 0,
                  color: const Color(0xff568CA3),
                ),
              ],
            ),
          );
        }
      }

      emit.call(state.copyWith(status: ChartStatus.success, amount: amount, dailyGoal: dailyGoal, barChartData: barChartData, selectedDay: DateTime.now()));
    } catch (e) {
      emit.call(state.copyWith(status: ChartStatus.failure));
    }
  }

  List<DateTime> getDateList() {
    DateTime today = DateTime.now();
    List<DateTime> dateList = [];

    for (int i = -7; i <= 7; i++) {
      DateTime utcDate = DateTime.utc(today.year, today.month, today.day + i);
      dateList.add(utcDate);
    }

    return dateList;
  }

  Future<void> onDaySelected(SelectDay event, Emitter<ChartState> emit) async {
    List<DateTime> dateList = getDateList();
    DateTime selectDay = dateList.firstWhere((element) => element.day == event.day);
    final dbService = GetIt.I.get<DatabaseService>();

    Map<String, dynamic> getWaterGoal = await dbService.getWaterGoal() ?? {};
    double amount = await dbService.getTotalWaterAmount(selectDay);
    double dailyGoal = getWaterGoal["dailyGoal"];

    List<BarChartGroupData> barChartData = state.barChartData!.map((data) {
      if (data.x == selectDay.day) {
        return BarChartGroupData(
          x: data.x,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: amount >= dailyGoal ? const Color(0xff06A1BC) : const Color(0xff568CA3),
            ),
          ],
          barsSpace: 2,
          showingTooltipIndicators: [0], // 显示 tooltip
        );
      } else {
        return BarChartGroupData(
          x: data.x,
          barRods: data.barRods,
          barsSpace: 2,
          showingTooltipIndicators: [], // 隐藏 tooltip
        );
      }
    }).toList();

    emit.call(state.copyWith(
      amount: amount,
      dailyGoal: dailyGoal,
      selectedDay: selectDay,
      barChartData: barChartData,
    ));
  }
}
