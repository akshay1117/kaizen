import re

with open('lib/features/dashboard/presentation/screens/home_screen.dart', 'r') as f:
    content = f.read()

# Fix HomeScreen layout
if "const _DashboardMetricsGrid()" not in content:
    content = content.replace(
        "const _StreaksRow(),\n                  const SizedBox(height: 100),",
        "const _StreaksRow(),\n                  const SizedBox(height: 16),\n                  const _DashboardMetricsGrid(),\n                  const SizedBox(height: 100),"
    )

# Fix unnecessary string interpolation in _StreakMiniCard (which is now around line 350)
content = content.replace("'$days'", "days")

# Fix _DashboardMetricsGrid consts
content = content.replace("const Expanded(\n          flex: 1,\n          child: _WaterIntakeCard(),", "Expanded(\n          flex: 1,\n          child: const _WaterIntakeCard(),")
content = content.replace("Expanded(\n          flex: 1,\n          child: Column(\n            children: const [\n              _SleepCard(),\n              SizedBox(height: 16),\n              _CaloriesCard(),\n            ],\n          ),\n        ),", "Expanded(\n          flex: 1,\n          child: Column(\n            children: const [\n              _SleepCard(),\n              SizedBox(height: 16),\n              _CaloriesCard(),\n            ],\n          ),\n        ),")

# Fix _DashedLinePainter consts
content = content.replace("final double startY = 16;", "const double startY = 16;")
content = content.replace("final double endY = size.height;", "final double endY = size.height;") # wait, size is not const

# Fix CaloriesCard consts
content = content.replace("const Text(\n                        '230kCal',", "const Text(\n                        '230kCal',")

with open('lib/features/dashboard/presentation/screens/home_screen.dart', 'w') as f:
    f.write(content)
