import 'package:equatable/equatable.dart';

class ReminderState extends Equatable {
  final ReminderStatus status;

  final int? time;

  final String? displayTime;

  const ReminderState({
    required this.status,
    this.time,
    this.displayTime,
  });

  ReminderState copyWith({
    ReminderStatus? status,
    int? time,
    String? displayTime,
  }) {
    return ReminderState(
      status: status ?? this.status,
      time: time ?? this.time,
      displayTime: displayTime ?? this.displayTime,
    );
  }

  @override
  List<Object?> get props => [status, time, displayTime];
}

enum ReminderStatus {
  initial,
  success,
  failure,
}
