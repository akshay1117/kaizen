import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaizen/main.dart';
import 'package:kaizen/services/supabase_config.dart';
import 'package:kaizen/features/auth/presentation/screens/login_screen.dart';
import 'package:kaizen/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:kaizen/core/widgets/scaffold_with_nav_bar.dart';
import 'package:kaizen/features/dashboard/presentation/screens/home_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/fitness_hub_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/gym_screens.dart';
import 'package:kaizen/features/gym/presentation/screens/boxing_home_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/running_home_screen.dart';
import 'package:kaizen/features/diet/presentation/screens/diet_home_screen.dart';
import 'package:kaizen/features/habits/presentation/screens/habits_home_screen.dart';
import 'package:kaizen/features/habits/presentation/screens/add_habit_screen.dart';
import 'package:kaizen/features/journal/presentation/screens/journal_home_screen.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/analytics_screen.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/expense_tracker_screen.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/expense_detail_view.dart';
import 'package:kaizen/features/journal/presentation/screens/create_journal_screen.dart';
import 'package:kaizen/features/journal/presentation/screens/journal_detail_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/exercises_index_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/workout_detail_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/workout_template_screen.dart';
import 'package:kaizen/features/dashboard/presentation/screens/water_tracker_screen.dart';
import 'package:kaizen/features/dashboard/presentation/screens/sleep_tracker_screen.dart';
import 'package:kaizen/features/dashboard/presentation/screens/calorie_tracker_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final router = GoRouter(
  initialLocation: '/home',
  refreshListenable: GoRouterRefreshStream(SupabaseConfig.client.auth.onAuthStateChange),
  redirect: (BuildContext context, GoRouterState state) {
    final session = SupabaseConfig.client.auth.currentSession;
    final isLoggedIn = session != null;
    final isLoggingIn = state.matchedLocation == '/login';
    final hasCompletedOnboarding = globalPrefs.getBool('has_completed_onboarding') ?? false;
    final isOnboarding = state.matchedLocation == '/onboarding';

    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }
    if (isLoggedIn) {
      if (!hasCompletedOnboarding && !isOnboarding) {
        return '/onboarding';
      }
      if (hasCompletedOnboarding && (isLoggingIn || isOnboarding)) {
        return '/home';
      }
    }
    return null;
  },
  routes: [
    // Top-Level Auth Route
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
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
          GoRoute(path: '/finance', name: 'finance', builder: (_, __) => const ExpenseTrackerScreen())
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

    // Dashboard Trackers sub-modules
    GoRoute(
      path: '/water-tracker',
      name: 'water-tracker',
      builder: (_, __) => const WaterTrackerScreen(),
    ),
    GoRoute(
      path: '/sleep-tracker',
      name: 'sleep-tracker',
      builder: (_, __) => const SleepTrackerScreen(),
    ),
    GoRoute(
      path: '/calorie-tracker',
      name: 'calorie-tracker',
      builder: (_, __) => const CalorieTrackerScreen(),
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

    // Gym sub-modules
    GoRoute(
      path: '/gym/exercises',
      name: 'exercises-index',
      builder: (_, __) => const ExercisesIndexScreen(),
    ),
    GoRoute(
      path: '/gym/workout-template',
      name: 'workout-template',
      builder: (_, __) => const WorkoutTemplateScreen(),
    ),
    GoRoute(
      path: '/gym/workout',
      name: 'workout-detail',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return WorkoutDetailScreen(
          workoutId: args['workoutId'] as String,
          workoutName: args['workoutName'] as String,
        );
      },
    ),

    // Expense sub-modules
    GoRoute(
      path: '/expenses/analytics',
      name: 'analytics-expense',
      builder: (_, __) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/expenses/detail',
      name: 'expense-detail',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return ExpenseDetailView(
          title: args['title'] as String,
          amount: args['amount'] as String,
          category: args['category'] as String,
          date: args['date'] as String,
          onDelete: args['onDelete'] as void Function(),
        );
      },
    ),
  ],
);