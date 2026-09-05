import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class JournalImageWidget extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const JournalImageWidget({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) {
              return Scaffold(
                backgroundColor: AppColors.surfacePitchBlack.withValues(alpha: 0.9),
                body: Stack(
                  children: [
                    Center(
                      child: InteractiveViewer(
                        child: Hero(
                          tag: heroTag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[800], child: const Icon(Icons.image_not_supported, color: AppColors.textPrimary, size: 50)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 48,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 30),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              );
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[800], child: const Icon(Icons.image_not_supported, color: AppColors.textPrimary, size: 40)),
            ),
          ),
        ),
      ),
    );
  }
}
