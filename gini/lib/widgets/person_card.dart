import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gini/constants/text_styles.dart';
import 'package:provider/provider.dart';
import '../models/person.dart';
import '../providers/people_provider.dart';
import '../constants/theme.dart';
import '../screens/person_detail_screen.dart';
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
    // Hauteur minimale garantie et hauteur maximum limitée pour éviter l'overflow
    final scaledHeight = (maxHeight * heightFactor).clamp(130.0, maxHeight);
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
      child: Hero(
        tag: 'person_${person.url}',
        child: Material(
          elevation: isFavorite ? 8 : 2,
          shadowColor: isFavorite
              ? primaryColor.withOpacity(0.5)
              : Colors.black.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            // Fixed height for favorites, adaptive for others, with minimum guaranteed
            height: isFavorite ? math.max(scaledHeight, 300) : scaledHeight,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              border: isFavorite
                  ? Border.all(
                      color: primaryColor.withOpacity(0.7),
                      width: 1.5,
                    )
                  : null,
              gradient: isFavorite
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [
                              // Dark version - elegant
                              const Color(0xFF2D2101),
                              const Color(0xFF352701),
                              const Color(0xFF40300A),
                            ]
                          : [
                              // Light version - elegant
                              const Color(0xFFEBF5FE),
                              const Color(0xFFE3F2FD),
                              const Color(0xFFD6EBFC),
                            ],
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                children: [
                  // Subtle background pattern for favorites
                  if (isFavorite)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: StarWarsPatternPainter(
                          color: primaryColor.withOpacity(0.06),
                          density: 0.6, // Less dense
                        ),
                      ),
                    ),

                  // Main structure
                  Row(
                    children: [
                      // Side bar integrated with height indicator
                      Container(
                        width: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _getHeightColor(heightValue),
                              _getHeightColor(heightValue).withOpacity(0.7),
                            ],
                          ),
                          // No radius for perfect integration
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name with possible icon/badge
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      person.name,
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isFavorite
                                            ? (isDarkMode
                                                ? Colors.white
                                                : AppTheme.imperialBlue)
                                            : theme.colorScheme.onSurface,
                                        fontSize: 22,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // Favorite indicator on the same line as the title
                                  if (isFavorite)
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? Colors.white.withOpacity(0.15)
                                            : primaryColor.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.star,
                                        color: AppTheme.tatooineGold,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Main information block in line
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildInfoItem(
                                      context,
                                      Icons.height,
                                      '${person.height == "unknown" ? "?" : "${person.height}"}',
                                      'cm',
                                      isDarkMode,
                                      isFavorite),
                                  const SizedBox(width: 16),
                                  _buildInfoItem(
                                      context,
                                      person.gender
                                              .toLowerCase()
                                              .contains('male')
                                          ? Icons.male
                                          : person.gender
                                                  .toLowerCase()
                                                  .contains('female')
                                              ? Icons.female
                                              : Icons.question_mark,
                                      _formatAttribute(person.gender),
                                      '',
                                      isDarkMode,
                                      isFavorite),
                                  const SizedBox(width: 16),
                                  _buildInfoItem(
                                      context,
                                      Icons.cake_outlined,
                                      _formatAttribute(person.birthYear),
                                      '',
                                      isDarkMode,
                                      isFavorite),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Force indicator
                              if (heightValue > 0) ...[
                                Row(
                                  children: [
                                    Text(
                                      'Force:',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: isFavorite
                                            ? (isDarkMode
                                                ? Colors.white70
                                                : Colors.black87)
                                            : theme
                                                .colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ForceIndicator(
                                        value:
                                            (heightValue / 300).clamp(0.0, 1.0),
                                        color: isFavorite
                                            ? (isDarkMode
                                                ? AppTheme.tatooineGold
                                                : AppTheme.imperialBlue)
                                            : _getHeightColor(heightValue),
                                        height: 8.0,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${heightValue}',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: isFavorite
                                            ? (isDarkMode
                                                ? Colors.white70
                                                : Colors.black87)
                                            : theme
                                                .colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              // Details button
                              const Spacer(),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigation with Cupertino transition
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            PersonDetailScreen(person: person),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    'Details',
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                ),
                              ),

                              // Additional information for favorites - only if height allows
                              if (isFavorite) ...[
                                const SizedBox(height: 12),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.black.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildFavoriteDetail(
                                          context,
                                          'Eyes',
                                          _formatAttribute(person.eyeColor),
                                          isDarkMode),
                                      Container(
                                        height: 24,
                                        width: 1,
                                        color: isDarkMode
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.black.withOpacity(0.1),
                                      ),
                                      _buildFavoriteDetail(
                                          context,
                                          'Hair',
                                          _formatAttribute(person.hairColor),
                                          isDarkMode),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Favorite button
                  if (!isFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Provider.of<PeopleProvider>(context, listen: false)
                                .setFavoritePerson(person);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite_border,
                              color: AppTheme.rebellionRed.withOpacity(0.8),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms).slideY(
          begin: 0.05,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String value,
      String unit, bool isDarkMode, bool isFavorite) {
    final textColor = isFavorite
        ? (isDarkMode ? Colors.white : Colors.black87)
        : Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: textColor.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
        ),
        if (unit.isNotEmpty)
          Text(
            ' $unit',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor.withOpacity(0.7),
                ),
          ),
      ],
    );
  }

  Widget _buildFavoriteDetail(
      BuildContext context, String label, String value, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDarkMode ? Colors.white60 : Colors.black54,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
        ),
      ],
    );
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
    if (value == 'unknown' || value.isEmpty) return "N/a";
    // Capitalize first letter
    return value[0].toUpperCase() + value.substring(1);
  }
}

// Enhanced force level indicator
class ForceIndicator extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const ForceIndicator({
    super.key,
    required this.value,
    required this.color,
    this.height = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Stack(
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
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Custom painter for the Star Wars pattern background - simplified and less cluttered
class StarWarsPatternPainter extends CustomPainter {
  final Color color;
  final double density;

  StarWarsPatternPainter({required this.color, this.density = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern
    final dotCount = (40 * density).toInt();

    // Small dots only - more elegant
    for (int i = 0; i < dotCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Small stars (smaller and fewer)
    paint.strokeWidth = 1.0;
    for (int i = 0; i < (10 * density).toInt(); i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2 + 1;

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
