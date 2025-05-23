import 'package:flutter/material.dart';

class MovieImage extends StatelessWidget {
  final String posterPath;

  const MovieImage({required this.posterPath, super.key});

  @override
  Widget build(BuildContext context) {
    if (posterPath == null || posterPath!.isEmpty) {
      return const Placeholder(fallbackHeight: 300); // or use a fallback image
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://image.tmdb.org/t/p/w500$posterPath',
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
            cacheWidth: constraints.maxWidth.toInt(), // Optimized width
            cacheHeight: 300, // Match display height
            loadingBuilder: (context, child, loadingProgress) {
              print("Loading progress: $loadingProgress");
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: double.infinity,
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
