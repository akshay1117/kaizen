import 'package:go_router/go_router.dart';
import 'package:kaizen/view/widget/scaffold_with_nav_bar.dart';
import 'package:kaizen/view/screen/home_screen.dart';
import 'package:kaizen/view/screen/fitness_hub_screen.dart';
import 'package:kaizen/view/screen/gym_screens.dart';
import 'package:kaizen/view/screen/boxing_home_screen.dart';
import 'package:kaizen/view/screen/running_home_screen.dart';
import 'package:kaizen/view/screen/diet_home_screen.dart';
import 'package:kaizen/view/screen/habits_home_screen.dart';
import 'package:kaizen/view/screen/add_habit_screen.dart';
import 'package:kaizen/view/screen/finance_home_screen.dart';
import 'package:kaizen/view/screen/journal_home_screen.dart';
import 'package:kaizen/features/journal/presentation/screens/create_journal_screen.dart';
import 'package:kaizen/features/journal/presentation/screens/journal_detail_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        // Branch 0: Home
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', name: 'home', builder: (_, __) => const HomeScreen())
        ]),
        
        // Branch 1: Fitness (hub)
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/fitness',
            name: 'fitness',
            builder: (_, __) => const FitnessHubScreen(),
          )
        ]),
        
        // Branch 2: Finance
        StatefulShellBranch(routes: [
          GoRoute(path: '/finance', name: 'finance', builder: (_, __) => const FinanceHomeScreen())
        ]),
        
        // Branch 3: Journal
        StatefulShellBranch(routes: [
          GoRoute(path: '/journal', name: 'journal', builder: (_, __) => const JournalHomeScreen())
        ]),

        // Branch 4: Habits <--- MOVED HERE
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/habits', 
            name: 'habits', 
            builder: (_, __) => const HabitsHomeScreen()
          )
        ]),
      ],
    ),
    
    // --- Top-Level Routes ---
    // These routes will display full-screen and HIDE the bottom navigation bar.
    
    // Fitness sub‑modules
    GoRoute(
      path: '/gym',
      name: 'gym',
      builder: (_, __) => const GymHomeScreen(),
    ),
    GoRoute(
      path: '/boxing',
      name: 'boxing',
      builder: (_, __) => const BoxingHomeScreen(),
    ),
    GoRoute(
      path: '/running',
      name: 'running',
      builder: (_, __) => const RunningHomeScreen(),
    ),
    GoRoute(
      path: '/diet',
      name: 'diet',
      builder: (_, __) => const DietHomeScreen(),
    ),
    
    // Habits sub-modules
    GoRoute(
      path: '/habits/add',
      name: 'add-habit',
      builder: (_, __) => const AddHabitScreen(),
    ),

    // Journal sub-modules
    GoRoute(
      path: '/journal/create',
      name: 'create-journal',
      builder: (_, __) => const CreateJournalScreen(),
    ),
    GoRoute(
      path: '/journal/detail/:id',
      name: 'journal-detail',
      builder: (context, state) => JournalDetailScreen(journalId: state.pathParameters['id']!),
    ),
  ],
);