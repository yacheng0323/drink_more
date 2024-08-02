import 'dart:convert';
import 'dart:ffi';

import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:drink_more/feature/chart/bloc/chart_bloc.dart';
import 'package:drink_more/feature/chart/bloc/chart_event.dart';
import 'package:drink_more/feature/chart/bloc/chart_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late ChartBloc bloc;

  @override
  void initState() {
    bloc = ChartBloc(const ChartState(status: ChartStatus.initial));
    bloc.add(ChartInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "DRINK MORE",
          style: TextGetter.headline5?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              bloc.add(ChartInit());
            },
            icon: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xff2CBAD4),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider<ChartBloc>(
        create: (context) => bloc,
        child: BlocConsumer<ChartBloc, ChartState>(
          listener: (context, state) {},
          builder: (context, state) {
            double dailyGoal = state.dailyGoal ?? 0;
            double amount = state.amount ?? 0;
            List<BarChartGroupData>? barChartData = state.barChartData ?? [];
            DateTime selectedDay = state.selectedDay ?? DateTime.now();
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: DrinkMoreColors.gradientBackgroundColor,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: BarChart(BarChartData(
                        barTouchData: BarTouchData(
                          touchCallback: (event, response) {
                            if (event is FlTapUpEvent) {
                              if (response != null && response.spot != null) {
                                final BarTouchedSpot barTouchedSpot = response.spot!;
                                final double x = barTouchedSpot.spot.x; // 拿相關日期

                                bloc.add(SelectDay(day: x));
                              }
                            }
                          },
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.transparent,
                            tooltipPadding: EdgeInsets.zero,
                            tooltipMargin: 0,
                            getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex,
                            ) {
                              return BarTooltipItem(
                                rod.toY.round().toString(),
                                const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          // 下方標題
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (meta.formattedValue == selectedDay.day.toString()) {
                                  return getSelectTitles(value, meta);
                                } else {
                                  return getTitles(value, meta);
                                }
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true, border: Border.all(color: Color(0xff92CCD9))),
                        barGroups: barChartData,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            if (value == dailyGoal) {
                              return const FlLine(
                                color: Color(0xff3477A8),
                                strokeWidth: 1,
                                dashArray: [5, 5], // 虛線樣式
                              );
                            } else {
                              return const FlLine(
                                color: Colors.transparent, // No line if condition is not met
                                strokeWidth: 0,
                              );
                            }
                          },
                        ),
                        alignment: BarChartAlignment.spaceAround,
                        maxY: dailyGoal * 2,
                      )),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          "${amount.toStringAsFixed(0)} ml",
                          style: TextGetter.headline4?.copyWith(color: Colors.white),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(32, 8, 32, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        clipBehavior: Clip.antiAlias,
                        child: StepProgressIndicator(
                          totalSteps: 100,
                          currentStep: ((amount / dailyGoal) * 100).clamp(0, 100).toInt(),
                          size: 46,
                          padding: 0,
                          unselectedColor: Colors.cyan,
                          roundedEdges: const Radius.circular(10),
                          selectedGradientColor: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff2FB6CF), Color(0xff2CBAD4), Color(0xff2290CE)],
                          ),
                          unselectedGradientColor: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff7BCBE4), Color(0xff7BCBE4)],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                      child: Text(
                        "Target: ${dailyGoal.toStringAsFixed(0)} ml",
                        style: TextGetter.headline5?.copyWith(color: Color(0xff0079AC)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 2, 32, 0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat("yyyy-MM-dd").format(selectedDay),
                        style: TextGetter.botton?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        "${value.toInt()}",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget getSelectTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: DrinkMoreColors.buttonBackgroundColor,
        ),
        child: Text(
          "${value.toInt()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
