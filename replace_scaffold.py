import os
import glob

# Search in specific directories
directories = [
    "lib/features/gym/presentation/screens",
    "lib/features/expenses/presentation/screens",
    "lib/features/journal/presentation/screens",
    "lib/view/screen"
]

import_statement = "import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';\n"

for d in directories:
    for filepath in glob.glob(d + "/*.dart"):
        with open(filepath, 'r') as f:
            content = f.read()

        if "Scaffold(" in content or "AppBar(" in content:
            new_content = content.replace("Scaffold(", "GlassScaffold(")
            new_content = new_content.replace("AppBar(", "GlassAppBar(")
            
            # Insert the import statement after the first import
            if import_statement not in new_content:
                lines = new_content.split('\n')
                for i, line in enumerate(lines):
                    if line.startswith("import "):
                        lines.insert(i + 1, import_statement.strip())
                        break
                new_content = '\n'.join(lines)
            
            with open(filepath, 'w') as f:
                f.write(new_content)
            print(f"Updated {filepath}")

# Update scaffold_with_nav_bar.dart import as well
with open("lib/view/widget/scaffold_with_nav_bar.dart", "r") as f:
    content = f.read()
if import_statement not in content:
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if line.startswith("import "):
            lines.insert(i + 1, import_statement.strip())
            break
    with open("lib/view/widget/scaffold_with_nav_bar.dart", "w") as f:
        f.write('\n'.join(lines))
    print("Updated lib/view/widget/scaffold_with_nav_bar.dart")

