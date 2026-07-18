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
                backgroundColor: Colors.black.withValues(alpha: 0.9),
                body: Stack(
                  children: [
                    Center(
                      child: InteractiveViewer(
                        child: Hero(
                          tag: heroTag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[800], child: const Icon(Icons.image_not_supported, color: Colors.white, size: 50)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 48,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
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
                  Container(color: Colors.grey[800], child: const Icon(Icons.image_not_supported, color: Colors.white, size: 40)),
            ),
          ),
        ),
      ),
    );
  }
}
