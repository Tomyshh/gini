import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/people_provider.dart';
import '../widgets/people_list_sliver.dart';
import '../widgets/search_bar_widget.dart';
import '../constants/theme.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Scroll controller à utiliser comme controller primaire
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    final scrolled = notification.metrics.pixels > 0;
    if (scrolled != _isScrolled) {
      setState(() {
        _isScrolled = scrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDarkMode ? AppTheme.tatooineGold : AppTheme.imperialBlue;
    final accentColor = isDarkMode ? AppTheme.rebellionRed : AppTheme.jediGreen;

    return Scaffold(
      backgroundColor: AppTheme.darkSide,
      body: Container(
        decoration: BoxDecoration(
          // Star Wars themed gradient background
          color: AppTheme.darkSide,
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitLayout(
                    context,
                    peopleProvider,
                    isDarkMode,
                    primaryColor,
                    accentColor,
                  )
                : _buildLandscapeLayout(
                    context,
                    peopleProvider,
                    isDarkMode,
                    primaryColor,
                    accentColor,
                  );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    PeopleProvider peopleProvider,
    bool isDarkMode,
    Color primaryColor,
    Color accentColor,
  ) {
    final isSearching = peopleProvider.isSearching;
    final searchQuery = peopleProvider.searchQuery;
    final count = peopleProvider.count;
    final isLoading = peopleProvider.isLoading;
    final allPagesLoaded = peopleProvider.allPagesLoaded;
    final statusText =
        _getStatusText(isSearching, searchQuery, count, allPagesLoaded);
    final backgroundColor =
        isDarkMode ? AppTheme.darkSide : const Color(0xFFF2F2F2);

    // Wrapper NotificationListener + PrimaryScrollController
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth == 0) {
          // seulement les notifications du premier niveau
          _handleScrollNotification(notification);
        }
        return false;
      },
      child: PrimaryScrollController(
        controller: _scrollController,
        child: CustomScrollView(
          // Ne pas définir de controller ici pour éviter l'attachement multiple
          physics: const BouncingScrollPhysics(),
          slivers: [
            // TITRE ET LOGO
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: backgroundColor,
                child: Stack(
                  children: [
                    // Star Wars Logo
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image logo
                          Padding(
                            padding: const EdgeInsets.only(top: kToolbarHeight),
                            child: Image.asset(
                              'assets/images/logo_yellow.png',
                              fit: BoxFit.cover,
                              scale: 10,
                            ),
                          ),

                          // Characters Subtitle
                          Text(
                            "Characters",
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 4.0,
                            ),
                          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BARRE DE RECHERCHE ET STATUS TEXT
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: backgroundColor,
              toolbarHeight: 100,
              surfaceTintColor: AppTheme.darkSide,
              flexibleSpace: Container(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(
                        bottom: 8,
                        top: kToolbarHeight,
                      ),
                      child: const SearchBarWidget(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        statusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // LISTE DES PERSONNAGES
            if (isLoading && peopleProvider.people.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              PeopleListSliver(
                isLoading: isLoading,
                hasNextPage: peopleProvider.hasNextPage,
                scrollController: _scrollController,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    PeopleProvider peopleProvider,
    bool isDarkMode,
    Color primaryColor,
    Color accentColor,
  ) {
    final isSearching = peopleProvider.isSearching;
    final searchQuery = peopleProvider.searchQuery;
    final count = peopleProvider.count;
    final isLoading = peopleProvider.isLoading;
    final allPagesLoaded = peopleProvider.allPagesLoaded;
    final statusText =
        _getStatusText(isSearching, searchQuery, count, allPagesLoaded);
    final backgroundColor =
        isDarkMode ? AppTheme.darkSide : const Color(0xFFF2F2F2);

    // Wrapper NotificationListener + PrimaryScrollController
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth == 0) {
          // seulement les notifications du premier niveau
          _handleScrollNotification(notification);
        }
        return false;
      },
      child: PrimaryScrollController(
        controller: _scrollController,
        child: CustomScrollView(
          // Ne pas définir de controller ici pour éviter l'attachement multiple
          physics: const BouncingScrollPhysics(),
          slivers: [
            // TITRE ET LOGO
            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: backgroundColor,
                child: Stack(
                  children: [
                    // Star Wars Logo en mode paysage
                    Positioned.fill(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo à gauche
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              child: Image.asset(
                                'assets/images/logo_yellow.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Characters à droite
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                "Characters",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3.0,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BARRE DE RECHERCHE ET STATUS TEXT
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: backgroundColor,
              toolbarHeight: 60,
              flexibleSpace: Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    // SearchBar
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 44,
                        margin: EdgeInsets.only(
                          left: _isScrolled ? kToolbarHeight * 0.5 : 0,
                        ),
                        child: const SearchBarWidget(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Status Text
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(_isScrolled ? 1 : 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          statusText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isScrolled ? Colors.white : accentColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // LISTE DES PERSONNAGES
            if (isLoading && peopleProvider.people.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              PeopleListSliver(
                isLoading: isLoading,
                hasNextPage: peopleProvider.hasNextPage,
                scrollController: _scrollController,
              ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(
      bool isSearching, String searchQuery, int count, bool allPagesLoaded) {
    if (isSearching && searchQuery.isNotEmpty) {
      return 'Results for "$searchQuery" - $count found';
    } else if (allPagesLoaded) {
      return 'All characters loaded - Sorted by height';
    } else {
      return 'Total: $count characters';
    }
  }
}

// Star Wars Background Pattern Painter
class StarWarsBackgroundPainter extends CustomPainter {
  final Color color;

  StarWarsBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Large stars
    for (int i = 0; i < 40; i++) {
      final x = i * (size.width / 40);
      final y = (i % 3) * 20.0 + (i / 3) * 15.0;
      final radius = (i % 4) * 1.0 + 1.0;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Small background dots
    for (int i = 0; i < 200; i++) {
      final x = (i * 17) % size.width;
      final y = (i * 19) % size.height;
      final radius = (i % 3) * 0.5 + 0.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Horizontal lines
    paint.strokeWidth = 0.5;
    for (int i = 0; i < 10; i++) {
      final y = (size.height / 12) * i;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Délégué pour le SliverPersistentHeader en mode paysage
class _SimpleSliverDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget Function(
      BuildContext context, double scrollOffset, bool overlapsContent) builder;

  _SimpleSliverDelegate({
    required this.height,
    required this.builder,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: builder(context, shrinkOffset, overlapsContent),
    );
  }

  @override
  bool shouldRebuild(_SimpleSliverDelegate oldDelegate) {
    return height != oldDelegate.height || builder != oldDelegate.builder;
  }
}
