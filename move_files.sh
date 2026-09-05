#!/bin/bash
set -e

echo "Creating new directories..."
mkdir -p lib/core/widgets
mkdir -p lib/core/database
mkdir -p lib/features/dashboard/presentation/screens
mkdir -p lib/features/habits/presentation/screens
mkdir -p lib/features/habits/presentation/widgets
mkdir -p lib/features/habits/data
mkdir -p lib/features/habits/application
mkdir -p lib/features/habits/utils
mkdir -p lib/features/gym/presentation/screens
mkdir -p lib/features/gym/domain/models
mkdir -p lib/features/diet/presentation/screens
mkdir -p lib/features/expense_tracker/presentation/screens
mkdir -p lib/features/journal/presentation/screens

echo "Moving files from lib/view/widget/..."
mv lib/view/widget/scaffold_with_nav_bar.dart lib/core/widgets/
mv lib/view/widget/custom_bottom_nav_bar.dart lib/core/widgets/
mv lib/view/widget/category_wrap.dart lib/features/habits/presentation/widgets/
mv lib/view/widget/color_picker_grid.dart lib/features/habits/presentation/widgets/
mv lib/view/widget/icon_picker_grid.dart lib/features/habits/presentation/widgets/
mv lib/view/widget/icon_picker_sheet.dart lib/features/habits/presentation/widgets/
mv lib/view/widget/custom_option_tile.dart lib/features/habits/presentation/widgets/
mv lib/view/widget/tracking_segmented_control.dart lib/features/habits/presentation/widgets/
mv lib/view/widget/stat_mini.dart lib/features/habits/presentation/widgets/

echo "Moving files from lib/view/screen/..."
mv lib/view/screen/home_screen.dart lib/features/dashboard/presentation/screens/
mv lib/view/screen/add_habit_screen.dart lib/features/habits/presentation/screens/
mv lib/view/screen/habit_detail_screen.dart lib/features/habits/presentation/screens/
mv lib/view/screen/habits_home_screen.dart lib/features/habits/presentation/screens/
mv lib/view/screen/streak_goal_screen.dart lib/features/habits/presentation/screens/
mv lib/view/screen/reminder_screen.dart lib/features/habits/presentation/screens/
mv lib/view/screen/fitness_hub_screen.dart lib/features/gym/presentation/screens/
mv lib/view/screen/gym_screens.dart lib/features/gym/presentation/screens/
mv lib/view/screen/boxing_home_screen.dart lib/features/gym/presentation/screens/
mv lib/view/screen/running_home_screen.dart lib/features/gym/presentation/screens/
mv lib/view/screen/diet_home_screen.dart lib/features/diet/presentation/screens/
mv lib/view/screen/finance_home_screen.dart lib/features/expense_tracker/presentation/screens/
mv lib/view/screen/journal_home_screen.dart lib/features/journal/presentation/screens/

echo "Moving files from lib/model/..."
mv lib/model/database.dart lib/core/database/
mv lib/model/database.g.dart lib/core/database/
mv lib/model/habits_dao.dart lib/features/habits/data/
mv lib/model/habits_dao.g.dart lib/features/habits/data/
mv lib/model/gym_models.dart lib/features/gym/domain/models/

echo "Moving files from lib/controller/..."
mv lib/controller/habit_providers.dart lib/features/habits/application/
mv lib/controller/habit_stats_provider.dart lib/features/habits/application/

echo "Moving files from lib/utils/..."
mv lib/utils/habit_icons.dart lib/features/habits/utils/
mv lib/utils/icon_utils.dart lib/features/habits/utils/

echo "Deleting empty legacy folders..."
rm -r lib/view/widget
rm -r lib/view/screen
rmdir lib/view
rmdir lib/controller
rmdir lib/model
rmdir lib/utils

echo "File move complete."
