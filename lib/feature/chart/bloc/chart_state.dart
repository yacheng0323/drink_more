import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartState extends Equatable {
  final ChartStatus status;

  final double? dailyGoal;

  final double? stageGoal;

  final double? amount;

  final List<BarChartGroupData>? barChartData;

  final DateTime? selectedDay;

  const ChartState({
    required this.status,
    this.dailyGoal,
    this.stageGoal,
    this.amount,
    this.barChartData,
    this.selectedDay,
  });

  ChartState copyWith({
    ChartStatus? status,
    double? dailyGoal,
    double? stageGoal,
    double? amount,
    List<BarChartGroupData>? barChartData,
    DateTime? selectedDay,
  }) {
    return ChartState(
      status: status ?? this.status,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      stageGoal: stageGoal ?? this.stageGoal,
      amount: amount ?? this.amount,
      barChartData: barChartData ?? this.barChartData,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }

  @override
  List<Object?> get props => [
        status,
        dailyGoal,
        stageGoal,
        amount,
        barChartData,
        selectedDay,
      ];
}

enum ChartStatus {
  initial,
  loading,
  success,
  failure,
}
