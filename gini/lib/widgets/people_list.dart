import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/people_provider.dart';
import 'person_card.dart';
import 'loading_indicator.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key});

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  final ScrollController _scrollController = ScrollController();
  final double _maxCardHeight = 250.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PeopleProvider>(context, listen: false).fetchPeople();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<PeopleProvider>(context, listen: false);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !provider.isLoading &&
        provider.hasNextPage) {
      provider.loadMorePeople();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeopleProvider>(
      builder: (context, peopleProvider, child) {
        final people = peopleProvider.people;
        final isLoading = peopleProvider.isLoading;
        final hasError = peopleProvider.hasError;

        if (isLoading && people.isEmpty) {
          return const LoadingIndicator();
        }

        if (hasError && people.isEmpty) {
          return Center(
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
          );
        }

        return Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 70),
              itemCount: people.length + (peopleProvider.hasNextPage ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == people.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child:
                        LoadingIndicator(message: 'Loading more characters...'),
                  );
                }

                return PersonCard(
                  person: people[index],
                  maxHeight: _maxCardHeight,
                );
              },
            ),

            // Loading indicator for search or initial loading
            /* if (isLoading && people.isNotEmpty)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Loading...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),*/
          ],
        );
      },
    );
  }
}
