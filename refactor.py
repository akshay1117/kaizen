import os
import re

package_name = "optimos"

# Mapping of old paths (relative to lib/) to new paths (relative to lib/)
file_moves = {
    "core/database/habits_dao.g.dart": "model/habits_dao.g.dart",
    "core/database/database.dart": "model/database.dart",
    "core/database/habits_dao.dart": "model/habits_dao.dart",
    "core/database/database.g.dart": "model/database.g.dart",

    "core/theme/app_theme.dart": "services/app_theme.dart",
    "core/theme/design_tokens.dart": "services/design_tokens.dart",
    "app/router.dart": "services/router.dart",
    "app/app.dart": "services/app.dart",

    "features/journal/journal_home_screen.dart": "view/screen/journal_home_screen.dart",
    "features/home/home_screen.dart": "view/screen/home_screen.dart",
    "features/running/running_home_screen.dart": "view/screen/running_home_screen.dart",
    "features/habits/screens/habits_home_screen.dart": "view/screen/habits_home_screen.dart",
    "features/habits/screens/add_habit_screen.dart": "view/screen/add_habit_screen.dart",
    "features/diet/diet_home_screen.dart": "view/screen/diet_home_screen.dart",
    "features/gym/gym_home_screen.dart": "view/screen/gym_home_screen.dart",
    "features/finance/finance_home_screen.dart": "view/screen/finance_home_screen.dart",
    "features/fitness/fitness_hub_screen.dart": "view/screen/fitness_hub_screen.dart",
    "features/boxing/boxing_home_screen.dart": "view/screen/boxing_home_screen.dart",

    "features/habits/providers/habit_providers.dart": "controller/habit_providers.dart",

    "shared/widgets/stat_mini.dart": "view/widget/stat_mini.dart",
    "shared/widgets/habit_tile.dart": "view/widget/habit_tile.dart",
    "shared/widgets/scaffold_with_nav_bar.dart": "view/widget/scaffold_with_nav_bar.dart",
    
    "main.dart": "main.dart"
}

def resolve_import(current_file_path, import_str):
    if import_str.startswith("package:optimos/"):
        return import_str.replace("package:optimos/", "")
    if import_str.startswith("package:"):
        return None
    if import_str.startswith("dart:"):
        return None
    
    # It's a relative import
    # current_file_path is relative to lib/ (e.g. features/home/home_screen.dart)
    current_dir = os.path.dirname(current_file_path)
    # import_str might be '../../core/theme/design_tokens.dart'
    
    # Handle the fact that current_dir can be empty if it's main.dart
    if current_dir == "":
        resolved_path = os.path.normpath(import_str)
    else:
        resolved_path = os.path.normpath(os.path.join(current_dir, import_str))
        
    # Python's normpath on macOS/Linux resolves .. correctly
    return resolved_path

def get_new_import_string(current_file_new_path, target_file_new_path):
    # Using absolute package imports for simplicity and avoiding relative path hell
    return f"package:{package_name}/{target_file_new_path}"

# 1. First, create directories
os.makedirs("lib/view/screen", exist_ok=True)
os.makedirs("lib/view/widget", exist_ok=True)
os.makedirs("lib/controller", exist_ok=True)
os.makedirs("lib/model", exist_ok=True)
os.makedirs("lib/services", exist_ok=True)

# 2. Process each file
for old_path, new_path in file_moves.items():
    old_full_path = os.path.join("lib", old_path)
    
    if not os.path.exists(old_full_path):
        continue
        
    with open(old_full_path, "r") as f:
        content = f.read()
        
    # Find all import statements
    def import_replacer(match):
        import_str = match.group(1)
        # resolve to lib/ path
        resolved_old_path = resolve_import(old_path, import_str)
        if resolved_old_path and resolved_old_path in file_moves:
            # We found an import that needs to be updated
            target_new_path = file_moves[resolved_old_path]
            # Replace with package: import
            new_import = f"package:{package_name}/{target_new_path}"
            return f"import '{new_import}'"
        return match.group(0) # don't change
        
    new_content = re.sub(r"import\s+'([^']+)'", import_replacer, content)
    
    # Save the updated content to the new path
    new_full_path = os.path.join("lib", new_path)
    with open(new_full_path, "w") as f:
        f.write(new_content)

print("Refactoring complete.")
