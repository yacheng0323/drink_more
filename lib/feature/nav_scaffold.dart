import 'package:drink_more/feature/calendar/ui/calendar_page.dart';
import 'package:drink_more/feature/chart/ui/chart_page.dart';
import 'package:drink_more/feature/drinkhome/ui/drink_more_page.dart';
import 'package:drink_more/feature/setting/ui/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class NavScaffold extends StatefulWidget {
  const NavScaffold({super.key});

  @override
  State<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends State<NavScaffold> {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          DrinkMorePage(),
          CalendarPage(),
          ChartPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(label: "", icon: Icon(Icons.home_outlined)),
          BottomNavigationBarItem(label: "", icon: Icon(Icons.calendar_month_outlined)),
          BottomNavigationBarItem(label: "", icon: Icon(Icons.bar_chart_sharp)),
          BottomNavigationBarItem(label: "", icon: Icon(Symbols.shelf_auto_hide)),
        ],
      ),
    );
  }
}
