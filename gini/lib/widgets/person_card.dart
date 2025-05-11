import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/person.dart';
import '../providers/people_provider.dart';
import '../constants/theme.dart';
import 'dart:math' as math;

class PersonCard extends StatelessWidget {
  final Person person;
  final double maxHeight;

  const PersonCard({
    super.key,
    required this.person,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final heightValue = person.heightValue;
    final heightFactor = heightValue > 0 ? heightValue / 200 : 0.5;
    final scaledHeight = (maxHeight * heightFactor).clamp(60.0, maxHeight);
    final isFavorite = person.isFavorite;
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDarkMode ? AppTheme.tatooineGold : AppTheme.imperialBlue;

    return GestureDetector(
      onTap: () {
        // Add haptic feedback for better interaction
        HapticFeedback.mediumImpact();
        Provider.of<PeopleProvider>(context, listen: false)
            .setFavoritePerson(person);
      },
      child: Container(
        height: scaledHeight,
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isFavorite
              // Réduit l'opacité pour le fond favori et utilise une couleur plus sombre
              ? (isDarkMode ? const Color(0xFF5A4200) : const Color(0xFFE3F2FD))
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color:
                  isFavorite ? primaryColor.withOpacity(0.6) : Colors.black12,
              blurRadius: isFavorite ? 10.0 : 8.0,
              offset: const Offset(0, 4),
              spreadRadius: isFavorite ? 1.0 : 0.0,
            ),
          ],
          border:
              isFavorite ? Border.all(color: primaryColor, width: 2.0) : null,
          // Utilise un gradient moins intense pour le favori
          gradient: isFavorite
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          // Version sombre - fond doré moins intense
                          const Color(0xFF3C2E00),
                          const Color(0xFF4E3A00),
                          const Color(0xFF5A4200),
                        ]
                      : [
                          // Version claire - fond bleu moins intense
                          const Color(0xFFE3F2FD),
                          const Color(0xFFBBDEFB),
                          const Color(0xFFE3F2FD),
                        ],
                )
              : null,
        ),
        child: Stack(
          children: [
            // Star Wars background pattern for favorite using generated pattern
            if (isFavorite)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: CustomPaint(
                    painter: StarWarsPatternPainter(
                      color: primaryColor.withOpacity(0.07),
                    ),
                  ),
                ),
              ),

            Row(
              children: [
                // Height visualization (vertical bar on the left)
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: _getHeightColor(heightValue),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    // Lightsaber glow effect for favorite
                    boxShadow: isFavorite
                        ? [
                            BoxShadow(
                              color:
                                  _getHeightColor(heightValue).withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            // Add imperial/rebel icon based on height
                            if (isFavorite)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  heightValue > 180 ? Icons.public : Icons.face,
                                  color: primaryColor,
                                  size: 20,
                                ).animate().fadeIn().scale(),
                              ),

                            Expanded(
                              child: Text(
                                person.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isFavorite
                                      ? (isDarkMode
                                          ? Colors.white
                                          : AppTheme
                                              .imperialBlue) // Améliore le contraste
                                      : theme.colorScheme.onSurface,
                                  letterSpacing: isFavorite ? 0.5 : null,
                                  fontSize: isFavorite ? 18 : 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            if (isFavorite)
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                margin: const EdgeInsets.only(
                                    right: 30.0), // Espace pour le badge
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: AppTheme.tatooineGold,
                                  size: 24,
                                )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shimmer(
                                      duration: 2.seconds,
                                      color: Colors.white,
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .scale(
                                      begin: const Offset(1.0, 1.0),
                                      end: const Offset(1.1, 1.1),
                                      duration: 1.5.seconds,
                                    ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Height: ${person.height == "unknown" ? "Unknown" : "${person.height} cm"}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isFavorite
                                ? (isDarkMode
                                    ? Colors.white70
                                    : Colors.black87) // Améliore le contraste
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isFavorite ? FontWeight.w500 : null,
                          ),
                        ),
                        if (isFavorite) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Gender: ${_formatAttribute(person.gender)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors
                                            .black87, // Améliore le contraste
                                  ),
                                ),
                              ),
                              Text(
                                'Born: ${_formatAttribute(person.birthYear)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black87, // Améliore le contraste
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (heightValue > 0)
                                  Row(
                                    children: [
                                      Text(
                                        'Force level: ',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: isDarkMode
                                              ? Colors.white70
                                              : AppTheme.imperialBlue,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Expanded(
                                        child: ForceIndicator(
                                          value: (heightValue / 300)
                                              .clamp(0.0, 1.0),
                                          color: isDarkMode
                                              ? AppTheme.tatooineGold
                                              : AppTheme.imperialBlue,
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Favorite badge - repositionné et redessiné
            if (isFavorite)
              Positioned(
                top: -2,
                right: -2,
                child: FavoriteCornerBadge(
                  color: AppTheme.rebellionRed,
                ),
              ),

            // Favorite button
            Positioned(
              bottom: 8,
              right: 8,
              child: isFavorite
                  ? const SizedBox.shrink()
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Add haptic feedback for better interaction
                          HapticFeedback.lightImpact();
                          Provider.of<PeopleProvider>(context, listen: false)
                              .setFavoritePerson(person);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            color: AppTheme.rebellionRed.withOpacity(0.8),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).scale(
        begin: const Offset(0.95, 0.95),
        duration: 400.ms,
        curve: Curves.easeOutQuad);
  }

  Color _getHeightColor(int height) {
    if (height == 0) return Colors.grey;
    if (height < 100) return AppTheme.rebellionRed;
    if (height < 150) return AppTheme.tatooineGold;
    if (height < 180) return AppTheme.jediGreen;
    if (height < 220) return AppTheme.imperialBlue;
    return Colors.purple;
  }

  String _formatAttribute(String value) {
    if (value == 'unknown' || value.isEmpty) return 'Unknown';
    return value;
  }
}

// Nouveau badge de coin pour favori, plus élégant et mieux positionnné
class FavoriteCornerBadge extends StatelessWidget {
  final Color color;

  const FavoriteCornerBadge({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(70, 70),
            painter: CornerBadgePainter(
              color: color,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
          ),
          const Positioned(
            right: 8,
            top: 8,
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// Force level indicator
class ForceIndicator extends StatelessWidget {
  final double value;
  final Color color;

  const ForceIndicator({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      return Container(
        width: width,
        height: 8,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: width * value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.7),
                    color,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 0.2,
                  ),
                ],
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                    duration: 2.seconds, color: Colors.white.withOpacity(0.7)),
          ],
        ),
      );
    });
  }
}

// Custom painter for the Star Wars pattern background
class StarWarsPatternPainter extends CustomPainter {
  final Color color;

  StarWarsPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Small circles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Stars (Crosses)
    paint.strokeWidth = 1.5;
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 4 + 2;

      // Horizontal line
      canvas.drawLine(
        Offset(x - starSize, y),
        Offset(x + starSize, y),
        paint,
      );

      // Vertical line
      canvas.drawLine(
        Offset(x, y - starSize),
        Offset(x, y + starSize),
        paint,
      );
    }

    // Small dasked lines
    paint.strokeWidth = 1.0;
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final len = random.nextDouble() * 15 + 5;
      final angle = random.nextDouble() * math.pi * 2;

      final dx = math.cos(angle) * len;
      final dy = math.sin(angle) * len;

      canvas.drawLine(
        Offset(x, y),
        Offset(x + dx, y + dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Painter plus élégant pour le badge de coin
class CornerBadgePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  CornerBadgePainter({
    required this.color,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Corner badge shape
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    // Draw shadow
    canvas.drawShadow(path, shadowColor, 4, true);

    // Draw badge
    canvas.drawPath(path, paint);

    // Add decorative element
    final decorPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final decorPath = Path();
    decorPath.moveTo(size.width - 40, 0);
    decorPath.lineTo(size.width, 0);
    decorPath.lineTo(size.width, 40);

    canvas.drawPath(decorPath, decorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
