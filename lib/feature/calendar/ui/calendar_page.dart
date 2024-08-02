import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:drink_more/feature/calendar/bloc/calendar_bloc.dart';
import 'package:drink_more/feature/calendar/bloc/calendar_event.dart';
import 'package:drink_more/feature/calendar/bloc/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarBloc bloc;

  @override
  void initState() {
    bloc = CalendarBloc(const CalendarState(status: CalendarStatus.initial));
    bloc.add(CalendarInit());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
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
              bloc.add(CalendarInit());
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
      body: BlocProvider<CalendarBloc>(
        create: (context) => bloc,
        child: BlocConsumer<CalendarBloc, CalendarState>(
          listener: (context, state) {
            switch (state.status) {
              case CalendarStatus.initial:
                break;
              case CalendarStatus.loading:
                break;
              case CalendarStatus.success:
                break;
              case CalendarStatus.failure:
                break;
              default:
                break;
            }
          },
          builder: (context, state) {
            double dailyGoal = state.dailyGoal ?? 0;
            double amount = state.amount ?? 0;
            DateTime selectDate = state.selectDate ?? DateTime.now();
            DateTime now = DateTime.now();
            List<DateTime> markedDates = state.markedDates ?? [];

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
                      width: MediaQuery.of(context).size.width,
                      child: TableCalendar(
                        headerVisible: true,
                        firstDay: DateTime.utc(now.year - 10, now.month, now.day),
                        lastDay: DateTime.utc(now.year + 10, now.month, now.day),
                        focusedDay: selectDate,
                        daysOfWeekVisible: true,
                        selectedDayPredicate: (day) => isSameDay(selectDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          bloc.add(SelectDate(selectedDay));
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, events) {
                            if (markedDates.contains(day)) {
                              return Positioned(
                                bottom: 1,
                                top: 1,
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(color: const Color(0xff06A1BC), width: 2),
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                          dowBuilder: (context, day) {
                            final text = DateFormat.E().format(day);
                            final isWeekend = day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
                            return Center(
                              child: Text(
                                text,
                                style: TextGetter.subtitle2?.copyWith(
                                  color: isWeekend ? const Color(0xffB24A4A) : const Color(0xff0D6177),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          },
                        ),
                        headerStyle: const HeaderStyle(
                          headerPadding: EdgeInsets.all(12),
                          leftChevronVisible: false,
                          rightChevronVisible: false,
                          titleTextStyle: TextStyle(fontSize: 26, color: Color(0xff0079AC), fontWeight: FontWeight.w700),
                        ),
                        calendarStyle: const CalendarStyle(
                          outsideDaysVisible: false,
                          defaultTextStyle: TextStyle(color: Color(0xff0D6177), fontWeight: FontWeight.w700),
                          selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          todayDecoration: BoxDecoration(
                            color: Color(0xffB22222),
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle: TextStyle(color: Color(0xffB24A4A), fontWeight: FontWeight.w700),
                          selectedDecoration: BoxDecoration(
                            gradient: DrinkMoreColors.buttonBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          "${amount.toStringAsFixed(0)} ml",
                          style: TextGetter.headline4?.copyWith(color: Colors.white),
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
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
                        style: TextGetter.headline5?.copyWith(color: const Color(0xff0079AC)),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
