import 'package:drink_more/feature/drinkhome/ui/drink_more_page.dart';
import 'package:drink_more/feature/init/ui/init_stage_goal_page.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const DrinkMorePage(),
    ),
    GoRoute(
      path: "/InitStageGoal",
      builder: (context, state) => const InitStageGoalPage(),
    ),
  ],
);
