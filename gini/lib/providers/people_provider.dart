import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';
import '../services/swapi_service.dart';

class PeopleProvider with ChangeNotifier {
  final SwapiService _swapiService = SwapiService();
  static const String _favoritePersonKey = 'favorite_person_url';

  List<Person> _people = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  String? _nextPageUrl;
  String? _previousPageUrl;
  int _count = 0;
  String _searchQuery = '';
  bool _isSearching = false;
  bool _allPagesLoaded = false;
  int _currentPage = 1;
  Person? _favoritePerson;

  // Getters
  List<Person> get people => _people;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasNextPage => _nextPageUrl != null;
  bool get hasPreviousPage => _previousPageUrl != null;
  int get count => _count;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  bool get allPagesLoaded => _allPagesLoaded;
  Person? get favoritePerson => _favoritePerson;
  int get currentPage => _currentPage;

  // Initialiser le provider en chargeant la première page
  Future<void> initialize() async {
    if (_people.isEmpty && !_isLoading) {
      await _loadFavoriteFromPrefs();
      fetchPeople();
    }
  }

  // Charger le favori depuis SharedPreferences
  Future<void> _loadFavoriteFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteUrl = prefs.getString(_favoritePersonKey);

      if (favoriteUrl != null && favoriteUrl.isNotEmpty) {
        print("Loading favorite from prefs: $favoriteUrl");
        // On va chercher le détail du personnage via son URL
        final person = await _swapiService.fetchPersonByUrl(favoriteUrl);
        if (person != null) {
          person.isFavorite = true;
          _favoritePerson = person;
          print("Favorite person loaded: ${person.name}");
        }
      }
    } catch (e) {
      print("Error loading favorite from prefs: $e");
    }
  }

  // Sauvegarder le favori dans SharedPreferences
  Future<void> _saveFavoriteToPrefs(Person? person) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (person != null) {
        await prefs.setString(_favoritePersonKey, person.url);
        print("Saved favorite to prefs: ${person.name} (${person.url})");
      } else {
        await prefs.remove(_favoritePersonKey);
        print("Removed favorite from prefs");
      }
    } catch (e) {
      print("Error saving favorite to prefs: $e");
    }
  }

  // Method to fetch people for the first time
  Future<void> fetchPeople() async {
    print("Fetching first page of people...");
    if (_isLoading) {
      print("Already loading, ignoring request");
      return;
    }

    _setLoading(true);
    _hasError = false;
    _errorMessage = '';
    _currentPage = 1;
    _allPagesLoaded = false;

    try {
      final result = await _swapiService.fetchPeopleByPage(_currentPage);
      print("First page loaded: ${result['people'].length} people");
      _updatePeopleData(result);
    } catch (e) {
      print("Error fetching first page: $e");
      _setError('Error loading data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Method to load more people (pagination)
  Future<void> loadMorePeople() async {
    // Only load more if:
    // 1. Not already loading
    // 2. There's a next page
    // 3. Not all pages are loaded
    if (_isLoading) {
      print("Already loading, ignoring request for more people");
      return;
    }

    if (_nextPageUrl == null) {
      print("No next page URL, cannot load more");
      return;
    }

    if (_allPagesLoaded) {
      print("All pages already loaded");
      return;
    }

    print("Loading more people from page ${_currentPage + 1}...");
    _setLoading(true);

    try {
      // Increment current page
      _currentPage++;
      print("Loading page $_currentPage");

      // Fetch data from the new page
      final result = await _swapiService.fetchPeopleByPage(_currentPage);

      // Get new people
      final List<Person> newPeople = result['people'];
      print("Received ${newPeople.length} new people");

      // Ensure we don't have duplicates
      final List<Person> uniqueNewPeople = [];
      for (final newPerson in newPeople) {
        bool isDuplicate = false;
        for (final existingPerson in _people) {
          if (existingPerson.url == newPerson.url) {
            isDuplicate = true;
            break;
          }
        }
        if (!isDuplicate) {
          uniqueNewPeople.add(newPerson);
        }
      }

      print("After filtering: ${uniqueNewPeople.length} unique new people");

      // Add to existing people only if there are new ones
      if (uniqueNewPeople.isNotEmpty) {
        _people.addAll(uniqueNewPeople);
        print("People count now: ${_people.length}");
      }

      // Update pagination URLs
      _nextPageUrl = result['next'];
      _previousPageUrl = result['previous'];
      print("Next page URL: $_nextPageUrl");

      // If no next page, mark all pages as loaded and sort people by height
      if (_nextPageUrl == null) {
        _allPagesLoaded = true;
        print("All pages loaded, sorting by height");
        _sortPeopleByHeight();
      }

      // Notify listeners of changes
      notifyListeners();
    } catch (e) {
      print("Error loading more people: $e");
      _setError('Error loading more data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Method to search for people
  Future<void> searchPeople(String query) async {
    print("Searching for: '$query'");

    if (query.isEmpty) {
      print("Empty query, resetting to normal view");
      _isSearching = false;
      _searchQuery = '';
      _currentPage = 1;
      _allPagesLoaded = false;
      _nextPageUrl = null;
      _previousPageUrl = null;

      _people = []; // Clear the list first
      notifyListeners();

      return fetchPeople();
    }

    _searchQuery = query;
    _isSearching = true;
    _setLoading(true);
    _hasError = false;
    _errorMessage = '';

    try {
      final result = await _swapiService.searchPeople(query);
      print("Search results: ${result['people'].length} people");
      _updatePeopleData(result);

      // If no next page, mark all pages as loaded
      if (_nextPageUrl == null) {
        _allPagesLoaded = true;
      }
    } catch (e) {
      print("Search error: $e");
      _setError('Search error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set a person as favorite
  Future<void> setFavoritePerson(Person person) async {
    print("Setting ${person.name} as favorite");

    // Si c'est déjà le favori, on l'enlève
    if (_favoritePerson != null && _favoritePerson!.url == person.url) {
      final index = _people.indexWhere((p) => p.url == _favoritePerson!.url);
      if (index != -1) {
        _people[index].isFavorite = false;
        print("Removed favorite status from ${_people[index].name}");
      }
      _favoritePerson = null;
      await _saveFavoriteToPrefs(null);
      notifyListeners();
      return;
    }

    // Reset old favorite
    if (_favoritePerson != null) {
      final index = _people.indexWhere((p) => p.url == _favoritePerson!.url);
      if (index != -1) {
        _people[index].isFavorite = false;
        print("Removed favorite status from ${_people[index].name}");
      }
    }

    // Set new favorite
    final index = _people.indexWhere((p) => p.url == person.url);
    if (index != -1) {
      _people[index].isFavorite = true;
      _favoritePerson = _people[index];
      print("${person.name} is now favorite");
      await _saveFavoriteToPrefs(_favoritePerson);
    }

    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    notifyListeners();
  }

  void _updatePeopleData(Map<String, dynamic> result) {
    _people = result['people'];
    _nextPageUrl = result['next'];
    _previousPageUrl = result['previous'];
    _count = result['count'];
    print(
        "Updated people data: ${_people.length} people, nextPageUrl: $_nextPageUrl");

    // Restore favorite status if needed
    if (_favoritePerson != null) {
      final index = _people.indexWhere((p) => p.url == _favoritePerson!.url);
      if (index != -1) {
        _people[index].isFavorite = true;
        print("Restored favorite status for ${_people[index].name}");
      }
    }

    notifyListeners();
  }

  // Sort people by height
  void _sortPeopleByHeight() {
    print("Sorting ${_people.length} people by height");
    _people.sort((a, b) {
      final heightA = a.heightValue;
      final heightB = b.heightValue;

      // Place unknown heights (0) at the end
      if (heightA == 0) return 1;
      if (heightB == 0) return -1;

      return heightA.compareTo(heightB);
    });
    print("Sorting complete");

    notifyListeners();
  }
}
