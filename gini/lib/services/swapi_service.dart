import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class SwapiService {
  static const String baseUrl = 'https://swapi.py4e.com/api';

  // Ajout d'un timeout pour les requêtes
  final Duration _timeout = const Duration(seconds: 15);

  /// Récupère les personnages par page
  Future<Map<String, dynamic>> fetchPeopleByPage(int page) async {
    try {
      // Afficher clairement l'URL pour le débogage
      final String url = '$baseUrl/people/?page=$page';
      print('Fetching data from: $url');

      // Ajouter un timeout à la requête
      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception('Request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Vérifier si les résultats existent et sont non vides
        if (!data.containsKey('results') || data['results'] == null) {
          throw Exception('Invalid response format: missing results');
        }

        // Convertir les résultats en objets Person
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

  /// Recherche des personnages par nom
  Future<Map<String, dynamic>> searchPeople(String query) async {
    try {
      // Encodage de l'URL pour gérer les caractères spéciaux
      final String encodedQuery = Uri.encodeComponent(query);
      final String url = '$baseUrl/people/?search=$encodedQuery';
      print('Searching for: $url');

      // Ajouter un timeout à la requête
      final response =
          await http.get(Uri.parse(url)).timeout(_timeout, onTimeout: () {
        throw Exception(
            'Search request timed out. Please check your connection.');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Vérifier si les résultats existent et sont non vides
        if (!data.containsKey('results') || data['results'] == null) {
          throw Exception('Invalid search response format: missing results');
        }

        // Convertir les résultats en objets Person
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

  /// Récupère les détails d'un personnage spécifique
  Future<Person> fetchPersonDetails(String url) async {
    try {
      print('Fetching details from: $url');

      // Ajouter un timeout à la requête
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

  /// Récupère les détails d'un personnage spécifique par URL
  Future<Person?> fetchPersonByUrl(String url) async {
    try {
      print('Fetching person from URL: $url');

      // Ajouter un timeout à la requête
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
}
