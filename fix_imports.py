import os
import re

lib_dir = 'lib'

# Mapping of file names to their new absolute package imports
# This is the safest way to fix relative or absolute imports: if a file imports X, replace it with the new absolute path of X.
# Wait, this might replace variable names if we are not careful. We should only replace inside import statements.

new_paths = {
    'home_screen.dart': 'package:kaizen/features/dashboard/presentation/screens/home_screen.dart',
    
    'add_habit_screen.dart': 'package:kaizen/features/habits/presentation/screens/add_habit_screen.dart',
    'habit_detail_screen.dart': 'package:kaizen/features/habits/presentation/screens/habit_detail_screen.dart',
    'habits_home_screen.dart': 'package:kaizen/features/habits/presentation/screens/habits_home_screen.dart',
    'streak_goal_screen.dart': 'package:kaizen/features/habits/presentation/screens/streak_goal_screen.dart',
    'reminder_screen.dart': 'package:kaizen/features/habits/presentation/screens/reminder_screen.dart',
    
    'category_wrap.dart': 'package:kaizen/features/habits/presentation/widgets/category_wrap.dart',
    'color_picker_grid.dart': 'package:kaizen/features/habits/presentation/widgets/color_picker_grid.dart',
    'icon_picker_grid.dart': 'package:kaizen/features/habits/presentation/widgets/icon_picker_grid.dart',
    'icon_picker_sheet.dart': 'package:kaizen/features/habits/presentation/widgets/icon_picker_sheet.dart',
    'custom_option_tile.dart': 'package:kaizen/features/habits/presentation/widgets/custom_option_tile.dart',
    'tracking_segmented_control.dart': 'package:kaizen/features/habits/presentation/widgets/tracking_segmented_control.dart',
    'stat_mini.dart': 'package:kaizen/features/habits/presentation/widgets/stat_mini.dart',
    
    'scaffold_with_nav_bar.dart': 'package:kaizen/core/widgets/scaffold_with_nav_bar.dart',
    'custom_bottom_nav_bar.dart': 'package:kaizen/core/widgets/custom_bottom_nav_bar.dart',
    
    'fitness_hub_screen.dart': 'package:kaizen/features/gym/presentation/screens/fitness_hub_screen.dart',
    'gym_screens.dart': 'package:kaizen/features/gym/presentation/screens/gym_screens.dart',
    'boxing_home_screen.dart': 'package:kaizen/features/gym/presentation/screens/boxing_home_screen.dart',
    'running_home_screen.dart': 'package:kaizen/features/gym/presentation/screens/running_home_screen.dart',
    'diet_home_screen.dart': 'package:kaizen/features/diet/presentation/screens/diet_home_screen.dart',
    
    'finance_home_screen.dart': 'package:kaizen/features/expense_tracker/presentation/screens/finance_home_screen.dart',
    'journal_home_screen.dart': 'package:kaizen/features/journal/presentation/screens/journal_home_screen.dart',
    
    'database.dart': 'package:kaizen/core/database/database.dart',
    'database.g.dart': 'package:kaizen/core/database/database.g.dart',
    'habits_dao.dart': 'package:kaizen/features/habits/data/habits_dao.dart',
    'habits_dao.g.dart': 'package:kaizen/features/habits/data/habits_dao.g.dart',
    'gym_models.dart': 'package:kaizen/features/gym/domain/models/gym_models.dart',
    
    'habit_providers.dart': 'package:kaizen/features/habits/application/habit_providers.dart',
    'habit_stats_provider.dart': 'package:kaizen/features/habits/application/habit_stats_provider.dart',
    
    'habit_icons.dart': 'package:kaizen/features/habits/utils/habit_icons.dart',
    'icon_utils.dart': 'package:kaizen/features/habits/utils/icon_utils.dart',
}

import_pattern = re.compile(r"""^import\s+['"]([^'"]+)['"];""", re.MULTILINE)

def fix_imports(content):
    def replace_match(match):
        orig = match.group(1)
        filename = orig.split('/')[-1]
        
        # If it's one of the files we moved, rewrite to its absolute path
        if filename in new_paths:
            # Only rewrite if it previously looked like a relative import or a legacy package import
            # We don't want to break things that are already fine, but everything here is new.
            return f"import '{new_paths[filename]}';"
            
        # Also replace standard path prefixes if they are absolute package imports
        orig_mod = orig
        orig_mod = orig_mod.replace('package:kaizen/view/screen/', 'package:kaizen/features/dashboard/presentation/screens/') # Just a generic fallback
        # Let the filename mapping handle most
        return f"import '{orig}';"

    return import_pattern.sub(replace_match, content)


for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r') as f:
                original = f.read()
            
            modified = fix_imports(original)
            
            if original != modified:
                with open(filepath, 'w') as f:
                    f.write(modified)
                print(f"Fixed imports in {filepath}")

