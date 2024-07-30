import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;

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
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DrinkMoreColors.backgroundTopColor,
                  DrinkMoreColors.backgroundBottomColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                width: MediaQuery.of(context).size.width,
                child: TableCalendar(
                    headerVisible: true,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    daysOfWeekVisible: true,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    calendarBuilders: CalendarBuilders(
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
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
