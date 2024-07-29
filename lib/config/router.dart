import 'package:drink_more/feature/calendar/ui/calendar_page.dart';
import 'package:drink_more/feature/chart/ui/chart_page.dart';
import 'package:drink_more/feature/drinkhome/ui/drink_more_page.dart';
import 'package:drink_more/feature/init/ui/init_daily_goal_page.dart';
import 'package:drink_more/feature/init/ui/init_stage_goal_page.dart';
import 'package:drink_more/feature/nav_scaffold.dart';
import 'package:drink_more/feature/setting/ui/setting_page.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const InitDailyGoalPage(),
    ),
    GoRoute(
      path: "/InitStageGoal",
      builder: (context, state) => const InitStageGoalPage(),
    ),
    GoRoute(
      path: "/NavScaffold",
      builder: (context, state) => const NavScaffold(),
      routes: [
        GoRoute(
          path: 'DrinkMore',
          builder: (context, state) => const DrinkMorePage(),
        ),
        GoRoute(
          path: 'Calendar',
          builder: (context, state) => const CalendarPage(),
        ),
        GoRoute(
          path: 'Chart',
          builder: (context, state) => const ChartPage(),
        ),
        GoRoute(
          path: 'Setting',
          builder: (context, state) => const SettingPage(),
        ),
      ],
    ),
  ],
);
