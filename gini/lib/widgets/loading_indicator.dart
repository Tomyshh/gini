import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/theme.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? AppTheme.tatooineGold.withOpacity(0.2)
                  : AppTheme.imperialBlue.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? AppTheme.tatooineGold.withOpacity(0.3)
                : AppTheme.imperialBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading animation inspired by Star Wars universe
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                SpinKitRing(
                  color: isDarkMode
                      ? AppTheme.tatooineGold
                      : AppTheme.imperialBlue,
                  size: 60.0,
                  lineWidth: 4.0,
                ),
                // Inner ring (opposite direction)
                SpinKitRing(
                  color: AppTheme.rebellionRed.withOpacity(0.7),
                  size: 40.0,
                  lineWidth: 3.0,
                  duration: const Duration(milliseconds: 1200),
                ),
                // Center dot
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? AppTheme.jediGreen : AppTheme.rebellionRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode
                                ? AppTheme.jediGreen
                                : AppTheme.rebellionRed)
                            .withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.2, 1.2),
                      duration: 1.seconds,
                    ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              message ?? 'Loading data...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 12),
            Text(
              'May the Force be with you',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
