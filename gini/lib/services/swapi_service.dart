import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';
import '../models/film.dart';
import '../models/species.dart';
import '../models/vehicle.dart';
import '../models/starship.dart';
import '../models/planet.dart';

class SwapiService {
  static const String baseUrl = 'https://swapi.py4e.com/api';

  // Added timeout for requests
  final Duration _timeout = const Duration(seconds: 15);

  /// Fetches characters by page
  Future<Map<String, dynamic>> fetchPeopleByPage(int page) async {
    try {
      // Display URL clearly for debugging
      final String url = '$baseUrl/people/?page=$page';
      print('Fetching data from: $url');

      // Add timeout to the request
      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception('Request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if results exist and are not empty
        if (!data.containsKey('results') || data['results'] == null) {
          throw Exception('Invalid response format: missing results');
        }

        // Convert results to Person objects
        final List<dynamic> results = data['results'];
        final List<Person> people =
            results.map((personData) => Person.fromJson(personData)).toList();

        print('Loaded ${people.length} characters from page $page');

        return {
          'people': people,
          'next': data['next'],
          'previous': data['previous'],
          'count': data['count'] ?? 0,
        };
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Connection error: $e');
    }
  }

  /// Search characters by name
  Future<Map<String, dynamic>> searchPeople(String query) async {
    try {
      // URL encoding to handle special characters
      final String encodedQuery = Uri.encodeComponent(query);
      final String url = '$baseUrl/people/?search=$encodedQuery';
      print('Searching for: $url');

      // Add timeout to the request
      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception(
            'Search request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if results exist and are not empty
        if (!data.containsKey('results') || data['results'] == null) {
          throw Exception('Invalid search response format: missing results');
        }

        // Convert results to Person objects
        final List<dynamic> results = data['results'];
        final List<Person> people =
            results.map((personData) => Person.fromJson(personData)).toList();

        print('Found ${people.length} characters matching "$query"');

        return {
          'people': people,
          'next': data['next'],
          'previous': data['previous'],
          'count': data['count'] ?? 0,
        };
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during search: $e');
      throw Exception('Connection error: $e');
    }
  }

  /// Fetch details of a specific character
  Future<Person> fetchPersonDetails(String url) async {
    try {
      print('Fetching details from: $url');

      // Add timeout to the request
      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception(
            'Details request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Person.fromJson(data);
      } else {
        throw Exception('Failed to load details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching person details: $e');
      throw Exception('Connection error: $e');
    }
  }

  /// Fetch details of a specific character by URL
  Future<Person?> fetchPersonByUrl(String url) async {
    try {
      print('Fetching person from URL: $url');

      // Add timeout to the request
      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception(
            'Details request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Person.fromJson(data);
      } else {
        print('Failed to load person by URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching person by URL: $e');
      return null;
    }
  }

  /// Fetch details of a film by URL
  Future<Film?> fetchFilmByUrl(String url) async {
    try {
      print('Fetching film from URL: $url');

      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception('Request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Film.fromJson(data);
      } else {
        print('Failed to load film by URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching film by URL: $e');
      return null;
    }
  }

  /// Fetch details of a species by URL
  Future<Species?> fetchSpeciesByUrl(String url) async {
    try {
      print('Fetching species from URL: $url');

      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception('Request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Species.fromJson(data);
      } else {
        print('Failed to load species by URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching species by URL: $e');
      return null;
    }
  }

  /// Fetch details of a vehicle by URL
  Future<Vehicle?> fetchVehicleByUrl(String url) async {
    try {
      print('Fetching vehicle from URL: $url');

      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception('Request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Vehicle.fromJson(data);
      } else {
        print('Failed to load vehicle by URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching vehicle by URL: $e');
      return null;
    }
  }

  /// Fetch details of a starship by URL
  Future<Starship?> fetchStarshipByUrl(String url) async {
    try {
      print('Fetching starship from URL: $url');

      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception('Request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Starship.fromJson(data);
      } else {
        print('Failed to load starship by URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching starship by URL: $e');
      return null;
    }
  }

  /// Fetch details of a planet by URL
  Future<Planet?> fetchPlanetByUrl(String url) async {
    try {
      print('Fetching planet from URL: $url');

      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception('Request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Planet.fromJson(data);
      } else {
        print('Failed to load planet by URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching planet by URL: $e');
      return null;
    }
  }
}
