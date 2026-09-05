import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingCreateButton extends StatefulWidget {
  const FloatingCreateButton({super.key});

  @override
  State<FloatingCreateButton> createState() => _FloatingCreateButtonState();
}

class _FloatingCreateButtonState extends State<FloatingCreateButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Hero(
        tag: 'journal_fab',
        child: Material(
          color: AppColors.accentViolet,
          shape: const CircleBorder(),

          shadowColor: AppColors.accentViolet.withValues(alpha: 0.5),
          child: InkWell(
            onTap: () {
              context.push('/journal/create');
            },
            customBorder: const CircleBorder(),
            splashColor: AppColors.textPrimary.withValues(alpha: 0.3),
            child: const SizedBox(
              width: 64,
              height: 64,
              child: Icon(
                Icons.add,
                size: 32,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
