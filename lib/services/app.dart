import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:kaizen/services/router.dart';
import 'package:kaizen/core/theme/app_theme.dart';

import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class KaizenApp extends ConsumerWidget {
  const KaizenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialApp = ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Kaizen',
          theme: AppTheme.darkTheme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return SafeArea(
              top: true,
              bottom: false,
              child: widget ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );

    if (kIsWeb || Theme.of(context).platform == TargetPlatform.android) {
      return materialApp;
    }

    return LiquidGlassWidgets.wrap(
      adaptiveQuality: true,
      theme: GlassThemeData.simple(
        blur: 15,
        thickness: 30,
        quality: GlassQuality.standard,
      ),
      child: materialApp,
    );
  }
}