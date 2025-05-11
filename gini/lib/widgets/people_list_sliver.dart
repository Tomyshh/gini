import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/people_provider.dart';
import 'person_card.dart';
import 'loading_indicator.dart';

class PeopleListSliver extends StatefulWidget {
  final bool isLoading;
  final bool hasNextPage;
  final ScrollController? scrollController;

  const PeopleListSliver({
    super.key,
    required this.isLoading,
    required this.hasNextPage,
    this.scrollController,
  });

  @override
  State<PeopleListSliver> createState() => _PeopleListSliverState();
}

class _PeopleListSliverState extends State<PeopleListSliver> {
  final double _maxCardHeight = 250.0;
  ScrollController? _outerController;
  bool _isControllerAttached = false;

  @override
  void initState() {
    super.initState();
    _setupScrollController();
  }

  void _setupScrollController() {
    if (widget.scrollController != null) {
      _outerController = widget.scrollController;
      _outerController!.addListener(_onScroll);
      _isControllerAttached = true;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final controller = PrimaryScrollController.maybeOf(context);
        if (controller != null && !_isControllerAttached) {
          setState(() {
            _outerController = controller;
            _outerController!.addListener(_onScroll);
            _isControllerAttached = true;
          });
        }
      } catch (e) {
        debugPrint('Erreur lors de l\'accès au PrimaryScrollController: $e');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isControllerAttached) return;

    try {
      final controller = PrimaryScrollController.maybeOf(context);
      if (controller != null && !_isControllerAttached) {
        _outerController = controller;
        _outerController!.addListener(_onScroll);
        _isControllerAttached = true;
      }
    } catch (e) {
      debugPrint('Erreur dans didChangeDependencies: $e');
    }
  }

  @override
  void didUpdateWidget(PeopleListSliver oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scrollController != oldWidget.scrollController) {
      if (_isControllerAttached && _outerController != null) {
        _outerController!.removeListener(_onScroll);
        _isControllerAttached = false;
      }

      if (widget.scrollController != null) {
        _outerController = widget.scrollController;
        _outerController!.addListener(_onScroll);
        _isControllerAttached = true;
      } else {
        _setupScrollController();
      }
    }
  }

  @override
  void dispose() {
    if (_isControllerAttached && _outerController != null) {
      _outerController!.removeListener(_onScroll);
      _isControllerAttached = false;
      _outerController = null;
    }
    super.dispose();
  }

  void _onScroll() {
    if (_outerController == null || !_isControllerAttached) return;

    try {
      if (_outerController!.hasClients &&
          _outerController!.position.pixels >=
              _outerController!.position.maxScrollExtent - 50) {
        final provider = Provider.of<PeopleProvider>(context, listen: false);
        if (!provider.isLoading && provider.hasNextPage) {
          provider.loadMorePeople();
        }
      }
    } catch (e) {
      debugPrint('Erreur lors du défilement: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeopleProvider>(
      builder: (context, peopleProvider, child) {
        final people = peopleProvider.people;
        final hasError = peopleProvider.hasError;
        final isLoading = peopleProvider.isLoading;

        if (hasError && people.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${peopleProvider.errorMessage}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => peopleProvider.fetchPeople(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate([
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: people.length,
              itemBuilder: (context, index) {
                final person = people[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  child: PersonCard(
                    person: person,
                    maxHeight: _maxCardHeight,
                  ),
                );
              },
            ),
            if (widget.hasNextPage)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: isLoading
                      ? const LoadingIndicator(
                          message: 'Loading more characters...')
                      : TextButton(
                          onPressed: () {
                            final provider = Provider.of<PeopleProvider>(
                                context,
                                listen: false);
                            if (!provider.isLoading) {
                              provider.loadMorePeople();
                            }
                          },
                          child: const Text('Load More'),
                        ),
                ),
              ),
          ]),
        );
      },
    );
  }
}
